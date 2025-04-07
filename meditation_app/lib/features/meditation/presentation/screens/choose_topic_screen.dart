import 'package:flutter/material.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/features/meditation/presentation/screens/reminder_screen.dart';
import 'package:meditation_app/features/meditation/domain/models/reminder_settings.dart';
import 'package:meditation_app/features/home/presentation/screens/home_screen.dart';

class ChooseTopicScreen extends StatefulWidget {
  const ChooseTopicScreen({super.key});

  @override
  State<ChooseTopicScreen> createState() => _ChooseTopicScreenState();
}

class _ChooseTopicScreenState extends State<ChooseTopicScreen> {
  final List<TopicItem> topics = [
    TopicItem(
      title: 'Reduce Stress',
      backgroundColor: const Color(0xFFAFDBC5),
      icon: Icons.spa,
    ),
    TopicItem(
      title: 'Improve Performance',
      backgroundColor: const Color(0xFFFFF2DF),
      icon: Icons.trending_up,
    ),
    TopicItem(
      title: 'Reduce Anxiety',
      backgroundColor: const Color(0xFFB5C8FF),
      icon: Icons.healing,
    ),
    TopicItem(
      title: 'Personal Growth',
      backgroundColor: const Color(0xFFFFCF86),
      icon: Icons.emoji_nature,
    ),
    TopicItem(
      title: 'Better Sleep',
      backgroundColor: const Color(0xFFFFB5C8),
      icon: Icons.nightlight_round,
    ),
    TopicItem(
      title: 'Increase Happiness',
      backgroundColor: const Color(0xFFCCAFF4),
      icon: Icons.sentiment_very_satisfied,
    ),
  ];

  // Keep track of selected topics
  final Set<int> selectedTopics = {};
  
  // Store reminder settings
  ReminderSettings? reminderSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'What Brings you\nto Silent Moon?',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3F414E),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'choose a topic to focus on:',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFFA1A4B2),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    return TopicCard(
                      topicItem: topics[index],
                      isSelected: selectedTopics.contains(index),
                      onTap: () {
                        setState(() {
                          if (selectedTopics.contains(index)) {
                            selectedTopics.remove(index);
                          } else {
                            selectedTopics.add(index);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              if (reminderSettings != null)
                _buildReminderSummary(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 63,
                child: ElevatedButton(
                  onPressed: selectedTopics.isNotEmpty 
                      ? () async {
                          if (reminderSettings != null) {
                            // If we already have reminder settings, navigate to home screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                  userName: 'Afsar', // You can replace this with actual user name
                                ),
                              ),
                            );
                          } else {
                            // Navigate to the Reminder screen
                            final result = await Navigator.push<ReminderSettings>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ReminderScreen(),
                              ),
                            );
                            
                            if (result != null) {
                              setState(() {
                                reminderSettings = result;
                              });
                              
                              // Show confirmation
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Reminder set for ${result.formattedTime} on ${result.formattedDays}',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(38),
                    ),
                  ),
                  child: Text(
                    reminderSettings != null ? 'CONTINUE' : 'GET STARTED',
                    style: const TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      letterSpacing: 0.7,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildReminderSummary() {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meditation Reminder',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Time: ${reminderSettings!.formattedTime}',
            style: const TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 14,
              color: Color(0xFFA1A4B2),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Days: ${reminderSettings!.formattedDays}',
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
}

class TopicItem {
  final String title;
  final Color backgroundColor;
  final IconData icon;

  TopicItem({
    required this.title,
    required this.backgroundColor,
    required this.icon,
  });
}

class TopicCard extends StatelessWidget {
  final TopicItem topicItem;
  final bool isSelected;
  final VoidCallback onTap;

  const TopicCard({
    super.key,
    required this.topicItem,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: topicItem.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Icon(
                  topicItem.icon,
                  size: 60,
                  color: const Color(0xFF3F414E),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  topicItem.title,
                  style: const TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3F414E),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 