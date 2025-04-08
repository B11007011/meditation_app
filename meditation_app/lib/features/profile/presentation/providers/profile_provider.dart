import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation_app/features/profile/domain/models/user_profile.dart';

class ProfileProvider with ChangeNotifier {
  UserProfile? _userProfile;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ProfileProvider() {
    _initUser();
    _auth.authStateChanges().listen((user) => _initUser());
  }

  UserProfile get userProfile {
    if (_userProfile == null && _auth.currentUser != null) {
      _initUser();
    }
    return _userProfile ?? UserProfile(
      id: 'unknown',
      name: 'Guest',
      totalSessions: 0,
      totalMeditationTime: Duration.zero,
    );
  }

  void _initUser() {
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
      notifyListeners();
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
}
