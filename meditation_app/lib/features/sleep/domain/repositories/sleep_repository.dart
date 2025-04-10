import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:meditation_app/features/sleep/domain/models/sleep_story.dart';

class SleepRepository {
  static const _boxName = 'sleep_stories';
  Box<SleepStory>? _box;
  
  SleepRepository();
  
  Future<void> initialize() async {
    try {
      if (!Hive.isAdapterRegistered(6)) {
        Hive.registerAdapter(SleepStoryAdapter());
      }
      
      if (!Hive.isBoxOpen(_boxName)) {
        _box = await Hive.openBox<SleepStory>(_boxName);
      } else {
        _box = Hive.box<SleepStory>(_boxName);
      }
      
      // If empty, add some default sleep stories
      if (_box!.isEmpty) {
        await addDefaultSleepStories();
      }
    } catch (e) {
      debugPrint('Error initializing sleep repository: $e');
      // Try to recover by deleting and recreating the box
      try {
        await Hive.deleteBoxFromDisk(_boxName);
        _box = await Hive.openBox<SleepStory>(_boxName);
        await addDefaultSleepStories();
      } catch (e) {
        debugPrint('Fatal error initializing sleep repository: $e');
        rethrow;
      }
    }
  }
  
  Future<void> addDefaultSleepStories() async {
    final stories = [
      SleepStory(
        id: const Uuid().v4(),
        title: 'Night Island',
        type: 'SLEEP MUSIC',
        duration: const Duration(minutes: 45),
        description: 'Non-stop 8-hour mixes of our most popular sleep audio.',
        narrator: 'Thomas Shelby',
        tags: ['popular', 'music', 'night'],
      ),
      SleepStory(
        id: const Uuid().v4(),
        title: 'Sweet Sleep',
        type: 'SLEEP MUSIC',
        duration: const Duration(minutes: 45),
        description: 'Non-stop 8-hour mixes of our most popular sleep audio.',
        narrator: 'Thomas Shelby',
        tags: ['popular', 'music', 'relaxing'],
      ),
      SleepStory(
        id: const Uuid().v4(),
        title: 'Good Night',
        type: 'SLEEP MUSIC',
        duration: const Duration(minutes: 45),
        description: 'Non-stop 8-hour mixes of our most popular sleep audio.',
        narrator: 'Thomas Shelby',
        tags: ['popular', 'music', 'night'],
      ),
      SleepStory(
        id: const Uuid().v4(),
        title: 'Moon Clouds',
        type: 'SLEEP MUSIC',
        duration: const Duration(minutes: 45),
        description: 'Non-stop 8-hour mixes of our most popular sleep audio.',
        narrator: 'Thomas Shelby',
        tags: ['popular', 'music', 'night'],
      ),
      SleepStory(
        id: const Uuid().v4(),
        title: 'Dreamland',
        type: 'SLEEP STORY',
        duration: const Duration(minutes: 30),
        description: 'A soothing bedtime story to help you fall into a deep and natural sleep.',
        narrator: 'Jane Austen',
        tags: ['premium', 'story', 'dreamy'],
        isPremium: true,
      ),
      SleepStory(
        id: const Uuid().v4(),
        title: 'Ocean Waves',
        type: 'AMBIENT SOUND',
        duration: const Duration(hours: 2),
        description: 'Calming ocean sounds to help you fall asleep naturally.',
        tags: ['sound', 'nature', 'popular'],
      ),
    ];
    
    for (final story in stories) {
      await _box!.put(story.id, story);
    }
  }
  
  List<SleepStory> getAllSleepStories() {
    if (_box == null) {
      return [];
    }
    return _box!.values.toList();
  }
  
  List<SleepStory> getSleepStoriesByType(String type) {
    if (_box == null) {
      return [];
    }
    return _box!.values.where((story) => story.type == type).toList();
  }
  
  List<SleepStory> getSleepStoriesByTag(String tag) {
    if (_box == null) {
      return [];
    }
    return _box!.values.where((story) => story.tags.contains(tag)).toList();
  }
  
  Future<SleepStory?> getSleepStoryById(String id) async {
    if (_box == null) {
      return null;
    }
    return _box!.get(id);
  }
  
  Future<void> addSleepStory(SleepStory story) async {
    if (_box == null) {
      await initialize();
    }
    await _box!.put(story.id, story);
  }
  
  Future<void> updateSleepStory(SleepStory story) async {
    if (_box == null) {
      await initialize();
    }
    await _box!.put(story.id, story);
  }
  
  Future<void> deleteSleepStory(String id) async {
    if (_box == null) {
      await initialize();
    }
    await _box!.delete(id);
  }
  
  Future<void> markAsDownloaded(String id, String localPath) async {
    if (_box == null) {
      await initialize();
    }
    
    final story = await getSleepStoryById(id);
    if (story != null) {
      final updatedStory = story.copyWith(
        isDownloaded: true,
        localAudioPath: localPath,
      );
      await updateSleepStory(updatedStory);
    }
  }
  
  List<SleepStory> getDownloadedStories() {
    if (_box == null) {
      return [];
    }
    return _box!.values.where((story) => story.isDownloaded).toList();
  }
  
  Future<void> close() async {
    if (_box != null && _box!.isOpen) {
      await _box!.close();
    }
  }
} 