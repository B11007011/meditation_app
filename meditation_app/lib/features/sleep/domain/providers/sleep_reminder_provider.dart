import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/features/sleep/domain/services/sleep_reminder_service.dart';
import 'package:meditation_app/shared/providers/shared_providers.dart';

// Provider for the sleep reminder service
final sleepReminderServiceProvider = Provider<SleepReminderService>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  return SleepReminderService(notificationService);
});

// Provider to check if sleep reminders are enabled
final sleepRemindersEnabledProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(sleepReminderServiceProvider);
  return service.isEnabled();
});

// Provider for current sleep reminder settings
final sleepReminderSettingsProvider = FutureProvider<SleepReminderSettings?>((ref) async {
  final service = ref.watch(sleepReminderServiceProvider);
  return service.getSleepReminderSettings();
}); 