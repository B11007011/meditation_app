import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:meditation_app/features/meditation/domain/models/meditation.dart';
import 'package:meditation_app/shared/services/analytics_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PlaybackState {
  playing,
  paused,
  stopped,
  loading,
}

class MeditationPlayerService extends StateNotifier<PlaybackState> {
  final AudioPlayer _player;
  final AnalyticsService _analytics = AnalyticsService();
  
  Meditation? _currentMeditation;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _volume = 1.0;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  bool _isInitialized = false;

  MeditationPlayerService() : _player = AudioPlayer(), super(PlaybackState.stopped) {
    _initializeListeners();
  }

  void _initializeListeners() {
    _player.onPlayerStateChanged.listen((event) {
      switch (event) {
        case PlayerState.playing:
          state = PlaybackState.playing;
          break;
        case PlayerState.paused:
          state = PlaybackState.paused;
          break;
        case PlayerState.stopped:
        case PlayerState.completed:
          state = PlaybackState.stopped;
          break;
        case PlayerState.disposed:
          state = PlaybackState.stopped;
          break;
      }
    });

    _player.onPositionChanged.listen((position) {
      _position = position;
    });

    _player.onDurationChanged.listen((duration) {
      _duration = duration;
    });
  }

  // Getters
  Meditation? get currentMeditation => _currentMeditation;
  PlaybackState get playbackState => state;
  Duration get position => _position;
  Duration get duration => _duration;
  double get progress => _duration.inMilliseconds > 0 
      ? _position.inMilliseconds / _duration.inMilliseconds 
      : 0.0;
  double get volume => _volume;

  Future<void> initialize() async {
    if (!_isInitialized) {
      try {
        // Listen to position changes
        _positionSubscription = _player.onPositionChanged.listen((Duration p) {
          _position = p;
          state = state; // Trigger state update
        });

        // Listen to duration changes
        _durationSubscription = _player.onDurationChanged.listen((Duration d) {
          _duration = d;
          state = state; // Trigger state update
        });

        // Listen to state changes
        _playerStateSubscription = _player.onPlayerStateChanged.listen((PlayerState playerState) {
          if (playerState == PlayerState.completed) {
            state = PlaybackState.stopped;
            _position = Duration.zero;
            if (_currentMeditation != null) {
              _analytics.logEvent('meditation_completed', parameters: {
                'meditation_id': _currentMeditation!.id,
                'meditation_title': _currentMeditation!.title,
                'duration_seconds': _currentMeditation!.duration.inSeconds,
              });
            }
          }
        });

        _isInitialized = true;
      } catch (e) {
        debugPrint('Error initializing MeditationPlayerService: $e');
        // Mark as initialized to prevent repeated attempts
        _isInitialized = true;
      }
    }
  }

  // Play a meditation
  Future<void> play(Meditation meditation) async {
    state = PlaybackState.loading;
    try {
      // If already playing the same meditation, resume instead
      if (_currentMeditation?.id == meditation.id && state == PlaybackState.paused) {
        return resume();
      }

      // Stop any currently playing meditation
      if (state != PlaybackState.stopped) {
        await stop();
      }

      _currentMeditation = meditation;
      
      // Use local file if downloaded, otherwise use the URL
      if (meditation.isDownloaded && meditation.localAudioPath != null) {
        await _player.play(DeviceFileSource(meditation.localAudioPath!));
      } else {
        await _player.play(UrlSource(meditation.audioUrl));
      }

      state = PlaybackState.playing;
      
      _analytics.logEvent('meditation_started', parameters: {
        'meditation_id': meditation.id,
        'meditation_title': meditation.title,
        'is_downloaded': meditation.isDownloaded,
      });
    } catch (e) {
      debugPrint('Error playing meditation: $e');
      state = PlaybackState.stopped;
    }
  }

  // Pause the current meditation
  Future<void> pause() async {
    await _player.pause();
    state = PlaybackState.paused;
  }

  // Resume the current meditation
  Future<void> resume() async {
    await _player.resume();
    state = PlaybackState.playing;
  }

  // Stop the current meditation
  Future<void> stop() async {
    await _player.stop();
    state = PlaybackState.stopped;
    _position = Duration.zero;
    
    if (_currentMeditation != null) {
      _analytics.logEvent('meditation_stopped', parameters: {
        'meditation_id': _currentMeditation!.id,
        'position_seconds': _position.inSeconds,
      });
    }
  }

  // Seek to a specific position
  Future<void> seek(Duration position) async {
    await _player.seek(position);
    _position = position;
    state = state; // Trigger state update
  }

  // Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    if (volume < 0.0 || volume > 1.0) return;
    await _player.setVolume(volume);
    _volume = volume;
    state = state; // Trigger state update
  }

  @override
  void dispose() {
    try {
      _positionSubscription?.cancel();
      _durationSubscription?.cancel();
      _playerStateSubscription?.cancel();
      _player.dispose();
    } catch (e) {
      debugPrint('Error disposing MeditationPlayerService: $e');
    }
    super.dispose();
  }
}

final meditationPlayerServiceProvider =
    StateNotifierProvider<MeditationPlayerService, PlaybackState>((ref) {
  return MeditationPlayerService();
});
