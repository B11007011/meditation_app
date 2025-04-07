import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app/features/auth/presentation/screens/signup_signin_screen.dart';
import 'package:meditation_app/features/home/presentation/screens/home_screen.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/features/profile/presentation/providers/profile_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set this to true to start directly at the Home screen for debugging
    const bool startAtHomeScreen = true;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        title: 'Silent Moon',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'HelveticaNeue',
        ),
        home: startAtHomeScreen ? const HomeScreen() : const SignUpScreen(),
      ),
    );
  }
}
