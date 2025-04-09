import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meditation_app/features/auth/presentation/screens/signup_signin_screen.dart';
import 'package:meditation_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meditation_app/features/profile/domain/models/user_profile.dart';
import 'package:meditation_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:meditation_app/features/meditation/domain/repositories/meditation_repository.dart';
import 'package:meditation_app/features/meditation/domain/services/meditation_player_service.dart';
import 'package:meditation_app/features/meditation/domain/models/meditation.dart';
import 'package:meditation_app/firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase with default options
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Initialize Hive for local storage
    await Hive.initFlutter();
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(MeditationAdapter());
    await Hive.openBox<UserProfile>('userProfiles');
    
    // Initialize repositories and services
    final meditationRepository = MeditationRepository();
    await meditationRepository.initialize();
    
    final meditationPlayerService = MeditationPlayerService();
    await meditationPlayerService.initialize();
    
    runApp(const MyApp());
  } catch (e) {
    debugPrint('Initialization Error: $e');
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
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => MeditationPlayerService()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Silent Moon',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'HelveticaNeue',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
