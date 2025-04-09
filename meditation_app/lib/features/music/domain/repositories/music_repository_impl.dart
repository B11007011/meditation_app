import 'package:meditation_app/features/music/domain/models/music_track.dart';
import 'package:meditation_app/features/music/domain/repositories/music_repository.dart';

class MusicRepositoryImpl implements MusicRepository {
  // Mock data for meditation tracks
  final List<MusicTrack> _tracks = [
    MusicTrack(
      id: '1',
      title: 'Calm Rain',
      artist: 'Nature Sounds',
      audioUrl: 'assets/audio/calm_rain.mp3',
      imageUrl: 'assets/images/music/rain.jpg',
      duration: const Duration(minutes: 5, seconds: 30),
    ),
    MusicTrack(
      id: '2',
      title: 'Ocean Waves',
      artist: 'Nature Sounds',
      audioUrl: 'assets/audio/ocean_waves.mp3',
      imageUrl: 'assets/images/music/ocean.jpg',
      duration: const Duration(minutes: 4, seconds: 45),
    ),
    MusicTrack(
      id: '3',
      title: 'Gentle Piano',
      artist: 'Music Therapy',
      audioUrl: 'assets/audio/gentle_piano.mp3',
      imageUrl: 'assets/images/music/piano.jpg',
      duration: const Duration(minutes: 7, seconds: 15),
    ),
    MusicTrack(
      id: '4',
      title: 'Tibetan Bowls',
      artist: 'Meditation Masters',
      audioUrl: 'assets/audio/tibetan_bowls.mp3',
      imageUrl: 'assets/images/music/tibetan_bowls.jpg',
      duration: const Duration(minutes: 6, seconds: 20),
    ),
  ];

  final Map<String, List<String>> _categories = {
    'meditation': ['1', '2', '3', '4'],
    'sleep': ['1', '2'],
    'focus': ['3', '4'],
  };

  final Set<String> _favorites = {};
  final Set<String> _downloaded = {};

  @override
  Future<List<MusicTrack>> getAllTracks() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _tracks;
  }

  @override
  Future<List<MusicTrack>> getTracksByCategory(String category) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final trackIds = _categories[category] ?? [];
    return _tracks.where((track) => trackIds.contains(track.id)).toList();
  }

  @override
  Future<List<MusicTrack>> getFavoriteTracks() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return _tracks.where((track) => _favorites.contains(track.id)).toList();
  }

  @override
  Future<void> addToFavorites(String trackId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    _favorites.add(trackId);
  }

  @override
  Future<void> removeFromFavorites(String trackId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    _favorites.remove(trackId);
  }

  @override
  Future<void> downloadTrack(String trackId) async {
    // Simulate downloading
    await Future.delayed(const Duration(seconds: 2));
    
    _downloaded.add(trackId);
  }

  @override
  Future<void> removeDownloadedTrack(String trackId) async {
    // Simulate deletion
    await Future.delayed(const Duration(milliseconds: 500));
    
    _downloaded.remove(trackId);
  }

  @override
  Future<bool> isTrackDownloaded(String trackId) async {
    return _downloaded.contains(trackId);
  }

  @override
  Future<MusicTrack?> getTrackById(String trackId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _tracks.firstWhere(
      (track) => track.id == trackId,
      orElse: () => throw Exception('Track not found'),
    );
  }
} 