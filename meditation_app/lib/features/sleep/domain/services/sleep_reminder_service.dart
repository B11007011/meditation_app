import 'package:flutter/material.dart';
import 'package:meditation_app/shared/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SleepReminderSettings {
  final int hour;
  final int minute;
  final String amPm;
  final List<String> days;

  SleepReminderSettings({
    required this.hour,
    required this.minute,
    required this.amPm,
    required this.days,
  });

  // Create from a map
  factory SleepReminderSettings.fromMap(Map<String, dynamic> map) {
    return SleepReminderSettings(
      hour: map['hour'] as int,
      minute: map['minute'] as int,
      amPm: map['ampm'] as String,
      days: List<String>.from(map['days'] as List),
    );
  }

  // Convert to a map
  Map<String, dynamic> toMap() {
    return {
      'hour': hour,
      'minute': minute,
      'ampm': amPm,
      'days': days,
    };
  }

  // Get a formatted time string (e.g. "11:30 PM")
  String get formattedTime {
    return '$hour:${minute.toString().padLeft(2, '0')} $amPm';
  }

  // Get a formatted days string (e.g. "SU, M, T, W, S")
  String get formattedDays {
    return days.join(', ');
  }
}

class SleepReminderService {
  static const _prefKeySleepReminderHour = 'sleep_reminder_hour';
  static const _prefKeySleepReminderMinute = 'sleep_reminder_minute';
  static const _prefKeySleepReminderAmPm = 'sleep_reminder_ampm';
  static const _prefKeySleepReminderDays = 'sleep_reminder_days';
  static const _prefKeySleepReminderEnabled = 'sleep_reminder_enabled';
  
  final NotificationService _notificationService;
  
  SleepReminderService(this._notificationService);
  
  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKeySleepReminderEnabled) ?? false;
  }
  
  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKeySleepReminderEnabled, enabled);
    
    if (enabled) {
      // If enabling, schedule reminders from saved settings
      final settings = await getSleepReminderSettings();
      if (settings != null) {
        await scheduleSleepReminders(settings);
      }
    } else {
      // If disabling, cancel all reminders
      await cancelSleepReminders();
    }
  }
  
  Future<SleepReminderSettings?> getSleepReminderSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt(_prefKeySleepReminderHour);
    final minute = prefs.getInt(_prefKeySleepReminderMinute);
    final amPm = prefs.getString(_prefKeySleepReminderAmPm);
    final days = prefs.getStringList(_prefKeySleepReminderDays);
    
    if (hour != null && minute != null && amPm != null && days != null) {
      return SleepReminderSettings(
        hour: hour,
        minute: minute,
        amPm: amPm,
        days: days,
      );
    }
    
    return null;
  }
  
  Future<void> saveSleepReminderSettings(SleepReminderSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKeySleepReminderHour, settings.hour);
    await prefs.setInt(_prefKeySleepReminderMinute, settings.minute);
    await prefs.setString(_prefKeySleepReminderAmPm, settings.amPm);
    await prefs.setStringList(_prefKeySleepReminderDays, settings.days);
    
    // If reminders are enabled, schedule them
    final enabled = await isEnabled();
    if (enabled) {
      await scheduleSleepReminders(settings);
    }
  }
  
  Future<void> scheduleSleepReminders(SleepReminderSettings settings) async {
    // Cancel any existing reminders first
    await cancelSleepReminders();
    
    // Get hour in 24-hour format
    int hour = settings.hour;
    if (settings.amPm == 'PM' && settings.hour != 12) {
      hour += 12;
    } else if (settings.amPm == 'AM' && settings.hour == 12) {
      hour = 0;
    }
    
    // Schedule for each selected day
    for (String day in settings.days) {
      int dayOfWeek = _getDayOfWeek(day);
      
      // Get next date for this day of week
      final now = DateTime.now();
      final scheduledDate = _getNextDayOfWeek(dayOfWeek, hour, settings.minute);
      
      if (scheduledDate.isAfter(now)) {
        // Create unique ID for each day (different from meditation reminders)
        int id = 2000 + dayOfWeek;
        
        await _notificationService.zonedScheduleNotification(
          id: id,
          title: 'Time for Sleep',
          body: 'Prepare for a restful night with a sleep story.',
          scheduledDate: scheduledDate,
          payload: 'sleep_reminder',
          androidChannelId: 'sleep_channel',
          androidChannelName: 'Sleep Reminders',
          androidChannelDescription: 'Notifications for sleep reminders',
          repeatInterval: 7, // repeat weekly
        );
        
        debugPrint('Scheduled sleep reminder for ${scheduledDate.toString()}');
      }
    }
  }
  
  Future<void> cancelSleepReminders() async {
    // Cancel notifications with IDs 2000-2006 (for each day of the week)
    for (int i = 2000; i <= 2006; i++) {
      await _notificationService.cancelNotification(i);
    }
  }
  
  // Convert day string to day of week integer (1 = Monday, 7 = Sunday)
  int _getDayOfWeek(String day) {
    switch (day.toUpperCase()) {
      case 'M': return 1;
      case 'T': return 2;
      case 'W': return 3;
      case 'TH': return 4;
      case 'F': return 5;
      case 'S': return 6;
      case 'SU': return 7;
      default: return 1;
    }
  }
  
  // Get the next occurrence of a specific day of week
  DateTime _getNextDayOfWeek(int dayOfWeek, int hour, int minute) {
    final now = DateTime.now();
    
    // Convert to Dart's day of week (1 = Monday, 7 = Sunday)
    int currentDayOfWeek = now.weekday;
    if (currentDayOfWeek == 7) currentDayOfWeek = 0;
    
    // Calculate days to add
    int daysToAdd = dayOfWeek - currentDayOfWeek;
    if (daysToAdd <= 0) {
      daysToAdd += 7;
    }
    
    final result = DateTime(
      now.year,
      now.month,
      now.day + daysToAdd,
      hour,
      minute,
    );
    
    return result;
  }
} 