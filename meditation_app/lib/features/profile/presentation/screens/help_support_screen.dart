import 'package:flutter/material.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Help & Support',
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
                'How can we help you?',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 16,
                  color: Color(0xFFA1A4B2),
                ),
              ),
              const SizedBox(height: 30),
              _buildSearchBar(),
              const SizedBox(height: 30),
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3F414E),
                ),
              ),
              const SizedBox(height: 20),
              _buildFaqItem(
                context: context,
                question: 'How do I track my meditation progress?',
                answer: 'Your meditation progress is automatically tracked in your profile. You can view your total meditation time, number of sessions, and current streak on your profile page.',
              ),
              _buildFaqItem(
                context: context,
                question: 'Can I download meditations for offline use?',
                answer: 'Yes, premium users can download meditations for offline use. Simply tap the download icon on any meditation to save it to your device.',
              ),
              _buildFaqItem(
                context: context,
                question: 'How do I set up meditation reminders?',
                answer: 'You can set up meditation reminders in the Reminder screen. Navigate to your profile, tap on "Notifications", and then configure your preferred reminder times.',
              ),
              _buildFaqItem(
                context: context,
                question: "What's included in the premium subscription?",
                answer: 'Premium subscription includes access to all meditation content, offline downloads, sleep stories, and exclusive music tracks. It also removes ads and provides advanced tracking features.',
              ),
              _buildFaqItem(
                context: context,
                question: 'How do I cancel my subscription?',
                answer: 'You can cancel your subscription through your app store account (Google Play or App Store). Go to your subscription management settings and select Silent Moon to cancel.',
              ),
              const SizedBox(height: 30),
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3F414E),
                ),
              ),
              const SizedBox(height: 20),
              _buildContactOption(
                icon: Icons.email_outlined,
                title: 'Email Support',
                subtitle: 'Get help via email',
                onTap: () {
                  _showContactDialog(
                    context,
                    'Email Support',
                    'Our support team will respond within 24 hours.',
                    'support@silentmoon.com',
                  );
                },
              ),
              _buildContactOption(
                icon: Icons.chat_bubble_outline,
                title: 'Live Chat',
                subtitle: 'Chat with our support team',
                onTap: () {
                  _showContactDialog(
                    context,
                    'Live Chat',
                    'Available Monday-Friday, 9am-5pm PST',
                    'Start a chat session',
                  );
                },
              ),
              _buildContactOption(
                icon: Icons.help_outline,
                title: 'Help Center',
                subtitle: 'Browse our knowledge base',
                onTap: () {
                  _showContactDialog(
                    context,
                    'Help Center',
                    'Find answers to common questions',
                    'Visit our help center',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for help',
          hintStyle: const TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 14,
            color: Color(0xFFA1A4B2),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFFA1A4B2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildFaqItem({
    required BuildContext context,
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF3F414E),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: const TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 14,
              color: Color(0xFFA1A4B2),
              height: 1.5,
            ),
          ),
        ),
      ],
      iconColor: AppColors.primary,
      collapsedIconColor: const Color(0xFFA1A4B2),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color.fromRGBO(142, 151, 253, 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
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
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFA1A4B2),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(
    BuildContext context,
    String title,
    String message,
    String actionText,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F3F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  actionText,
                  style: const TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Feature will be available in the next update'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }
}
