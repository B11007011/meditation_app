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
      debugPrint('Firebase initialization error (continuing anyway): $e');
      // Continue with the app even if Firebase fails to initialize
    }

    // Initialize Hive for local storage
    await Hive.initFlutter();
    
    // Clear adapter registry to avoid conflicts
    Hive.resetAdapters();
    
    // Register adapters
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(MeditationAdapter());
    Hive.registerAdapter(DurationAdapter());
    
    // Open boxes - create a new box if it doesn't exist
    try {
      await Hive.openBox<UserProfile>('user_profile');
    } catch (e) {
      debugPrint('Error opening Hive box: $e');
      // Try to delete and recreate the box
      await Hive.deleteBoxFromDisk('user_profile');
      await Hive.openBox<UserProfile>('user_profile');
    }
    
    // Initialize repositories and services
    final meditationRepository = MeditationRepository();
    await meditationRepository.initialize();
    
    final meditationPlayerService = MeditationPlayerService();
    await meditationPlayerService.initialize();
  } catch (e) {
    debugPrint('Initialization Error: $e');
    rethrow;
  }
}

void main() async {
  // Ensure Flutter is initialized before doing anything else
  WidgetsFlutterBinding.ensureInitialized();
  
  runZonedGuarded(() async {
    try {
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
