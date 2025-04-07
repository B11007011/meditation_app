import 'package:flutter/material.dart';
import 'package:meditation_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:meditation_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:meditation_app/features/auth/presentation/screens/welcome_screen.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 50),
                // Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png', height: 40),
                    const SizedBox(width: 10),
                    // const Text(
                    //   'Silent Moon',
                    //   style: AppTextStyles.logo,
                    // ),
                  ],
                ),
                const SizedBox(height: 40),
                // Main illustration
                Image.asset(
                  'assets/images/signup_illustration.png',
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                const SizedBox(height: 40),
                // Heading
                const Text(
                  'We are what we do',
                  style: AppTextStyles.heading1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                // Subheading
                const Text(
                  'Thousand of people are using silent moon\nfor small meditation',
                  style: AppTextStyles.body1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Sign up button
                SizedBox(
                  width: double.infinity,
                  height: 63,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateAccountScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(38),
                      ),
                    ),
                    child: Text(
                      'SIGN UP',
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Login link
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'ALREADY HAVE AN ACCOUNT? LOG IN',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 