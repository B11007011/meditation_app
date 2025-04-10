import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:meditation_app/features/sleep/domain/models/sleep_story.dart';
import 'package:meditation_app/shared/services/analytics_service.dart';

enum SleepPlaybackState {
  stopped,
  loading,
  playing,
  paused,
}

class SleepPlayerService {
  // Singleton pattern
  static final SleepPlayerService _instance = SleepPlayerService._internal();
  factory SleepPlayerService() => _instance;
  SleepPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();
  final AnalyticsService _analytics = AnalyticsService();
  
  SleepStory? _currentStory;
  SleepPlaybackState _state = SleepPlaybackState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  Timer? _sleepTimer;
  int? _sleepTimerMinutes;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  
  SleepPlaybackState get state => _state;
  SleepStory? get currentStory => _currentStory;
  Duration get position => _position;
  Duration get duration => _duration;
  int? get sleepTimerMinutes => _sleepTimerMinutes;
  
  Future<void> initialize() async {
    try {
      // Set up position listener
      _positionSubscription = _player.onPositionChanged.listen((p) {
        _position = p;
      });
      
      // Set up duration listener
      _durationSubscription = _player.onDurationChanged.listen((d) {
        _duration = d;
      });
      
      // Set up player state listener
      _playerStateSubscription = _player.onPlayerStateChanged.listen((state) {
        if (state == PlayerState.completed) {
          _state = SleepPlaybackState.stopped;
          _position = Duration.zero;
          _analytics.logEvent('sleep_story_completed', parameters: {
            'story_id': _currentStory?.id ?? 'unknown',
            'story_title': _currentStory?.title ?? 'unknown',
          });
        }
      });
      
      // Initialize with a low volume suitable for sleep
      await _player.setVolume(0.5);
      
      // Initialize player with balanced mode
      await _player.setReleaseMode(ReleaseMode.stop);
      
    } catch (e) {
      debugPrint('Error initializing sleep player service: $e');
      rethrow;
    }
  }
  
  Future<void> play(SleepStory story) async {
    state = SleepPlaybackState.loading;
    try {
      // If already playing the same story, resume instead
      if (_currentStory?.id == story.id && state == SleepPlaybackState.paused) {
        return resume();
      }

      // Stop any currently playing story
      if (state != SleepPlaybackState.stopped) {
        await stop();
      }

      _currentStory = story;
      
      // Use local file if downloaded, otherwise use the URL
      if (story.isDownloaded && story.localAudioPath != null) {
        await _player.play(DeviceFileSource(story.localAudioPath!));
      } else if (story.audioUrl != null) {
        await _player.play(UrlSource(story.audioUrl!));
      } else {
        throw Exception('No audio source available for this sleep story');
      }

      _state = SleepPlaybackState.playing;
      
      _analytics.logEvent('sleep_story_started', parameters: {
        'story_id': story.id,
        'story_title': story.title,
        'story_type': story.type,
        'is_downloaded': story.isDownloaded,
      });
    } catch (e) {
      debugPrint('Error playing sleep story: $e');
      _state = SleepPlaybackState.stopped;
      rethrow;
    }
  }
  
  Future<void> pause() async {
    await _player.pause();
    _state = SleepPlaybackState.paused;
    
    _analytics.logEvent('sleep_story_paused', parameters: {
      'story_id': _currentStory?.id ?? 'unknown',
      'position_seconds': _position.inSeconds,
    });
  }
  
  Future<void> resume() async {
    await _player.resume();
    _state = SleepPlaybackState.playing;
    
    _analytics.logEvent('sleep_story_resumed', parameters: {
      'story_id': _currentStory?.id ?? 'unknown',
      'position_seconds': _position.inSeconds,
    });
  }
  
  Future<void> stop() async {
    await _player.stop();
    _state = SleepPlaybackState.stopped;
    _position = Duration.zero;
    
    if (_currentStory != null) {
      _analytics.logEvent('sleep_story_stopped', parameters: {
        'story_id': _currentStory!.id,
        'position_seconds': _position.inSeconds,
      });
    }
  }
  
  Future<void> seek(Duration position) async {
    await _player.seek(position);
    _position = position;
  }
  
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
    
    _analytics.logEvent('sleep_volume_changed', parameters: {
      'volume': volume,
      'story_id': _currentStory?.id ?? 'unknown',
    });
  }
  
  void setSleepTimer(int minutes) {
    // Cancel existing timer if any
    _sleepTimer?.cancel();
    
    // Set new timer
    _sleepTimerMinutes = minutes;
    _sleepTimer = Timer(Duration(minutes: minutes), () async {
      // Fade out volume over 10 seconds before stopping
      for (int i = 10; i >= 0; i--) {
        await _player.setVolume(i / 10);
        await Future.delayed(const Duration(seconds: 1));
      }
      
      await stop();
      
      // Reset volume for next playback
      await _player.setVolume(0.5);
      
      _sleepTimerMinutes = null;
      
      _analytics.logEvent('sleep_timer_completed', parameters: {
        'minutes': minutes,
        'story_id': _currentStory?.id ?? 'unknown',
      });
    });
    
    _analytics.logEvent('sleep_timer_set', parameters: {
      'minutes': minutes,
      'story_id': _currentStory?.id ?? 'unknown',
    });
  }
  
  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimerMinutes = null;
    
    _analytics.logEvent('sleep_timer_cancelled', parameters: {
      'story_id': _currentStory?.id ?? 'unknown',
    });
  }
  
  Future<void> dispose() async {
    _sleepTimer?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    await _player.dispose();
  }
  
  set state(SleepPlaybackState newState) {
    _state = newState;
  }
} 