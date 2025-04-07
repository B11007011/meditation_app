import 'package:flutter/material.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/features/home/presentation/screens/home_screen.dart';
import 'package:meditation_app/features/music/presentation/screens/music_player_screen.dart';
import 'package:meditation_app/features/sleep/presentation/screens/sleep_screen.dart';
import 'package:meditation_app/features/meditation/presentation/screens/meditate_screen.dart';
import 'package:meditation_app/features/profile/presentation/screens/profile_screen.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> with SingleTickerProviderStateMixin {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Favorite', 'Sleep', 'Insomnia', 'Anxiety'];
  
  final List<MusicItem> _musicItems = [
    MusicItem(
      title: 'Focus Attention',
      subtitle: '7 DAYS OF CALM',
      duration: const Duration(minutes: 45),
      gradient: const LinearGradient(
        colors: [Color(0xFF67548B), Color(0xFFD3C265)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    MusicItem(
      title: 'Mindful Meditation',
      subtitle: 'STRESS RELIEF',
      duration: const Duration(minutes: 32, seconds: 10),
      gradient: const LinearGradient(
        colors: [Color(0xFFFF7C6B), Color(0xFFFAC978)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    MusicItem(
      title: 'Ocean Waves',
      subtitle: 'AMBIENT SOUND',
      duration: const Duration(minutes: 60),
      gradient: const LinearGradient(
        colors: [Color(0xFF3F414E), Color(0xFF8BADD2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    MusicItem(
      title: 'Delta Waves',
      subtitle: 'SLEEP SOUND',
      duration: const Duration(minutes: 240),
      gradient: const LinearGradient(
        colors: [Color(0xFFA0A3B1), Color(0xFFFFDEA7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    MusicItem(
      title: 'Morning Energy',
      subtitle: 'DAILY BOOST',
      duration: const Duration(minutes: 15, seconds: 30),
      gradient: const LinearGradient(
        colors: [Color(0xFF67548B), Color(0xFFEDC59F)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

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
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MusicPlayerScreen(
                  title: 'Nature Symphony',
                  subtitle: 'STRESS RELIEF',
                  totalDuration: Duration(minutes: 50),
                ),
              ),
            );
          },
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8E97FD), Color(0xFFD7F2E4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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
                          const Text(
                            'Nature Symphony',
                            style: TextStyle(
                              fontFamily: 'HelveticaNeue',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'STRESS RELIEF',
                            style: TextStyle(
                              fontFamily: 'HelveticaNeue',
                              fontSize: 12,
                              letterSpacing: 0.7,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '50:00',
                              style: TextStyle(
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
                  child: const Icon(
                    Icons.music_note,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
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
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.8,
          ),
          itemCount: _musicItems.length,
          itemBuilder: (context, index) {
            final item = _musicItems[index];
            return _buildMusicCard(
              title: item.title,
              subtitle: item.subtitle,
              duration: item.duration,
              gradient: item.gradient,
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
    required LinearGradient gradient,
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
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontSize: 11,
                      letterSpacing: 0.7,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _formatDuration(duration),
                          style: const TextStyle(
                            fontFamily: 'HelveticaNeue',
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
  final LinearGradient gradient;

  MusicItem({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.gradient,
  });
} 