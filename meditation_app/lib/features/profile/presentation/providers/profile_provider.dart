import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation_app/features/profile/domain/models/user_profile.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfileProvider with ChangeNotifier {
  UserProfile? _userProfile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authSubscription;
  bool _isInitialized = false;
  bool _mounted = true;
  late Box<UserProfile> _profileBox;

  ProfileProvider() {
    _initBox();
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

  Future<void> _initBox() async {
    _profileBox = Hive.box<UserProfile>('userProfiles');
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
        // Try to load from Hive first
        final savedProfile = _profileBox.get(user.uid);
        
        if (savedProfile != null) {
          _userProfile = savedProfile;
        } else {
          // Create new profile if not found in Hive
          _userProfile = UserProfile(
            id: user.uid,
            name: user.displayName ?? 'User',
            email: user.email,
            avatarUrl: user.photoURL,
            totalSessions: 0,
            totalMeditationTime: Duration.zero,
          );
          
          // Save to Hive
          await _profileBox.put(user.uid, _userProfile!);
        }
        
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
  Future<void> updateProfile(UserProfile updatedProfile) async {
    _userProfile = updatedProfile;
    await _saveProfile();
    notifyListeners();
  }

  // Update user name
  Future<void> updateName(String name) async {
    _userProfile = userProfile.copyWith(name: name);
    await _saveProfile();
    notifyListeners();
  }

  // Update email
  Future<void> updateEmail(String email) async {
    _userProfile = userProfile.copyWith(email: email);
    await _saveProfile();
    notifyListeners();
  }

  // Log meditation session
  Future<void> logMeditationSession(Duration duration) async {
    _userProfile = userProfile.copyWith(
      totalSessions: userProfile.totalSessions + 1,
      totalMeditationTime: userProfile.totalMeditationTime + duration,
      lastMeditationDate: DateTime.now(),
    );
    await _saveProfile();
    notifyListeners();
  }

  // Save profile to Hive
  Future<void> _saveProfile() async {
    if (_userProfile != null && _userProfile!.id != 'unknown') {
      await _profileBox.put(_userProfile!.id, _userProfile!);
    }
  }

  @override
  void dispose() {
    _mounted = false;
    _authSubscription?.cancel();
    super.dispose();
  }
}
