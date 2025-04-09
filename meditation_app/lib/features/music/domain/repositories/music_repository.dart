import 'package:meditation_app/features/music/domain/models/music_track.dart';

abstract class MusicRepository {
  /// Fetch all available music tracks
  Future<List<MusicTrack>> getAllTracks();
  
  /// Fetch tracks by category
  Future<List<MusicTrack>> getTracksByCategory(String category);
  
  /// Get user's favorite tracks
  Future<List<MusicTrack>> getFavoriteTracks();
  
  /// Add track to favorites
  Future<void> addToFavorites(String trackId);
  
  /// Remove track from favorites
  Future<void> removeFromFavorites(String trackId);
  
  /// Download track for offline playback
  Future<void> downloadTrack(String trackId);
  
  /// Remove downloaded track
  Future<void> removeDownloadedTrack(String trackId);
  
  /// Check if track is downloaded
  Future<bool> isTrackDownloaded(String trackId);
  
  /// Get track by ID
  Future<MusicTrack?> getTrackById(String trackId);
} 