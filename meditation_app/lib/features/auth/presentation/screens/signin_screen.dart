import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meditation_app/features/auth/presentation/screens/signup_signin_screen.dart';
import 'package:meditation_app/features/meditation/presentation/screens/choose_topic_screen.dart';
import 'package:meditation_app/features/home/presentation/screens/home_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background vector
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              child: SvgPicture.asset(
                'assets/images/background_vector.svg',
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeue',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3F414E),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Facebook button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7583CA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38),
                        ),
                        minimumSize: const Size(double.infinity, 63),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/facebook_icon.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'CONTINUE WITH FACEBOOK',
                            style: TextStyle(
                              fontFamily: 'HelveticaNeue',
                              fontSize: 14,
                              letterSpacing: 0.7,
                              color: Color(0xFFF6F1FB),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Google button
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFEBEAEC)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38),
                        ),
                        minimumSize: const Size(double.infinity, 63),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Stack(
                              children: [
                                SvgPicture.asset('assets/images/google_icon_1.svg'),
                                SvgPicture.asset('assets/images/google_icon_2.svg'),
                                SvgPicture.asset('assets/images/google_icon_3.svg'),
                                SvgPicture.asset('assets/images/google_icon_4.svg'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'CONTINUE WITH GOOGLE',
                            style: TextStyle(
                              fontFamily: 'HelveticaNeue',
                              fontSize: 14,
                              letterSpacing: 0.7,
                              color: Color(0xFF3F414E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Center(
                      child: Text(
                        'OR LOG IN WITH EMAIL',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                          color: Color(0xFFA1A4B2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Email input
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Email address',
                        hintStyle: const TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.8,
                          color: Color(0xFFA1A4B2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF2F3F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password input
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.8,
                          color: Color(0xFFA1A4B2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF2F3F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Forgot Password
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontFamily: 'HelveticaNeue',
                            fontSize: 14,
                            letterSpacing: 0.7,
                            color: Color(0xFF3F414E),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Login button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E97FD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38),
                        ),
                        minimumSize: const Size(double.infinity, 63),
                      ),
                      child: const Text(
                        'LOG IN',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 14,
                          letterSpacing: 0.7,
                          color: Color(0xFFF6F1FB),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Sign up link
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "DON'T HAVE AN ACCOUNT? SIGN UP",
                          style: TextStyle(
                            fontFamily: 'HelveticaNeue',
                            fontSize: 14,
                            letterSpacing: 0.7,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 