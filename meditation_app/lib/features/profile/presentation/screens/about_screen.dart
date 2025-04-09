import 'package:flutter/material.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = '';
  String _buildNumber = '';
  
  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }
  
  Future<void> _loadPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _version = packageInfo.version;
        _buildNumber = packageInfo.buildNumber;
      });
    } catch (e) {
      setState(() {
        _version = '1.0.0';
        _buildNumber = '1';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'About',
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3F414E),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3F414E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/images/logo.png', height: 80),
              const SizedBox(height: 15),
              const Text(
                'Silent Moon',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3F414E),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Version $_version ($_buildNumber)',
                style: const TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 14,
                  color: Color(0xFFA1A4B2),
                ),
              ),
              const SizedBox(height: 40),
              _buildInfoSection(
                title: 'About Silent Moon',
                content: 'Silent Moon is a meditation app designed to help you reduce stress, improve focus, and enhance your overall well-being. Our app offers guided meditations, sleep stories, and relaxing music to help you find peace in your daily life.',
              ),
              _buildInfoSection(
                title: 'Our Mission',
                content: 'Our mission is to make meditation accessible to everyone. We believe that a few minutes of mindfulness each day can transform your life, improving mental health and bringing inner peace.',
              ),
              _buildInfoSection(
                title: 'Our Team',
                content: 'Silent Moon was created by a team of meditation experts, psychologists, and developers passionate about mental health and well-being. We are dedicated to providing the best meditation experience possible.',
              ),
              const SizedBox(height: 30),
              _buildSocialLinks(),
              const SizedBox(height: 40),
              const Text(
                '© 2025 Silent Moon. All rights reserved.',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 12,
                  color: Color(0xFFA1A4B2),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3F414E),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 16,
              color: Color(0xFF5F6368),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Column(
      children: [
        const Text(
          'Follow us',
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3F414E),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              icon: Icons.language,
              label: 'Website',
              onTap: () {
                _showComingSoonDialog(context);
              },
            ),
            const SizedBox(width: 20),
            _buildSocialButton(
              icon: Icons.facebook,
              label: 'Facebook',
              onTap: () {
                _showComingSoonDialog(context);
              },
            ),
            const SizedBox(width: 20),
            _buildSocialButton(
              icon: Icons.camera_alt_outlined,
              label: 'Instagram',
              onTap: () {
                _showComingSoonDialog(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 12,
              color: Color(0xFF3F414E),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Coming Soon'),
          content: const Text(
            'This feature will be available in the next update. Stay tuned!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
