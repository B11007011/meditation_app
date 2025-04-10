import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:meditation_app/features/sleep/domain/models/sleep_data.dart';
import 'package:meditation_app/features/sleep/domain/models/sleep_story.dart';
import 'package:meditation_app/features/sleep/domain/repositories/sleep_repository.dart';

// Provider for sleep data history
class SleepNotifier extends StateNotifier<List<SleepData>> {
  final Box<SleepData> _box;

  SleepNotifier(this._box) : super(_box.values.toList());

  Future<void> addSleepData(SleepData data) async {
    await _box.put(data.id, data);
    state = _box.values.toList();
  }

  Future<void> updateSleepData(SleepData data) async {
    await _box.put(data.id, data);
    state = _box.values.toList();
  }

  Future<void> deleteSleepData(String id) async {
    await _box.delete(id);
    state = _box.values.toList();
  }
}

final sleepProvider = StateNotifierProvider<SleepNotifier, List<SleepData>>((ref) {
  final box = Hive.box<SleepData>('sleep_data');
  return SleepNotifier(box);
});

// Provider for the sleep repository
final sleepRepositoryProvider = Provider<SleepRepository>((ref) {
  return SleepRepository();
});

// Provider for all sleep stories
final allSleepStoriesProvider = FutureProvider<List<SleepStory>>((ref) async {
  final repository = ref.watch(sleepRepositoryProvider);
  await repository.initialize();
  return repository.getAllSleepStories();
});

// Provider for sleep stories by type
final sleepStoriesByTypeProvider = FutureProvider.family<List<SleepStory>, String>((ref, type) async {
  final repository = ref.watch(sleepRepositoryProvider);
  await repository.initialize();
  return repository.getSleepStoriesByType(type);
});

// Provider for sleep stories by tag
final sleepStoriesByTagProvider = FutureProvider.family<List<SleepStory>, String>((ref, tag) async {
  final repository = ref.watch(sleepRepositoryProvider);
  await repository.initialize();
  return repository.getSleepStoriesByTag(tag);
});

// Provider for a single sleep story by ID
final sleepStoryByIdProvider = FutureProvider.family<SleepStory?, String>((ref, id) async {
  final repository = ref.watch(sleepRepositoryProvider);
  await repository.initialize();
  return repository.getSleepStoryById(id);
});

// Provider for downloaded sleep stories
final downloadedSleepStoriesProvider = FutureProvider<List<SleepStory>>((ref) async {
  final repository = ref.watch(sleepRepositoryProvider);
  await repository.initialize();
  return repository.getDownloadedStories();
});
