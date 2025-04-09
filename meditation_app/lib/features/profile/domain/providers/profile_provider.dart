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
        try {
          final firebaseUser = FirebaseAuth.instance.currentUser;
          if (firebaseUser != null) {
            await updateProfile(
              id: firebaseUser.uid,
              name: firebaseUser.displayName,
              email: firebaseUser.email,
              avatarUrl: firebaseUser.photoURL,
            );
            return; // Successfully created profile from Firebase
          }
        } catch (e) {
          print('Error accessing Firebase user: $e');
          // Continue to create a default user
        }
        
        // Create a default profile for demo purposes if no Firebase user or error occurred
        await updateProfile(
          id: 'demo_user',
          name: 'Demo User',
          email: 'demo@example.com',
        );
      }
    } catch (e) {
      print('Error initializing profile: $e');
      
      // Create a minimal fallback profile if all else fails
      try {
        final fallbackProfile = UserProfile(
          id: 'fallback_user',
          name: 'Guest User',
          email: null,
          avatarUrl: null,
          lastMeditationDate: null,
          totalSessions: 0,
          totalMeditationTime: const Duration(),
          dayStreak: 0,
          isPremium: false,
        );
        
        state = fallbackProfile;
      } catch (innerError) {
        print('Failed to create fallback profile: $innerError');
      }
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
