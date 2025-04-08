import 'package:flutter/foundation.dart';
import 'package:meditation_app/features/profile/domain/models/user_profile.dart';

class ProfileProvider with ChangeNotifier {
  UserProfile? _userProfile;

  // Mock data for demo purposes
  UserProfile get userProfile => _userProfile ?? _createDemoProfile();

  // Create mock profile for demo
  UserProfile _createDemoProfile() {
    return UserProfile(
      id: 'demo-user',
      name: 'Afsar Hossen',
      email: 'afsar@example.com',
      totalSessions: 12,
      totalMeditationTime: Duration(minutes: 120),
    );
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
