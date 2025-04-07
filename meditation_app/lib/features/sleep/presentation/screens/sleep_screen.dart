import 'package:flutter/material.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/features/home/presentation/screens/home_screen.dart';
import 'package:meditation_app/features/sleep/presentation/screens/sleep_player_screen.dart';
import 'package:meditation_app/features/music/presentation/screens/music_screen.dart';
import 'package:meditation_app/features/meditation/presentation/screens/meditate_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<String> _categories = ['All', 'My Sleep', 'Anxiety', 'Stress', 'Deep Sleep'];
  
  final List<SleepItem> _sleepItems = [
    SleepItem(
      title: 'Night Island',
      subtitle: '45 MIN · SLEEP MUSIC',
      description: 'Ease the mind into a restful night\'s sleep with these deep, ambient tones.',
      duration: const Duration(minutes: 45),
      color: const Color(0xFF03174C),
      image: null,
      favorites: '24,234',
      listeners: '34,234',
    ),
    SleepItem(
      title: 'Sweet Sleep',
      subtitle: '32 MIN · SLEEP MUSIC',
      description: 'Ease the mind into a restful night\'s sleep with gentle piano melodies.',
      duration: const Duration(minutes: 32),
      color: const Color(0xFF03174C),
      image: null,
      favorites: '12,345',
      listeners: '27,891',
    ),
    SleepItem(
      title: 'Moon Clouds',
      subtitle: '30 MIN · AMBIENT SOUND',
      description: 'Fall asleep to the soothing sounds of the night\'s sky and gentle clouds.',
      duration: const Duration(minutes: 30),
      color: const Color(0xFF03174C),
      image: null,
      favorites: '8,789',
      listeners: '15,456',
    ),
    SleepItem(
      title: 'Good Night',
      subtitle: '45 MIN · STORY TELLING',
      description: 'Drift off to sleep with calming bedtime stories and relaxing sounds.',
      duration: const Duration(minutes: 45),
      color: const Color(0xFF03174C),
      image: null,
      favorites: '16,435',
      listeners: '25,987',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03174C), // Dark blue background from Figma
      body: Stack(
        children: [
          // Background stars
          Positioned(
            top: 120,
            right: 40,
            child: Opacity(
              opacity: 0.4,
              child: SvgPicture.asset(
                'assets/images/sleep/vector_star_1.svg',
                width: 60,
                height: 60,
              ),
            ),
          ),
          Positioned(
            top: 240,
            left: 30,
            child: Opacity(
              opacity: 0.3,
              child: SvgPicture.asset(
                'assets/images/sleep/vector_star_2.svg',
                width: 40,
                height: 40,
              ),
            ),
          ),
          Positioned(
            bottom: 300,
            right: 50,
            child: Opacity(
              opacity: 0.5,
              child: SvgPicture.asset(
                'assets/images/sleep/vector_star_3.svg',
                width: 30,
                height: 30,
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildTabBar(),
                const SizedBox(height: 30),
                Expanded(
                  child: _buildSleepList(),
                ),
              ],
            ),
          ),
        ],
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
              'Sleep Stories',
              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white, // Updated to white for dark background
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Soothing bedtime stories to help you fall into a deep and natural sleep',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Color(0xFF98A1BD), // Color from Figma
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF03174C), // Updated background color
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color(0xFF8E97FD), // Purple color from Figma
        ),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF98A1BD), // Color from Figma
        labelStyle: const TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        tabs: _categories.map((category) => Tab(text: category)).toList(),
      ),
    );
  }

  Widget _buildSleepList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: _sleepItems.length,
      itemBuilder: (context, index) {
        final item = _sleepItems[index];
        return _buildSleepCard(item);
      },
    );
  }

  Widget _buildSleepCard(SleepItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SleepPlayerScreen(
              title: item.title,
              subtitle: item.subtitle,
              duration: item.duration,
              backgroundColor: item.color,
              backgroundImage: null,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF4C53B4), // From Figma design
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sleep illustration/image with stars
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFF4C53B4),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                image: item.image != null 
                    ? DecorationImage(
                        image: AssetImage(item.image!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              // Starry night illustration
              child: Stack(
                children: [
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/sleep/moon_vector.svg',
                      width: 70,
                      height: 70,
                      colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.8),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 30,
                    child: Opacity(
                      opacity: 0.8,
                      child: SvgPicture.asset(
                        'assets/images/sleep/vector_star_1.svg',
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    left: 40,
                    child: Opacity(
                      opacity: 0.6,
                      child: SvgPicture.asset(
                        'assets/images/sleep/vector_star_2.svg',
                        width: 18,
                        height: 18,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    right: 70,
                    child: Opacity(
                      opacity: 0.7,
                      child: SvgPicture.asset(
                        'assets/images/sleep/vector_star_3.svg',
                        width: 15,
                        height: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF98A1BD),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${item.favorites} Favorites',
                            style: const TextStyle(
                              fontFamily: 'HelveticaNeue',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          const Icon(
                            Icons.headphones,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${item.listeners} Listening',
                            style: const TextStyle(
                              fontFamily: 'HelveticaNeue',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF98A1BD).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Text(
                              item.subtitle.split('·')[0].trim(),
                              style: const TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF98A1BD),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF98A1BD).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          item.subtitle.split('·')[1].trim(),
                          style: const TextStyle(
                            fontFamily: 'HelveticaNeue',
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF98A1BD),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: 90,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8E97FD),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
                      child: Text(
                        'PLAY',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
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

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF03174C),
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
          _buildNavItem(Icons.bedtime, 'Sleep', true, onTap: () {}),
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
          _buildNavItem(Icons.person_outline, 'Profile', false, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, {required VoidCallback onTap}) {
    Color color = isSelected ? const Color(0xFF8E97FD) : const Color(0xFF98A1BD);
    
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

class SleepItem {
  final String title;
  final String subtitle;
  final String description;
  final Duration duration;
  final Color color;
  final String? image;
  final String favorites;
  final String listeners;

  SleepItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.duration,
    required this.color,
    required this.image,
    required this.favorites,
    required this.listeners,
  });
} 