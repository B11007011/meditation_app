import 'package:flutter/material.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/features/meditation/presentation/screens/meditation_detail_screen.dart';
import 'package:meditation_app/features/meditation/presentation/screens/meditate_screen.dart';
import 'package:meditation_app/features/music/presentation/screens/music_screen.dart';
import 'package:meditation_app/features/sleep/presentation/screens/sleep_screen.dart';
import 'package:meditation_app/features/profile/presentation/screens/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({
    super.key,
    this.userName = 'Afsar',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 50),
              // Good Morning section
              _buildGreetingSection(),
              const SizedBox(height: 30),
              // Recommended section
              _buildRecommendedSection(context),
              const SizedBox(height: 40),
              // Daily Thoughts section
              _buildDailyThoughtsSection(context),
              const SizedBox(height: 40),
              // Bottom message
              _buildBottomMessage(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildGreetingSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning, $userName',
              style: const TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3F414E),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'We wish you have a good day',
              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Color(0xFFA1A4B2),
                height: 1.5,
              ),
            ),
          ],
        ),
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
           
          ),
    
        ),
      ],
    );
  }

  Widget _buildRecommendedSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended for you',
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3F414E),
            height: 1.35,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 210,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildRecommendedCard(
                context: context,
                title: 'Focus',
                subtitle: 'MEDITATION • 3-10 MIN',
                color: const Color(0xFF8E97FD),
                textColor: Colors.white,
              ),
              const SizedBox(width: 20),
              _buildRecommendedCard(
                context: context,
                title: 'Happiness',
                subtitle: 'MEDITATION • 3-10 MIN',
                color: const Color(0xFFFFDB9D),
                textColor: const Color(0xFF3F414E),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Color color,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeditationDetailScreen(
              title: title,
              description: 'Ease the mind into a restful state with these $title meditations.',
              duration: '3-10 MIN',
            ),
          ),
        );
      },
      child: Container(
        width: 177,
        height: 210,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: textColor == Colors.white 
                        ? Colors.white.withOpacity(0.3) 
                        : const Color(0xFF3F414E).withOpacity(0.3),
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: textColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  'START',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyThoughtsSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MeditationDetailScreen(
              title: 'Daily Thoughts',
              description: 'Ease the mind with daily thoughts and guided meditations.',
              duration: '3-10 MIN',
            ),
          ),
        );
      },
      child: Container(
        height: 95,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Thoughts',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3F414E),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'MEDITATION • 3-10 MIN',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFA1A4B2),
                  ),
                ),
              ],
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomMessage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'We wish you have a good day',
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3F414E),
            height: 1.35,
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            // Navigate to meditation 101 detail
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MeditationDetailScreen(
                  title: 'Meditation 101',
                  description: 'Learn the basics of meditation with this introductory course for beginners.',
                  duration: '5-10 MIN',
                ),
              ),
            );
          },
          child: Container(
            height: 95,
            decoration: BoxDecoration(
              color: const Color(0xFFA0A3B1).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const SizedBox(width: 20),
                const Expanded(
                  child: Text(
                    'Meditation 101',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3F414E),
                    ),
                  ),
                ),
                Container(
                  width: 70,
                  height: 95,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8E97FD),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'START',
                      style: TextStyle(
                        fontFamily: 'HelveticaNeue',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', true, onTap: () {}),
          _buildNavItem(Icons.bedtime, 'Sleep', false, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SleepScreen()),
            );
          }),
          _buildNavItem(Icons.favorite_border, 'Meditate', false, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MeditateScreen()),
            );
          }),
          _buildNavItem(Icons.music_note, 'Music', false, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MusicScreen()),
            );
          }),
          _buildNavItem(Icons.person_outline, 'Profile', false, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : const Color(0xFFA0A3B1),
            size: 24,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected ? AppColors.primary : const Color(0xFFA0A3B1),
            ),
          ),
        ],
      ),
    );
  }
} 