import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/features/music/domain/models/music_track.dart';
import 'package:meditation_app/features/music/domain/repositories/music_repository.dart';
import 'package:meditation_app/features/music/domain/repositories/music_repository_impl.dart';

enum PlayerState {
  stopped,
  playing,
  paused,
  loading,
}

class MusicPlayerState {
  final PlayerState playerState;
  final MusicTrack? currentTrack;
  final List<MusicTrack> playlist;
  final Duration position;
  final Duration duration;
  final bool isShuffled;
  final bool isLooping;
  final double volume;

  MusicPlayerState({
    this.playerState = PlayerState.stopped,
    this.currentTrack,
    this.playlist = const [],
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isShuffled = false,
    this.isLooping = false,
    this.volume = 1.0,
  });

  MusicPlayerState copyWith({
    PlayerState? playerState,
    MusicTrack? currentTrack,
    List<MusicTrack>? playlist,
    Duration? position,
    Duration? duration,
    bool? isShuffled,
    bool? isLooping,
    double? volume,
  }) {
    return MusicPlayerState(
      playerState: playerState ?? this.playerState,
      currentTrack: currentTrack ?? this.currentTrack,
      playlist: playlist ?? this.playlist,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isShuffled: isShuffled ?? this.isShuffled,
      isLooping: isLooping ?? this.isLooping,
      volume: volume ?? this.volume,
    );
  }
}

final musicPlayerControllerProvider =
    StateNotifierProvider<MusicPlayerController, MusicPlayerState>((ref) {
  final repository = ref.watch(musicRepositoryProvider);
  return MusicPlayerController(repository);
});

final musicRepositoryProvider = Provider<MusicRepository>((ref) {
  return MusicRepositoryImpl();
});

class MusicPlayerController extends StateNotifier<MusicPlayerState> {
  final MusicRepository _repository;
  final audio.AudioPlayer _audioPlayer;

  MusicPlayerController(this._repository)
      : _audioPlayer = audio.AudioPlayer(),
        super(MusicPlayerState()) {
    _initializeListeners();
  }

  void _initializeListeners() {
    _audioPlayer.onPlayerStateChanged.listen((event) {
      state = state.copyWith(
        playerState: _convertPlayerState(event),
      );
    });

    _audioPlayer.onPositionChanged.listen((position) {
      state = state.copyWith(position: position);
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      state = state.copyWith(duration: duration);
    });
  }

  PlayerState _convertPlayerState(audio.PlayerState event) {
    switch (event) {
      case audio.PlayerState.playing:
        return PlayerState.playing;
      case audio.PlayerState.paused:
        return PlayerState.paused;
      case audio.PlayerState.stopped:
        return PlayerState.stopped;
      case audio.PlayerState.completed:
        return PlayerState.stopped;
      default:
        return PlayerState.stopped;
    }
  }

  Future<void> playTrack(MusicTrack track) async {
    try {
      state = state.copyWith(
        playerState: PlayerState.loading,
        currentTrack: track,
      );

      await _audioPlayer.play(audio.UrlSource(track.audioUrl));
    } catch (e) {
      state = state.copyWith(playerState: PlayerState.stopped);
      rethrow;
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    state = state.copyWith(
      playerState: PlayerState.stopped,
      position: Duration.zero,
    );
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> setPlaylist(List<MusicTrack> tracks) async {
    state = state.copyWith(playlist: tracks);
  }

  void toggleShuffle() {
    state = state.copyWith(isShuffled: !state.isShuffled);
  }

  void toggleLoop() {
    state = state.copyWith(isLooping: !state.isLooping);
  }

  Future<void> playNext() async {
    if (state.playlist.isEmpty || state.currentTrack == null) return;

    final currentIndex = state.playlist.indexOf(state.currentTrack!);
    if (currentIndex < state.playlist.length - 1) {
      await playTrack(state.playlist[currentIndex + 1]);
    } else if (state.isLooping) {
      await playTrack(state.playlist.first);
    }
  }

  Future<void> playPrevious() async {
    if (state.playlist.isEmpty || state.currentTrack == null) return;

    final currentIndex = state.playlist.indexOf(state.currentTrack!);
    if (currentIndex > 0) {
      await playTrack(state.playlist[currentIndex - 1]);
    } else if (state.isLooping) {
      await playTrack(state.playlist.last);
    }
  }

  Future<void> setVolume(double volume) async {
    if (volume < 0.0 || volume > 1.0) return;
    await _audioPlayer.setVolume(volume);
    state = state.copyWith(volume: volume);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
} 