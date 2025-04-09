import 'package:flutter/material.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _analyticsEnabled = true;
  bool _personalization = true;
  bool _thirdPartySharing = false;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _analyticsEnabled = prefs.getBool('analytics_enabled') ?? true;
      _personalization = prefs.getBool('personalization') ?? true;
      _thirdPartySharing = prefs.getBool('third_party_sharing') ?? false;
    });
  }
  
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('analytics_enabled', _analyticsEnabled);
    await prefs.setBool('personalization', _personalization);
    await prefs.setBool('third_party_sharing', _thirdPartySharing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Privacy',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Manage your privacy settings',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 16,
                  color: Color(0xFFA1A4B2),
                ),
              ),
              const SizedBox(height: 30),
              _buildSwitchTile(
                title: 'Analytics',
                subtitle: 'Help us improve by allowing anonymous usage data collection',
                value: _analyticsEnabled,
                onChanged: (value) {
                  setState(() {
                    _analyticsEnabled = value;
                  });
                  _saveSettings();
                },
              ),
              _buildDivider(),
              _buildSwitchTile(
                title: 'Personalization',
                subtitle: 'Allow us to personalize your experience based on your usage',
                value: _personalization,
                onChanged: (value) {
                  setState(() {
                    _personalization = value;
                  });
                  _saveSettings();
                },
              ),
              _buildDivider(),
              _buildSwitchTile(
                title: 'Third-Party Data Sharing',
                subtitle: 'Allow sharing of anonymous data with trusted partners',
                value: _thirdPartySharing,
                onChanged: (value) {
                  setState(() {
                    _thirdPartySharing = value;
                  });
                  _saveSettings();
                },
              ),
              _buildDivider(),
              const SizedBox(height: 30),
              _buildPrivacyButton(
                title: 'View Privacy Policy',
                onTap: () {
                  _showPrivacyPolicy(context);
                },
              ),
              const SizedBox(height: 15),
              _buildPrivacyButton(
                title: 'View Terms of Service',
                onTap: () {
                  _showTermsOfService(context);
                },
              ),
              const SizedBox(height: 15),
              _buildPrivacyButton(
                title: 'Delete My Account',
                onTap: () {
                  _showDeleteAccountDialog(context);
                },
                isDestructive: true,
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy settings saved')),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(38),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    'Save Settings',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3F414E),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 14,
                    color: Color(0xFFA1A4B2),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyButton({
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: isDestructive ? Colors.red.shade300 : const Color(0xFFE5E5E5),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDestructive ? Colors.red.shade700 : const Color(0xFF3F414E),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFFF2F2F7),
      thickness: 1,
      height: 1,
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            AppBar(
              title: const Text('Privacy Policy'),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(20),
                children: const [
                  Text(
                    'Privacy Policy',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Last updated: April 9, 2025',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Silent Moon ("we" or "our") is committed to protecting your privacy. This Privacy Policy explains how your personal information is collected, used, and disclosed by Silent Moon.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'INFORMATION WE COLLECT',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'We collect information you provide directly to us, such as when you create an account, update your profile, use the interactive features of our service, participate in contests, surveys, or events, request customer support, or otherwise communicate with us.',
                    style: TextStyle(fontSize: 16),
                  ),
                  // Additional privacy policy content would go here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            AppBar(
              title: const Text('Terms of Service'),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(20),
                children: const [
                  Text(
                    'Terms of Service',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Last updated: April 9, 2025',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Please read these Terms of Service carefully before using the Silent Moon application operated by our company.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'ACCEPTANCE OF TERMS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'By accessing or using our service, you agree to be bound by these Terms. If you disagree with any part of the terms, then you may not access the service.',
                    style: TextStyle(fontSize: 16),
                  ),
                  // Additional terms of service content would go here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement account deletion logic
                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deletion request submitted. You will receive a confirmation email.'),
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
