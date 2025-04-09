import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meditation_app/features/profile/domain/models/user_profile.dart';
import 'package:meditation_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:meditation_app/features/meditation/domain/repositories/meditation_repository.dart';
import 'package:meditation_app/features/meditation/domain/services/meditation_player_service.dart';
import 'package:meditation_app/features/meditation/domain/models/meditation.dart';
import 'package:meditation_app/firebase_options.dart';
import 'package:meditation_app/shared/adapters/duration_adapter.dart';
import 'package:meditation_app/shared/adapters/datetime_adapter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> initializeApp() async {
  try {
    // Initialize Firebase with default options
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Pass all uncaught errors to Crashlytics
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      
      // Enable Crashlytics data collection
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } catch (e) {
      // More detailed logging for Firebase initialization errors
      debugPrint('Firebase initialization error: $e');
      // Check for common Firebase errors
      if (e.toString().contains('package name') || e.toString().contains('applicationId')) {
        debugPrint('Package name mismatch detected between app and Firebase config.');
        debugPrint('Make sure google-services.json has the same package name as your build.gradle applicationId.');
      }
      // Continue with the app even if Firebase fails to initialize
    }

    // Initialize Hive for local storage - wrapped in try/catch for safety
    try {
      await Hive.initFlutter();
      
      // Delete and recreate any existing Hive boxes to resolve compatibility issues
      try {
        await Hive.deleteBoxFromDisk('user_profile');
        await Hive.deleteBoxFromDisk('meditations');
      } catch (e) {
        debugPrint('Error deleting Hive boxes: $e');
      }
      
      // Clear adapter registry to avoid conflicts
      try {
        Hive.resetAdapters();
      } catch (e) {
        debugPrint('Error resetting Hive adapters: $e');
      }
      
      // Register adapters with explicit typeIds
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(UserProfileAdapter());
      }
      if (!Hive.isAdapterRegistered(5)) {
        Hive.registerAdapter(MeditationAdapter());
      }
      if (!Hive.isAdapterRegistered(4)) {
        Hive.registerAdapter(DurationAdapter());
      }
      if (!Hive.isAdapterRegistered(33)) {
        Hive.registerAdapter(DateTimeAdapter());
      }
      
      // Open boxes with better error handling
      try {
        await Hive.openBox<UserProfile>('user_profile');
      } catch (e) {
        debugPrint('Error opening user_profile box: $e');
        // On error, try to recreate the box
        await Hive.deleteBoxFromDisk('user_profile');
        await Hive.openBox<UserProfile>('user_profile');
      }
    } catch (e) {
      debugPrint('Hive initialization error: $e');
      // Continue without Hive if necessary
    }
    
    // Initialize repositories and services
    try {
      final meditationRepository = MeditationRepository();
      await meditationRepository.initialize();
      
      final meditationPlayerService = MeditationPlayerService();
      await meditationPlayerService.initialize();
    } catch (e) {
      debugPrint('Error initializing repositories/services: $e');
      // Continue with initialization even if repositories have issues
    }
  } catch (e) {
    debugPrint('Initialization Error: $e');
    rethrow;
  }
}

void main() async {
  // Set this flag to true to make zone errors fatal - catches zone mismatches
  BindingBase.debugZoneErrorsAreFatal = true;
  
  runZonedGuarded(() async {
    try {
      // Move ensureInitialized inside the zone to avoid zone mismatch
      WidgetsFlutterBinding.ensureInitialized();
      
      await initializeApp();
      runApp(const ProviderScope(child: MyApp()));
    } catch (e, stack) {
      debugPrint('Initialization Error: $e');
      FirebaseCrashlytics.instance.recordError(e, stack);
      // Add fallback UI for initialization errors
      runApp(
        MaterialApp(
          title: 'Silent Moon',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'HelveticaNeue',
          ),
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 20),
                  const Text('Failed to initialize the app.', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('Error: $e', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => main(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }, (error, stack) {
    // Handle any errors that occur in the zone
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Silent Moon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'HelveticaNeue',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}
