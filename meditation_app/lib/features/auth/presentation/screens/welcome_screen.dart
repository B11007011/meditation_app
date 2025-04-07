import 'package:flutter/material.dart';
import 'package:meditation_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:meditation_app/features/meditation/presentation/screens/choose_topic_screen.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  final String userName;
  
  const WelcomeScreen({
    super.key,
    this.userName = 'Afsar',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // Background elements
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            right: 20,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.welcomePurpleLight,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: 30,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.welcomePurpleMedium,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            right: 50,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.welcomePurpleMedium,
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  // Logo
                  Opacity(
                    opacity: 0.75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/logo.png', height: 40),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Silent',
                              style: TextStyle(
                                fontFamily: 'Airbnb Cereal App',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 3.84,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              'Moon',
                              style: TextStyle(
                                fontFamily: 'Airbnb Cereal App',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 3.84,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Welcome text
                  Text(
                    'Hi $userName, Welcome \nto Silent Moon',
                    style: const TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      height: 1.37,
                      letterSpacing: 0.3,
                      color: AppColors.welcomeYellow,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  // Description
                  const Text(
                    'Explore the app, Find some peace of mind to prepare for meditation.',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                      height: 1.69,
                      color: AppColors.welcomeLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  // Meditation illustration
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/images/welcome_illustration.png',
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                  ),
                  const Spacer(),
                  // Get started button
                  SizedBox(
                    width: double.infinity,
                    height: 63,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChooseTopicScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38),
                        ),
                      ),
                      child: const Text(
                        'GET STARTED',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          letterSpacing: 0.7,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 