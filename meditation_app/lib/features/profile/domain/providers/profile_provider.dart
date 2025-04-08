import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:meditation_app/features/profile/domain/models/user_profile.dart';

class ProfileNotifier extends StateNotifier<UserProfile?> {
  final Box<UserProfile> _box;

  ProfileNotifier(this._box) : super(_box.values.isEmpty ? null : _box.values.first);

  Future<void> updateProfile({
    required String id,
    required String name,
    String? email,
    String? avatarUrl,
    DateTime? lastMeditationDate,
    int totalSessions = 0,
    Duration totalMeditationTime = Duration.zero,
  }) async {
    final profile = UserProfile(
      id: id,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      lastMeditationDate: lastMeditationDate,
      totalSessions: totalSessions,
      totalMeditationTime: totalMeditationTime,
    );
    await _box.put('current_user', profile);
    state = profile;
  }

  Future<void> clearProfile() async {
    await _box.clear();
    state = null;
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
      );
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile?>((ref) {
  final box = Hive.box<UserProfile>('user_profile');
  return ProfileNotifier(box);
});
