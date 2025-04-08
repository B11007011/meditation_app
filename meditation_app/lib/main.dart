import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meditation_app/features/home/presentation/screens/home_screen.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/features/meditation/domain/models/meditation_session.dart';
import 'package:meditation_app/features/sleep/domain/models/sleep_data.dart';
import 'package:meditation_app/features/music/domain/models/music_track.dart';
import 'package:meditation_app/features/profile/domain/models/user_profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(MeditationSessionAdapter());
  Hive.registerAdapter(SleepDataAdapter());
  Hive.registerAdapter(MusicTrackAdapter());
  Hive.registerAdapter(UserProfileAdapter());

  // Open Hive boxes
  await Hive.openBox<MeditationSession>('meditation_sessions');
  await Hive.openBox<SleepData>('sleep_data');
  await Hive.openBox<MusicTrack>('music_tracks');
  await Hive.openBox<UserProfile>('user_profile');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const bool startAtHomeScreen = true; // Set to false for auth flow

    return MaterialApp(
      title: 'Silent Moon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'HelveticaNeue',
      ),
      home: const HomeScreen(),
    );
  }
}
