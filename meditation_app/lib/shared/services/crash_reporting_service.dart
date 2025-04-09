import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashReportingService {
  static final CrashReportingService _instance = CrashReportingService._internal();
  factory CrashReportingService() => _instance;
  
  CrashReportingService._internal();

  final _crashlytics = FirebaseCrashlytics.instance;

  /// Initialize crash reporting
  Future<void> initialize() async {
    await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
    FlutterError.onError = _crashlytics.recordFlutterError;
  }

  /// Log a message to Crashlytics
  void log(String message) {
    _crashlytics.log(message);
  }

  /// Record a non-fatal error
  Future<void> recordError(dynamic error, StackTrace? stack, {
    bool fatal = false,
    Map<String, dynamic>? customKeys,
  }) async {
    if (customKeys != null) {
      for (final entry in customKeys.entries) {
        await _crashlytics.setCustomKey(entry.key, entry.value);
      }
    }

    await _crashlytics.recordError(
      error,
      stack,
      fatal: fatal,
    );
  }

  /// Set user identifier for better crash reporting
  Future<void> setUserIdentifier(String identifier) async {
    await _crashlytics.setUserIdentifier(identifier);
  }

  /// Add custom keys for better crash reporting
  Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  /// Force a crash for testing purposes (only in debug mode)
  void forceCrash() {
    if (kDebugMode) {
      throw Exception('This is a test crash');
    }
  }
} 