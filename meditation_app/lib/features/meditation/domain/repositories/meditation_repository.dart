import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:meditation_app/features/meditation/domain/models/meditation.dart';

class MeditationRepository {
  static final MeditationRepository _instance = MeditationRepository._internal();
  Box<Meditation>? _meditationsBox;
  bool _isInitialized = false;

  factory MeditationRepository() {
    return _instance;
  }

  MeditationRepository._internal();

  Future<void> initialize() async {
    if (!_isInitialized) {
      try {
        // Make sure Hive is registered
        if (!Hive.isAdapterRegistered(0)) { // Use a unique ID for your adapter
          Hive.registerAdapter(MeditationAdapter());
        }
        
        _meditationsBox = await Hive.openBox<Meditation>('meditations');
        _isInitialized = true;
        
        // If the box is empty, populate with sample data
        if (_meditationsBox!.isEmpty) {
          await _populateSampleData();
        }
      } catch (e) {
        debugPrint('Error initializing MeditationRepository: $e');
        // Create a fallback in-memory implementation
        _isInitialized = true; // Mark as initialized to prevent repeated attempts
      }
    }
  }

  // Get all meditations
  List<Meditation> getAllMeditations() {
    // If not initialized or box is null, return sample data
    if (!_isInitialized || _meditationsBox == null) {
      return _getSampleMeditations();
    }
    return _meditationsBox!.values.toList();
  }

  // Get meditations by category
  List<Meditation> getMeditationsByCategory(String category) {
    if (!_isInitialized || _meditationsBox == null) {
      return _getSampleMeditations()
          .where((meditation) => meditation.category == category)
          .toList();
    }
    return _meditationsBox!.values
        .where((meditation) => meditation.category == category)
        .toList();
  }

  // Get meditation by ID
  Meditation? getMeditationById(String id) {
    if (!_isInitialized || _meditationsBox == null) {
      return _getSampleMeditations().firstWhere(
        (meditation) => meditation.id == id,
        orElse: () => throw Exception('Meditation not found'),
      );
    }
    return _meditationsBox!.values.firstWhere(
      (meditation) => meditation.id == id,
      orElse: () => throw Exception('Meditation not found'),
    );
  }

  // Get downloaded meditations
  List<Meditation> getDownloadedMeditations() {
    if (!_isInitialized || _meditationsBox == null) {
      return [];
    }
    return _meditationsBox!.values
        .where((meditation) => meditation.isDownloaded)
        .toList();
  }

  // Download a meditation
  Future<void> downloadMeditation(String id) async {
    try {
      if (!_isInitialized || _meditationsBox == null) {
        debugPrint('Cannot download meditation: repository not initialized');
        return;
      }
      
      final meditation = getMeditationById(id);
      if (meditation == null) return;

      // Create directory for downloaded meditations if it doesn't exist
      final appDir = await getApplicationDocumentsDirectory();
      final meditationsDir = Directory('${appDir.path}/meditations');
      if (!await meditationsDir.exists()) {
        await meditationsDir.create(recursive: true);
      }

      // Download the audio file
      final response = await http.get(Uri.parse(meditation.audioUrl));
      if (response.statusCode == 200) {
        final localPath = '${meditationsDir.path}/${meditation.id}.mp3';
        final file = File(localPath);
        await file.writeAsBytes(response.bodyBytes);

        // Update meditation in the database
        final updatedMeditation = meditation.copyWith(
          isDownloaded: true,
          localAudioPath: localPath,
        );

        await _meditationsBox!.put(meditation.id, updatedMeditation);
      } else {
        throw Exception('Failed to download meditation');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading meditation: $e');
      }
    }
  }

  // Delete a downloaded meditation
  Future<void> deleteDownloadedMeditation(String id) async {
    try {
      if (!_isInitialized || _meditationsBox == null) {
        debugPrint('Cannot delete meditation: repository not initialized');
        return;
      }
      
      final meditation = getMeditationById(id);
      if (meditation == null || !meditation.isDownloaded) return;

      // Delete the local file
      if (meditation.localAudioPath != null) {
        final file = File(meditation.localAudioPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Update meditation in the database
      final updatedMeditation = meditation.copyWith(
        isDownloaded: false,
        localAudioPath: null,
      );

      await _meditationsBox!.put(meditation.id, updatedMeditation);
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting downloaded meditation: $e');
      }
    }
  }

  // Get sample meditations (for fallback)
  List<Meditation> _getSampleMeditations() {
    return [
      Meditation(
        id: 'meditation_1',
        title: 'Morning Calm',
        description: 'Start your day with a peaceful meditation to set a positive tone for the day ahead.',
        category: 'Morning',
        imageUrl: 'assets/images/meditation/morning_calm.jpg',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        duration: const Duration(minutes: 10),
        narrator: 'Sarah Johnson',
      ),
      Meditation(
        id: 'meditation_2',
        title: 'Stress Relief',
        description: 'Release tension and find peace with this guided meditation for stress relief.',
        category: 'Stress',
        imageUrl: 'assets/images/meditation/stress_relief.jpg',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        duration: const Duration(minutes: 15),
        narrator: 'Michael Chen',
      ),
      Meditation(
        id: 'meditation_3',
        title: 'Deep Sleep',
        description: 'Prepare your mind and body for a restful night with this calming sleep meditation.',
        category: 'Sleep',
        imageUrl: 'assets/images/meditation/deep_sleep.jpg',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        duration: const Duration(minutes: 20),
        narrator: 'Emily Wilson',
      ),
      Meditation(
        id: 'meditation_4',
        title: 'Focus & Concentration',
        description: 'Enhance your focus and concentration with this mindfulness meditation.',
        category: 'Focus',
        imageUrl: 'assets/images/meditation/focus.jpg',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
        duration: const Duration(minutes: 12),
        narrator: 'David Thompson',
        isPremium: true,
      ),
      Meditation(
        id: 'meditation_5',
        title: 'Anxiety Relief',
        description: 'Calm your anxious mind with this gentle guided meditation.',
        category: 'Anxious',
        imageUrl: 'assets/images/meditation/anxiety_relief.jpg',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
        duration: const Duration(minutes: 18),
        narrator: 'Jessica Lee',
      ),
      Meditation(
        id: 'meditation_6',
        title: 'Loving Kindness',
        description: 'Cultivate compassion and love with this heart-centered meditation.',
        category: 'Compassion',
        imageUrl: 'assets/images/meditation/loving_kindness.jpg',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
        duration: const Duration(minutes: 15),
        narrator: 'Robert Davis',
        isPremium: true,
      ),
      Meditation(
        id: 'meditation_7',
        title: 'Kids Meditation',
        description: 'A gentle meditation designed specifically for children.',
        category: 'Kids',
        imageUrl: 'assets/images/meditation/kids.jpg',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
        duration: const Duration(minutes: 8),
        narrator: 'Olivia Martinez',
      ),
      Meditation(
        id: 'meditation_8',
        title: 'Gratitude Practice',
        description: 'Develop an attitude of gratitude with this uplifting meditation.',
        category: 'My',
        imageUrl: 'assets/images/meditation/gratitude.jpg',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
        duration: const Duration(minutes: 10),
        narrator: 'James Wilson',
      ),
    ];
  }

  // Populate with sample data
  Future<void> _populateSampleData() async {
    if (_meditationsBox == null) return;
    
    final sampleMeditations = _getSampleMeditations();
    for (final meditation in sampleMeditations) {
      await _meditationsBox!.put(meditation.id, meditation);
    }
  }
}
