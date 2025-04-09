import 'package:flutter/material.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _meditationReminders = true;
  bool _newContentNotifications = true;
  bool _sleepReminders = true;
  bool _promotionalNotifications = false;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _meditationReminders = prefs.getBool('meditation_reminders') ?? true;
      _newContentNotifications = prefs.getBool('new_content_notifications') ?? true;
      _sleepReminders = prefs.getBool('sleep_reminders') ?? true;
      _promotionalNotifications = prefs.getBool('promotional_notifications') ?? false;
    });
  }
  
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('meditation_reminders', _meditationReminders);
    await prefs.setBool('new_content_notifications', _newContentNotifications);
    await prefs.setBool('sleep_reminders', _sleepReminders);
    await prefs.setBool('promotional_notifications', _promotionalNotifications);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
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
                'Manage your notification preferences',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 16,
                  color: Color(0xFFA1A4B2),
                ),
              ),
              const SizedBox(height: 30),
              _buildSwitchTile(
                title: 'Meditation Reminders',
                subtitle: 'Remind you of your daily meditation sessions',
                value: _meditationReminders,
                onChanged: (value) {
                  setState(() {
                    _meditationReminders = value;
                  });
                  _saveSettings();
                },
              ),
              _buildDivider(),
              _buildSwitchTile(
                title: 'New Content',
                subtitle: 'Be notified when new meditations are added',
                value: _newContentNotifications,
                onChanged: (value) {
                  setState(() {
                    _newContentNotifications = value;
                  });
                  _saveSettings();
                },
              ),
              _buildDivider(),
              _buildSwitchTile(
                title: 'Sleep Reminders',
                subtitle: 'Remind you to prepare for sleep',
                value: _sleepReminders,
                onChanged: (value) {
                  setState(() {
                    _sleepReminders = value;
                  });
                  _saveSettings();
                },
              ),
              _buildDivider(),
              _buildSwitchTile(
                title: 'Promotional Notifications',
                subtitle: 'Receive offers and updates about premium features',
                value: _promotionalNotifications,
                onChanged: (value) {
                  setState(() {
                    _promotionalNotifications = value;
                  });
                  _saveSettings();
                },
              ),
              _buildDivider(),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notification settings saved')),
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

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFFF2F2F7),
      thickness: 1,
      height: 1,
    );
  }
}
