import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:meditation_app/features/profile/domain/models/user_profile.dart';
import 'package:meditation_app/features/profile/domain/providers/profile_provider.dart';
import 'package:meditation_app/shared/services/notification_service.dart';

// Re-export the profile provider
final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile?>((ref) {
  final box = Hive.box<UserProfile>('user_profile');
  return ProfileNotifier(box);
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
}); 