import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:rxdart/subjects.dart';
import 'package:meditation_app/features/meditation/domain/models/reminder_settings.dart';

class ReceivedNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotification({
    required this.id,
    this.title,
    this.body,
    this.payload,
  });
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<ReceivedNotification> _onNotificationClick = BehaviorSubject<ReceivedNotification>();
  
  // Singleton pattern
  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Stream<ReceivedNotification> get onNotificationClick => _onNotificationClick.stream;

  Future<void> initialize() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );
    
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
    
    // Request permissions for iOS
    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  void _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    debugPrint('Received iOS notification: $id - $title');
    _onNotificationClick.add(
      ReceivedNotification(id: id, title: title, body: body, payload: payload),
    );
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    debugPrint('Received notification response: ${response.payload}');
    _onNotificationClick.add(
      ReceivedNotification(
        id: response.id ?? 0,
        payload: response.payload,
      ),
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'meditation_channel',
      'Meditation Reminders',
      channelDescription: 'Notifications for meditation reminders',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      color: Color(0xFF8E97FD),
    );
    
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  /// Schedule a meditation reminder based on the provided settings
  Future<void> scheduleMeditationReminder(ReminderSettings settings) async {
    // Cancel any existing reminders
    await cancelMeditationReminders();
    
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
      final DateTime now = DateTime.now();
      final DateTime scheduledDate = _getNextDayOfWeek(dayOfWeek, hour, settings.minute);
      
      if (scheduledDate.isAfter(now)) {
        // Create unique ID for each day
        int id = 1000 + dayOfWeek;
        
        await _scheduleWeeklyNotification(
          id: id,
          title: 'Time to Meditate',
          body: 'Your daily meditation session is ready for you.',
          scheduledDate: scheduledDate,
          dayOfWeek: dayOfWeek,
        );
        
        debugPrint('Scheduled meditation reminder for ${scheduledDate.toString()}');
      }
    }
  }

  Future<void> _scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required int dayOfWeek,
  }) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'meditation_channel',
          'Meditation Reminders',
          channelDescription: 'Notifications for meditation reminders',
          importance: Importance.max,
          priority: Priority.high,
          color: Color(0xFF8E97FD),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: 'meditation_reminder',
    );
  }

  Future<void> cancelMeditationReminders() async {
    // Cancel notifications with IDs 1000-1006 (for each day of the week)
    for (int i = 1000; i <= 1006; i++) {
      await _flutterLocalNotificationsPlugin.cancel(i);
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
    final DateTime now = DateTime.now();
    
    // Convert to Dart's day of week (1 = Monday, 7 = Sunday)
    int currentDayOfWeek = now.weekday;
    if (currentDayOfWeek == 7) currentDayOfWeek = 0;
    
    // Calculate days to add
    int daysToAdd = dayOfWeek - currentDayOfWeek;
    if (daysToAdd <= 0) {
      daysToAdd += 7;
    }
    
    final DateTime result = DateTime(
      now.year,
      now.month,
      now.day + daysToAdd,
      hour,
      minute,
    );
    
    return result;
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotifications =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications;
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> zonedScheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String androidChannelId = 'meditation_channel',
    String androidChannelName = 'Meditation Reminders',
    String androidChannelDescription = 'Notifications for meditation reminders',
    int? repeatInterval,
  }) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidChannelId,
          androidChannelName,
          channelDescription: androidChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          color: const Color(0xFF8E97FD),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: repeatInterval != null 
          ? DateTimeComponents.dayOfWeekAndTime 
          : null,
      payload: payload,
    );
  }
  
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
} 