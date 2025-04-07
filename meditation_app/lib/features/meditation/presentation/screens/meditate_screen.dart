import 'package:flutter/material.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/features/meditation/presentation/screens/meditation_detail_screen.dart';
import 'package:meditation_app/features/home/presentation/screens/home_screen.dart';
import 'package:meditation_app/features/music/presentation/screens/music_screen.dart';
import 'package:meditation_app/features/sleep/presentation/screens/sleep_screen.dart';

class MeditateScreen extends StatefulWidget {
  const MeditateScreen({super.key});

  @override
  State<MeditateScreen> createState() => _MeditateScreenState();
}

class _MeditateScreenState extends State<MeditateScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'My', 'Sleep', 'Anxious', 'Kids'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildFilterTabs(),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildDailyCalm(),
                    const SizedBox(height: 20),
                    _buildMeditationRow(),
                    const SizedBox(height: 20),
                    _buildMeditationRow(
                      title1: 'Anxiet Release',
                      description1: 'Ease anxiety with guided meditation',
                      gradient1: const LinearGradient(
                        colors: [Color(0xFFFF7C6B), Color(0xFFFAC978)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      title2: '7 Days of Calm',
                      description2: 'Start your meditation journey',
                      gradient2: const LinearGradient(
                        colors: [Color(0xFF67548B), Color(0xFFEDC59F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          const Center(
            child: Text(
              'Meditate',
              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3F414E),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'we can learn how to recognize when our minds are doing their normal everyday acrobatics.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Color(0xFFA0A3B1),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? Colors.transparent : const Color(0xFFA0A3B1),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 16,
                    color: isSelected ? Colors.white : const Color(0xFFA0A3B1),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailyCalm() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MeditationDetailScreen(
              title: 'Daily Calm',
              description: 'Pause practice for mindfulness and peace',
              duration: '10 MIN',
            ),
          ),
        );
      },
      child: Container(
        height: 95,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF1DDCF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.transparent, Color(0xFFFFE4D0)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Daily Calm',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3F414E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            'APR 30',
                            style: TextStyle(
                              fontFamily: 'HelveticaNeue',
                              fontSize: 11,
                              color: Color(0xFF5A6175),
                              letterSpacing: 0.55,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF5A6175),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'PAUSE PRACTICE',
                            style: TextStyle(
                              fontFamily: 'HelveticaNeue',
                              fontSize: 11,
                              color: Color(0xFF5A6175),
                              letterSpacing: 0.55,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF3F414E),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeditationRow({
    String title1 = 'How to Meditate',
    String description1 = 'Learn the basics of meditation',
    LinearGradient gradient1 = const LinearGradient(
      colors: [Color(0xFFA0A3B1), Color(0xFFFFDEA7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    String title2 = 'Focus Attention',
    String description2 = 'Learn to focus your attention',
    LinearGradient gradient2 = const LinearGradient(
      colors: [Color(0xFF67548B), Color(0xFFD3C265)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildMeditationCard(
            title: title1,
            description: description1,
            gradient: gradient1,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildMeditationCard(
            title: title2,
            description: description2,
            gradient: gradient2,
          ),
        ),
      ],
    );
  }

  Widget _buildMeditationCard({
    required String title,
    required String description,
    required LinearGradient gradient,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeditationDetailScreen(
              title: title,
              description: description,
              duration: '5-10 MIN',
            ),
          ),
        );
      },
      child: Container(
        height: 210,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.2),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
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
          _buildNavItem(Icons.home, 'Home', false, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }),
          _buildNavItem(Icons.bedtime, 'Sleep', false, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SleepScreen()),
            );
          }),
          _buildNavItem(Icons.favorite_border, 'Meditate', true, onTap: () {}),
          _buildNavItem(Icons.music_note, 'Music', false, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MusicScreen()),
            );
          }),
          _buildNavItem(Icons.person_outline, 'Profile', false, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, {required VoidCallback onTap}) {
    Color color = isSelected ? AppColors.primary : const Color(0xFFA0A3B1);
    
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
} 