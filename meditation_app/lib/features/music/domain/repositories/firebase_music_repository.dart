import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation_app/features/music/domain/models/music_track.dart';
import 'package:meditation_app/features/music/domain/repositories/music_repository.dart';

class FirebaseMusicRepository implements MusicRepository {
  final FirebaseStorage _storage;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseMusicRepository({
    FirebaseStorage? storage,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _storage = storage ?? FirebaseStorage.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<List<MusicTrack>> getAllTracks() async {
    try {
      final snapshot = await _firestore.collection('tracks').get();
      return snapshot.docs.map((doc) => _convertToMusicTrack(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tracks: $e');
    }
  }

  @override
  Future<List<MusicTrack>> getTracksByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('tracks')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) => _convertToMusicTrack(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tracks by category: $e');
    }
  }

  @override
  Future<List<MusicTrack>> getFavoriteTracks() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get();

      final trackIds = snapshot.docs.map((doc) => doc.id).toList();
      
      // Fetch all tracks in parallel
      final trackFutures = trackIds.map((id) => getTrackById(id));
      final tracks = await Future.wait(trackFutures);
      
      // Filter out any null values and cast to List<MusicTrack>
      return tracks.whereType<MusicTrack>().toList();
    } catch (e) {
      throw Exception('Failed to fetch favorite tracks: $e');
    }
  }

  @override
  Future<void> addToFavorites(String trackId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(trackId)
          .set({'addedAt': FieldValue.serverTimestamp()});
    } catch (e) {
      throw Exception('Failed to add track to favorites: $e');
    }
  }

  @override
  Future<void> removeFromFavorites(String trackId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(trackId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove track from favorites: $e');
    }
  }

  @override
  Future<void> downloadTrack(String trackId) async {
    // Implement local storage download logic
    throw UnimplementedError();
  }

  @override
  Future<void> removeDownloadedTrack(String trackId) async {
    // Implement local storage removal logic
    throw UnimplementedError();
  }

  @override
  Future<bool> isTrackDownloaded(String trackId) async {
    // Implement local storage check logic
    return false;
  }

  @override
  Future<MusicTrack?> getTrackById(String trackId) async {
    try {
      final doc = await _firestore.collection('tracks').doc(trackId).get();
      if (!doc.exists) return null;
      return _convertToMusicTrack(doc);
    } catch (e) {
      throw Exception('Failed to fetch track: $e');
    }
  }

  MusicTrack _convertToMusicTrack(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MusicTrack(
      id: doc.id,
      title: data['title'] as String,
      artist: data['artist'] as String,
      audioUrl: data['audioUrl'] as String,
      imageUrl: data['imageUrl'] as String?,
      duration: Duration(seconds: data['durationSeconds'] as int),
      isDownloaded: false,
    );
  }
} 