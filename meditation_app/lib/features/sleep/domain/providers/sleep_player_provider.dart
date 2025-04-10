import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/features/sleep/domain/services/sleep_player_service.dart';
import 'package:meditation_app/features/sleep/domain/models/sleep_story.dart';

// Provider for the sleep player service
final sleepPlayerServiceProvider = Provider<SleepPlayerService>((ref) {
  return SleepPlayerService();
});

// Provider for the current sleep playback state
final sleepPlaybackStateProvider = StateProvider<SleepPlaybackState>((ref) {
  return SleepPlaybackState.stopped;
});

// Provider for the current sleep story being played
final currentSleepStoryProvider = StateProvider<SleepStory?>((ref) {
  return null;
});

// Provider for the current position in the sleep story
final sleepPositionProvider = StateProvider<Duration>((ref) {
  return Duration.zero;
});

// Provider for the total duration of the sleep story
final sleepDurationProvider = StateProvider<Duration>((ref) {
  return Duration.zero;
});

// Provider for the sleep timer duration in minutes (null if no timer)
final sleepTimerProvider = StateProvider<int?>((ref) {
  return null;
});

// Provider for the sleep volume (0.0 to 1.0)
final sleepVolumeProvider = StateProvider<double>((ref) {
  return 0.5;
}); 