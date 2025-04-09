import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation_app/features/auth/presentation/screens/signup_signin_screen.dart';
import 'package:meditation_app/features/home/presentation/screens/home_screen.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/shared/services/analytics_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  final AnalyticsService _analytics = AnalyticsService();
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      _analytics.logScreenView('splash_screen');
      _analytics.logEvent('app_start');
      
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2000),
      );

      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
        ),
      );

      _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
        ),
      );

      await _animationController.forward();

      // Add a small delay to ensure animations complete
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        await _checkAuthAndNavigate();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
      }
    }
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (mounted) {
        if (user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SignUpScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Authentication error: ${e.toString()}';
        });
        // Wait a bit before falling back to sign up screen
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SignUpScreen()),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: _error != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 50, color: Colors.red),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              : AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 100,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.self_improvement,
                                  size: 100,
                                  color: AppColors.primary,
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Silent Moon',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Meditate, Sleep, Relax',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontSize: 16,
                                color: Color(0xFFA1A4B2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
