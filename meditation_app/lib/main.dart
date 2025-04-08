import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app/features/auth/presentation/screens/signup_signin_screen.dart';
import 'package:meditation_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:meditation_app/firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    debugPrint('Firebase Initialization Error: $e');
    // Add fallback UI for initialization errors
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Failed to initialize Firebase. Please restart the app.'),
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
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Meditation App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SignUpScreen(),
      ),
    );
  }
}
