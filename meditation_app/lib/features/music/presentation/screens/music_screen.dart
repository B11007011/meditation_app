import 'package:flutter/material.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/features/home/presentation/screens/home_screen.dart';
import 'package:meditation_app/features/music/presentation/screens/music_player_screen.dart';
import 'package:meditation_app/features/sleep/presentation/screens/sleep_screen.dart';
import 'package:meditation_app/features/meditation/presentation/screens/meditate_screen.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<String> _categories = ['All', 'Favorite', 'Sleep', 'Insomnia', 'Anxiety'];
  
  final List<MusicItem> _musicItems = [
    MusicItem(
      title: 'Focus Attention',
      subtitle: '7 DAYS OF CALM',
      duration: const Duration(minutes: 45),
      color: const Color(0xFFDFE9F3),
    ),
    MusicItem(
      title: 'Mindful Meditation',
      subtitle: 'STRESS RELIEF',
      duration: const Duration(minutes: 32, seconds: 10),
      color: const Color(0xFFF8DFD6),
    ),
    MusicItem(
      title: 'Ocean Waves',
      subtitle: 'AMBIENT SOUND',
      duration: const Duration(minutes: 60),
      color: const Color(0xFFD1ECD1),
    ),
    MusicItem(
      title: 'Delta Waves',
      subtitle: 'SLEEP SOUND',
      duration: const Duration(minutes: 240),
      color: const Color(0xFFE5D9F2),
    ),
    MusicItem(
      title: 'Morning Energy',
      subtitle: 'DAILY BOOST',
      duration: const Duration(minutes: 15, seconds: 30),
      color: const Color(0xFFFFF2C5),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildTabBar(),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildFeaturedMusic(),
                    const SizedBox(height: 40),
                    _buildRecentMusic(),
                    const SizedBox(height: 20),
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
              'Music',
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
              'Calming sounds and music to help you relax, sleep better and minimize daily stress.',
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

  Widget _buildTabBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F9),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColors.primary,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFFA0A3B1),
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

  Widget _buildFeaturedMusic() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Featured',
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3F414E),
          ),
        ),
        const SizedBox(height: 20),
        _buildMusicCard(
          title: 'Nature Symphony',
          subtitle: 'STRESS RELIEF',
          duration: const Duration(minutes: 50),
          color: const Color(0xFFD7F2E4),
          isHighlighted: true,
        ),
      ],
    );
  }

  Widget _buildRecentMusic() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent',
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3F414E),
          ),
        ),
        const SizedBox(height: 20),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _musicItems.length,
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
            final item = _musicItems[index];
            return _buildMusicListItem(
              title: item.title,
              subtitle: item.subtitle,
              duration: item.duration,
              color: item.color,
            );
          },
        ),
      ],
    );
  }

  Widget _buildMusicCard({
    required String title,
    required String subtitle,
    required Duration duration,
    required Color color,
    bool isHighlighted = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MusicPlayerScreen(
              title: title,
              subtitle: subtitle,
              totalDuration: duration,
            ),
          ),
        );
      },
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3F414E),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 12,
                          letterSpacing: 0.7,
                          color: Color(0xFF5A6175),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3F414E).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _formatDuration(duration),
                          style: const TextStyle(
                            fontFamily: 'HelveticaNeue',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.music_note,
                size: 50,
                color: const Color(0xFF3F414E).withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicListItem({
    required String title,
    required String subtitle,
    required Duration duration,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MusicPlayerScreen(
              title: title,
              subtitle: subtitle,
              totalDuration: duration,
            ),
          ),
        );
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: color.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF3F414E).withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
                      fontSize: 12,
                      letterSpacing: 0.7,
                      color: Color(0xFF5A6175),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              _formatDuration(duration),
              style: const TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 14,
                color: Color(0xFF5A6175),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return '${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds';
    }
    
    return '$twoDigitMinutes:$twoDigitSeconds';
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
          _buildNavItem(Icons.favorite_border, 'Meditate', false, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MeditateScreen()),
            );
          }),
          _buildNavItem(Icons.music_note, 'Music', true, onTap: () {}),
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

class MusicItem {
  final String title;
  final String subtitle;
  final Duration duration;
  final Color color;

  MusicItem({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.color,
  });
} 