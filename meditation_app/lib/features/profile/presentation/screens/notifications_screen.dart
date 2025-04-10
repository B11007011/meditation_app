import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meditation_app/shared/providers/shared_providers.dart';
import 'package:meditation_app/shared/services/notification_service.dart';
import 'package:meditation_app/features/meditation/domain/models/reminder_settings.dart';
import 'package:meditation_app/features/meditation/presentation/screens/reminder_screen.dart';
import 'package:meditation_app/features/sleep/domain/providers/sleep_reminder_provider.dart';
import 'package:meditation_app/features/sleep/domain/services/sleep_reminder_service.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool _meditationReminders = true;
  bool _newContentNotifications = true;
  bool _sleepReminders = true;
  bool _promotionalNotifications = false;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _meditationReminders = prefs.getBool('meditation_reminders') ?? true;
        _newContentNotifications = prefs.getBool('new_content_notifications') ?? true;
        _sleepReminders = prefs.getBool('sleep_reminders') ?? true;
        _promotionalNotifications = prefs.getBool('promotional_notifications') ?? false;
      });
      
      // Check if we have pending notifications
      final notificationService = ref.read(notificationServiceProvider);
      final pendingNotifications = await notificationService.getPendingNotifications();
      
      // If meditation reminders are enabled but no notifications are scheduled,
      // try to reschedule from saved settings
      if (_meditationReminders && pendingNotifications.isEmpty) {
        _tryRescheduleMeditationReminders();
      }
      
    } catch (e) {
      debugPrint('Error loading notification settings: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _saveSettings() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('meditation_reminders', _meditationReminders);
      await prefs.setBool('new_content_notifications', _newContentNotifications);
      await prefs.setBool('sleep_reminders', _sleepReminders);
      await prefs.setBool('promotional_notifications', _promotionalNotifications);
      
      final notificationService = ref.read(notificationServiceProvider);
      
      // Handle meditation reminders
      if (_meditationReminders) {
        await _tryRescheduleMeditationReminders();
      } else {
        await notificationService.cancelMeditationReminders();
      }
      
      // Handle sleep reminders
      final sleepReminderService = ref.read(sleepReminderServiceProvider);
      await sleepReminderService.setEnabled(_sleepReminders);
      
      // For now, we'll just show a mock notification for the other types
      // In a real app, you would set up different notification channels for each
      if (_isLoading == false) { // Only show if not still loading from previous action
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification settings saved')),
        );
      }
    } catch (e) {
      debugPrint('Error saving notification settings: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e')),
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
  
  Future<void> _tryRescheduleMeditationReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedHour = prefs.getInt('reminder_hour');
      final savedMinute = prefs.getInt('reminder_minute');
      final savedAmPm = prefs.getString('reminder_ampm');
      final savedDays = prefs.getStringList('reminder_days');
      
      if (savedHour != null && savedMinute != null && savedAmPm != null && savedDays != null) {
        final settings = ReminderSettings(
          hour: savedHour,
          minute: savedMinute,
          amPm: savedAmPm,
          days: savedDays,
        );
        
        final notificationService = ref.read(notificationServiceProvider);
        await notificationService.scheduleMeditationReminder(settings);
      }
    } catch (e) {
      debugPrint('Error rescheduling meditation reminders: $e');
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                    _buildReminderManagementSection(),
                    const SizedBox(height: 30),
                    _buildSleepReminderManagementSection(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }
  
  Widget _buildReminderManagementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reminder Management',
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3F414E),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          'Manage your current reminder schedule',
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReminderScreen()),
                  ).then((_) {
                    // Reload settings when returning from reminder screen
                    _loadSettings();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E97FD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  'Edit Reminder Schedule',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        FutureBuilder<List<String>?>(
          future: _getCurrentReminderText(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  width: 20, 
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            
            if (snapshot.hasData && snapshot.data != null) {
              final reminderData = snapshot.data!;
              return Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Schedule',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeue',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3F414E),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Time: ${reminderData[0]}',
                      style: const TextStyle(
                        fontFamily: 'HelveticaNeue',
                        fontSize: 14,
                        color: Color(0xFFA1A4B2),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Days: ${reminderData[1]}',
                      style: const TextStyle(
                        fontFamily: 'HelveticaNeue',
                        fontSize: 14,
                        color: Color(0xFFA1A4B2),
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'No reminders currently scheduled. Tap "Edit Reminder Schedule" to set up reminders.',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 14,
                  color: Color(0xFFA1A4B2),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
  
  Future<List<String>?> _getCurrentReminderText() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedHour = prefs.getInt('reminder_hour');
      final savedMinute = prefs.getInt('reminder_minute');
      final savedAmPm = prefs.getString('reminder_ampm');
      final savedDays = prefs.getStringList('reminder_days');
      
      if (savedHour != null && savedMinute != null && savedAmPm != null && savedDays != null) {
        final settings = ReminderSettings(
          hour: savedHour,
          minute: savedMinute,
          amPm: savedAmPm,
          days: savedDays,
        );
        
        return [settings.formattedTime, settings.formattedDays];
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting current reminder text: $e');
      return null;
    }
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

  Widget _buildSleepReminderManagementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sleep Reminder Management',
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3F414E),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          'Manage your sleep reminder schedule',
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _sleepReminders ? () {
                  _showSleepReminderSettingsDialog();
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF03174C),
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                icon: const Icon(Icons.nightlight_round, color: Colors.white),
                label: const Text(
                  'Edit Sleep Schedule',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        FutureBuilder<SleepReminderSettings?>(
          future: _getSleepReminderSettings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  width: 20, 
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            
            if (snapshot.hasData && snapshot.data != null && _sleepReminders) {
              final settings = snapshot.data!;
              return Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Sleep Schedule',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeue',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3F414E),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Time: ${settings.formattedTime}',
                      style: const TextStyle(
                        fontFamily: 'HelveticaNeue',
                        fontSize: 14,
                        color: Color(0xFFA1A4B2),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Days: ${settings.formattedDays}',
                      style: const TextStyle(
                        fontFamily: 'HelveticaNeue',
                        fontSize: 14,
                        color: Color(0xFFA1A4B2),
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _sleepReminders
                    ? 'No sleep reminders currently scheduled. Tap "Edit Sleep Schedule" to set up reminders.'
                    : 'Sleep reminders are disabled. Enable them to set up a schedule.',
                style: const TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 14,
                  color: Color(0xFFA1A4B2),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
  
  Future<SleepReminderSettings?> _getSleepReminderSettings() async {
    final sleepReminderService = ref.read(sleepReminderServiceProvider);
    return sleepReminderService.getSleepReminderSettings();
  }
  
  void _showSleepReminderSettingsDialog() async {
    // Get current settings or defaults
    final sleepReminderService = ref.read(sleepReminderServiceProvider);
    final settings = await sleepReminderService.getSleepReminderSettings();
    
    // Default values
    int hour = settings?.hour ?? 10;
    int minute = settings?.minute ?? 30;
    String amPm = settings?.amPm ?? 'PM';
    Set<String> days = settings?.days.toSet() ?? {"SU", "M", "T", "W", "TH", "F", "S"};
    
    // Show time picker
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: amPm == 'PM' && hour != 12 ? hour + 12 : (amPm == 'AM' && hour == 12 ? 0 : hour),
        minute: minute,
      ),
    );
    
    if (selectedTime != null) {
      // Convert back to 12-hour format
      if (selectedTime.hour > 12) {
        hour = selectedTime.hour - 12;
        amPm = 'PM';
      } else if (selectedTime.hour == 12) {
        hour = 12;
        amPm = 'PM';
      } else if (selectedTime.hour == 0) {
        hour = 12;
        amPm = 'AM';
      } else {
        hour = selectedTime.hour;
        amPm = 'AM';
      }
      minute = selectedTime.minute;
      
      // Now show days selection dialog
      await _showDaySelectionDialog(
        days,
        (selectedDays) async {
          if (selectedDays.isNotEmpty) {
            // Save the new settings
            final newSettings = SleepReminderSettings(
              hour: hour,
              minute: minute,
              amPm: amPm,
              days: selectedDays.toList(),
            );
            
            setState(() {
              _isLoading = true;
            });
            
            try {
              await sleepReminderService.saveSleepReminderSettings(newSettings);
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error saving sleep reminder: $e')),
                );
              }
            } finally {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
                // Force refresh the widget
                setState(() {});
              }
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select at least one day')),
              );
            }
          }
        },
      );
    }
  }
  
  Future<void> _showDaySelectionDialog(
    Set<String> initialSelection,
    Function(Set<String>) onConfirm,
  ) async {
    final weekdays = ["SU", "M", "T", "W", "TH", "F", "S"];
    final weekdayLabels = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    
    Set<String> selectedDays = Set.from(initialSelection);
    
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Days'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: weekdays.length,
                  itemBuilder: (context, index) {
                    final day = weekdays[index];
                    final isSelected = selectedDays.contains(day);
                    
                    return CheckboxListTile(
                      title: Text(weekdayLabels[index]),
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedDays.add(day);
                          } else {
                            selectedDays.remove(day);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm(selectedDays);
                  },
                  child: const Text('CONFIRM'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
