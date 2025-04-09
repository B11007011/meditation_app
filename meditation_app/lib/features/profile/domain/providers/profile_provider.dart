import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:meditation_app/features/profile/domain/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileNotifier extends StateNotifier<UserProfile?> {
  final Box<UserProfile> _box;

  ProfileNotifier(this._box) : super(null) {
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    try {
      // Try to get current profile from Hive
      final profile = _box.get('current_user');
      
      if (profile != null) {
        state = profile;
      } else {
        // If no profile exists, create one from Firebase user
        final firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser != null) {
          await updateProfile(
            id: firebaseUser.uid,
            name: firebaseUser.displayName,
            email: firebaseUser.email,
            avatarUrl: firebaseUser.photoURL,
          );
        }
      }
    } catch (e) {
      print('Error initializing profile: $e');
      // Don't update state if there's an error
    }
  }

  Future<void> updateProfile({
    required String id,
    String? name,
    String? email,
    String? avatarUrl,
    DateTime? lastMeditationDate,
    int totalSessions = 0,
    Duration totalMeditationTime = const Duration(),
    int dayStreak = 0,
    bool isPremium = false,
  }) async {
    try {
      final profile = UserProfile(
        id: id,
        name: name ?? 'Anonymous',
        email: email,
        avatarUrl: avatarUrl,
        lastMeditationDate: lastMeditationDate,
        totalSessions: totalSessions,
        totalMeditationTime: totalMeditationTime,
        dayStreak: dayStreak,
        isPremium: isPremium,
      );
      
      await _box.put('current_user', profile);
      state = profile;
    } catch (e) {
      print('Error updating profile: $e');
      // Don't update state if there's an error
    }
  }

  Future<void> clearProfile() async {
    try {
      await _box.clear();
      state = null;
    } catch (e) {
      print('Error clearing profile: $e');
    }
  }

  Future<void> updateMeditationStats({
    required Duration duration,
  }) async {
    final current = state;
    if (current != null) {
      await updateProfile(
        id: current.id,
        name: current.name,
        email: current.email,
        avatarUrl: current.avatarUrl,
        lastMeditationDate: DateTime.now(),
        totalSessions: current.totalSessions + 1,
        totalMeditationTime: current.totalMeditationTime + duration,
        dayStreak: current.dayStreak,
        isPremium: current.isPremium,
      );
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile?>((ref) {
  final box = Hive.box<UserProfile>('user_profile');
  return ProfileNotifier(box);
});
