import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:meditation_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:meditation_app/features/auth/presentation/screens/welcome_screen.dart';
import 'package:meditation_app/features/meditation/presentation/screens/choose_topic_screen.dart';
import 'package:meditation_app/features/auth/domain/utils/auth_error_handler.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPrivacyPolicyAccepted = false;
  bool _isLoading = false;
  // Create a single instance of GoogleSignIn to reuse
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  Future<UserCredential?> signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in flow
        debugPrint('Google sign-in canceled by user');
        return null;
      }

      try {
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
      } catch (authError) {
        debugPrint('Google authentication error: $authError');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication failed: ${authError.toString()}')),
          );
        }
        return null;
      }
    } catch (e) {
      debugPrint('Google sign in error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in with Google: ${e.toString()}')),
        );
      }
      return null;
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Update user profile with name
        await userCredential.user?.updateDisplayName(_nameController.text.trim());
        
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AuthErrorHandler.getErrorMessage(e)),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background vector
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                'assets/images/signup_background_vector.svg',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    const Text(
                      'Create your account',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeue',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                        color: Color(0xFF3F414E),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Facebook button
                    SizedBox(
                      width: double.infinity,
                      height: 63,
                      child: ElevatedButton(
                        onPressed: _isLoading 
                            ? null 
                            : () async {
                                setState(() => _isLoading = true);
                                try {
                                  final FacebookAuth facebookAuth = FacebookAuth.instance;
                                  
                                  // Attempt to log in with Facebook
                                  final LoginResult result = await facebookAuth.login();
                                  if (result.status == LoginStatus.success) {
                                    // Get the access token
                                    final AccessToken? accessToken = result.accessToken;
                                    if (accessToken == null) {
                                      throw Exception('Failed to get Facebook access token');
                                    }
                                    
                                    // Create a credential
                                    final OAuthCredential credential = 
                                        FacebookAuthProvider.credential(accessToken.token);
                                    
                                    // Sign in with Firebase using the Facebook credential
                                    final userCredential = 
                                        await FirebaseAuth.instance.signInWithCredential(credential);
                                    
                                    if (mounted && userCredential.user != null) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const ChooseTopicScreen(),
                                        ),
                                      );
                                    }
                                  } else {
                                    // Handle failed or canceled login
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Facebook login failed: ${result.message}')),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Facebook login error: $e')),
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() => _isLoading = false);
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7583CA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(38),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Row(
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
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Google button
                    SizedBox(
                      width: double.infinity,
                      height: 63,
                      child: OutlinedButton(
                        onPressed: _isLoading 
                            ? null
                            : () async {
                                try {
                                  final userCredential = await signInWithGoogle();
                                  if (userCredential != null && mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ChooseTopicScreen(),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  debugPrint('Navigation error after Google sign-in: $e');
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                }
                              },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFEBEAEC)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(38),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8E97FD)),
                                ),
                              )
                            : Row(
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
                    ),
                    const SizedBox(height: 30),
                    // OR divider
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
                    // Name input
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Name',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Email input
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Password input
                    TextFormField(
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    // Privacy policy checkbox
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _isPrivacyPolicyAccepted,
                            onChanged: (value) {
                              setState(() {
                                _isPrivacyPolicyAccepted = value ?? false;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: const BorderSide(
                              color: Color(0xFFA1A4B2),
                              width: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'I have read the Privacy Policy',
                          style: TextStyle(
                            fontFamily: 'HelveticaNeue',
                            fontSize: 14,
                            letterSpacing: 0.7,
                            color: Color(0xFF8E97FD),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Get Started button
                    SizedBox(
                      width: double.infinity,
                      height: 63,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8E97FD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(38),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'GET STARTED',
                                style: TextStyle(
                                  fontFamily: 'HelveticaNeue',
                                  fontSize: 14,
                                  letterSpacing: 0.7,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Sign in link
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'ALREADY HAVE AN ACCOUNT? LOG IN',
                          style: TextStyle(
                            fontFamily: 'HelveticaNeue',
                            fontSize: 14,
                            letterSpacing: 0.7,
                            color: Color(0xFF3F414E),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
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
