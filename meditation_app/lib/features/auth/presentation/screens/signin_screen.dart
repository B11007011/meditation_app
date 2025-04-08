import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meditation_app/features/auth/presentation/screens/signup_signin_screen.dart';
import 'package:meditation_app/features/home/presentation/screens/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with WidgetsBindingObserver {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Handle background state
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<UserCredential?> signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Google sign in error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: ${e.toString()}')),
      );
      return null;
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final UserCredential userCredential = 
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

      if (userCredential.user != null && mounted) {
        // Add delay to allow proper widget disposal
        await Future.delayed(const Duration(milliseconds: 100));
        if (!mounted) return;
        
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      // Improved error handling
      String errorMessage = 'Sign-in failed. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: $e')),
        );
      }
    }
  }

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
                      onPressed: _isLoading 
                          ? null
                          : () async {
                              final userCredential = await signInWithGoogle();
                              if (userCredential != null && mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              }
                            },
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
                      controller: _emailController,
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
                      controller: _passwordController,
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
                      onPressed: _isLoading ? null : () async {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text;
                        
                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter email and password')),
                          );
                          return;
                        }

                        setState(() => _isLoading = true);
                        try {
                          await _signInWithEmailAndPassword();
                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Login failed: ${e.message}')),
                          );
                        } finally {
                          if (mounted) {
                            setState(() => _isLoading = false);
                          }
                        }
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
