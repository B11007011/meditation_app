import 'package:flutter/foundation.dart';
import 'package:meditation_app/features/profile/domain/models/user_profile.dart';

class ProfileProvider with ChangeNotifier {
  UserProfile? _userProfile;

  // Mock data for demo purposes
  UserProfile get userProfile => _userProfile ?? _createDemoProfile();

  // Create mock profile for demo
  UserProfile _createDemoProfile() {
    return UserProfile(
      name: 'Afsar Hossen',
      email: 'afsar@example.com',
      meditationMinutes: 120,
      sessionsCompleted: 12,
      longestStreak: 7,
      currentStreak: 3,
      isPremium: false,
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

  // Toggle premium status
  void togglePremium() {
    _userProfile = userProfile.copyWith(isPremium: !userProfile.isPremium);
    notifyListeners();
  }

  // Log meditation session
  void logMeditationSession(int minutes) {
    _userProfile = userProfile.copyWith(
      meditationMinutes: userProfile.meditationMinutes + minutes,
      sessionsCompleted: userProfile.sessionsCompleted + 1,
    );
    notifyListeners();
  }

  // Update streak
  void updateStreak(int newStreak) {
    final longestStreak = newStreak > userProfile.longestStreak 
        ? newStreak 
        : userProfile.longestStreak;
    
    _userProfile = userProfile.copyWith(
      currentStreak: newStreak,
      longestStreak: longestStreak,
    );
    notifyListeners();
  }
} 