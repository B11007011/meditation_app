import 'package:flutter/foundation.dart';

/// A simple analytics service to track user events and app usage.
/// In a production app, this would be connected to Firebase Analytics,
/// Mixpanel, or another analytics provider.
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();

  factory AnalyticsService() {
    return _instance;
  }

  AnalyticsService._internal();

  /// Track a screen view
  void logScreenView(String screenName) {
    if (kDebugMode) {
      print('ANALYTICS: Screen View - $screenName');
    }
    // In production: FirebaseAnalytics.instance.logScreenView(screenName: screenName);
  }

  /// Track a user action/event
  void logEvent(String eventName, {Map<String, dynamic>? parameters}) {
    if (kDebugMode) {
      print('ANALYTICS: Event - $eventName ${parameters != null ? '- $parameters' : ''}');
    }
    // In production: FirebaseAnalytics.instance.logEvent(name: eventName, parameters: parameters);
  }

  /// Track app crashes
  void logError(String error, StackTrace? stackTrace) {
    if (kDebugMode) {
      print('ANALYTICS: Error - $error');
      if (stackTrace != null) {
        print(stackTrace);
      }
    }
    // In production: FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }

  /// Track user login
  void logLogin(String loginMethod) {
    if (kDebugMode) {
      print('ANALYTICS: Login - $loginMethod');
    }
    // In production: FirebaseAnalytics.instance.logLogin(loginMethod: loginMethod);
  }

  /// Track meditation session
  void logMeditationSession(String meditationId, int durationSeconds) {
    if (kDebugMode) {
      print('ANALYTICS: Meditation Session - $meditationId - $durationSeconds seconds');
    }
    // In production: FirebaseAnalytics.instance.logEvent(
    //   name: 'meditation_session',
    //   parameters: {
    //     'meditation_id': meditationId,
    //     'duration_seconds': durationSeconds,
    //   },
    // );
  }

  /// Track subscription purchase
  void logSubscription(String subscriptionId, double price, String currency) {
    if (kDebugMode) {
      print('ANALYTICS: Subscription - $subscriptionId - $price $currency');
    }
    // In production: FirebaseAnalytics.instance.logPurchase(
    //   currency: currency,
    //   value: price,
    //   items: [subscriptionId],
    // );
  }
}
