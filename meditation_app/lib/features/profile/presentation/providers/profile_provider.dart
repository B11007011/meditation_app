import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation_app/features/profile/domain/models/user_profile.dart';

class ProfileProvider with ChangeNotifier {
  UserProfile? _userProfile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authSubscription;
  bool _isInitialized = false;
  bool _mounted = true;

  ProfileProvider() {
    _initUser();
    _authSubscription = _auth.authStateChanges().listen((user) {
      if (!_mounted) return;
      if (user != null) {
        _initUser();
      } else {
        _userProfile = null;
        if (_mounted) notifyListeners();
      }
    });
  }

  UserProfile get userProfile {
    if (!_isInitialized && _auth.currentUser != null) {
      _initUser();
    }
    return _userProfile ?? UserProfile(
      id: 'unknown',
      name: 'Guest',
      totalSessions: 0,
      totalMeditationTime: Duration.zero,
    );
  }

  Future<void> _initUser() async {
    try {
      if (!_mounted) return;

      final user = _auth.currentUser;
      if (user != null) {
        _userProfile = UserProfile(
          id: user.uid,
          name: user.displayName ?? 'User',
          email: user.email,
          avatarUrl: user.photoURL,
          totalSessions: 0,
          totalMeditationTime: Duration.zero,
        );
        _isInitialized = true;
        if (_mounted) {
          notifyListeners();
        }
      }
    } catch (e) {
      if (_mounted) {
        debugPrint('Error initializing user: $e');
      }
    }
  }

  // Update user profile
  void updateProfile(UserProfile updatedProfile) {
    _userProfile = updatedProfile;
    notifyListeners();
  }

  // Update user name
  void updateName(String name) {
    _userProfile = userProfile.copyWith(name: name);
    notifyListeners();
  }

  // Update email
  void updateEmail(String email) {
    _userProfile = userProfile.copyWith(email: email);
    notifyListeners();
  }

  // Log meditation session
  void logMeditationSession(Duration duration) {
    _userProfile = userProfile.copyWith(
      totalSessions: userProfile.totalSessions + 1,
      totalMeditationTime: userProfile.totalMeditationTime + duration,
      lastMeditationDate: DateTime.now(),
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _mounted = false;
    _authSubscription?.cancel();
    super.dispose();
  }
}
