import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:meditation_app/features/meditation/domain/models/meditation.dart';
import 'package:meditation_app/shared/services/analytics_service.dart';

enum PlaybackState { stopped, playing, paused }

class MeditationPlayerService extends ChangeNotifier {
  static final MeditationPlayerService _instance = MeditationPlayerService._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AnalyticsService _analytics = AnalyticsService();
  
  Meditation? _currentMeditation;
  PlaybackState _playbackState = PlaybackState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  bool _isInitialized = false;

  factory MeditationPlayerService() {
    return _instance;
  }

  MeditationPlayerService._internal();

  // Getters
  Meditation? get currentMeditation => _currentMeditation;
  PlaybackState get playbackState => _playbackState;
  Duration get position => _position;
  Duration get duration => _duration;
  double get progress => _duration.inMilliseconds > 0 
      ? _position.inMilliseconds / _duration.inMilliseconds 
      : 0.0;

  Future<void> initialize() async {
    if (!_isInitialized) {
      try {
        // Listen to position changes
        _positionSubscription = _audioPlayer.onPositionChanged.listen((Duration p) {
          _position = p;
          notifyListeners();
        });

        // Listen to duration changes
        _durationSubscription = _audioPlayer.onDurationChanged.listen((Duration d) {
          _duration = d;
          notifyListeners();
        });

        // Listen to state changes
        _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
          if (state == PlayerState.completed) {
            _playbackState = PlaybackState.stopped;
            _position = Duration.zero;
            if (_currentMeditation != null) {
              _analytics.logEvent('meditation_completed', parameters: {
                'meditation_id': _currentMeditation!.id,
                'meditation_title': _currentMeditation!.title,
                'duration_seconds': _currentMeditation!.duration.inSeconds,
              });
            }
          }
          notifyListeners();
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
    try {
      // If already playing the same meditation, resume instead
      if (_currentMeditation?.id == meditation.id && _playbackState == PlaybackState.paused) {
        return resume();
      }

      // Stop any currently playing meditation
      if (_playbackState != PlaybackState.stopped) {
        await stop();
      }

      _currentMeditation = meditation;
      
      // Use local file if downloaded, otherwise use the URL
      if (meditation.isDownloaded && meditation.localAudioPath != null) {
        await _audioPlayer.play(DeviceFileSource(meditation.localAudioPath!));
      } else {
        await _audioPlayer.play(UrlSource(meditation.audioUrl));
      }

      _playbackState = PlaybackState.playing;
      
      _analytics.logEvent('meditation_started', parameters: {
        'meditation_id': meditation.id,
        'meditation_title': meditation.title,
        'is_downloaded': meditation.isDownloaded,
      });
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error playing meditation: $e');
    }
  }

  // Pause the current meditation
  Future<void> pause() async {
    try {
      if (_playbackState == PlaybackState.playing) {
        await _audioPlayer.pause();
        _playbackState = PlaybackState.paused;
        
        if (_currentMeditation != null) {
          _analytics.logEvent('meditation_paused', parameters: {
            'meditation_id': _currentMeditation!.id,
            'position_seconds': _position.inSeconds,
          });
        }
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error pausing meditation: $e');
    }
  }

  // Resume the current meditation
  Future<void> resume() async {
    try {
      if (_playbackState == PlaybackState.paused) {
        await _audioPlayer.resume();
        _playbackState = PlaybackState.playing;
        
        if (_currentMeditation != null) {
          _analytics.logEvent('meditation_resumed', parameters: {
            'meditation_id': _currentMeditation!.id,
            'position_seconds': _position.inSeconds,
          });
        }
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error resuming meditation: $e');
    }
  }

  // Stop the current meditation
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _playbackState = PlaybackState.stopped;
      _position = Duration.zero;
      
      if (_currentMeditation != null) {
        _analytics.logEvent('meditation_stopped', parameters: {
          'meditation_id': _currentMeditation!.id,
          'position_seconds': _position.inSeconds,
        });
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping meditation: $e');
    }
  }

  // Seek to a specific position
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      _position = position;
      notifyListeners();
    } catch (e) {
      debugPrint('Error seeking meditation: $e');
    }
  }

  // Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume);
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting volume: $e');
    }
  }

  @override
  void dispose() {
    try {
      _positionSubscription?.cancel();
      _durationSubscription?.cancel();
      _playerStateSubscription?.cancel();
      _audioPlayer.dispose();
    } catch (e) {
      debugPrint('Error disposing MeditationPlayerService: $e');
    }
    super.dispose();
  }
}
