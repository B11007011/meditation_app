import 'package:flutter/material.dart';
import 'package:meditation_app/features/home/presentation/screens/home_screen.dart';
import 'package:meditation_app/features/sleep/presentation/screens/sleep_player_screen.dart';
import 'package:meditation_app/features/music/presentation/screens/music_screen.dart';
import 'package:meditation_app/features/meditation/presentation/screens/meditate_screen.dart';
import 'package:meditation_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  static const List<SleepMusicItem> _sleepMusicItems = [
    const SleepMusicItem(
      title: 'Night Island',
      duration: '45 MIN',
      type: 'SLEEP MUSIC',
    ),
    const SleepMusicItem(
      title: 'Sweet Sleep',
      duration: '45 MIN',
      type: 'SLEEP MUSIC',
    ),
    const SleepMusicItem(
      title: 'Good Night',
      duration: '45 MIN',
      type: 'SLEEP MUSIC',
    ),
    const SleepMusicItem(
      title: 'Moon Clouds',
      duration: '45 MIN',
      type: 'SLEEP MUSIC',
    ),
    const SleepMusicItem(
      title: 'Night Island',
      duration: '45 MIN',
      type: 'SLEEP MUSIC',
    ),
    const SleepMusicItem(
      title: 'Sweet Sleep',
      duration: '45 MIN',
      type: 'SLEEP MUSIC',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03174C),
      body: Column(
        children: [
          _buildHeader(),
          Container(
            height: 1,
            color: const Color(0xFFE6E6E6).withOpacity(0.1),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          Expanded(
            child: _buildMusicGrid(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SvgPicture.asset(
                'assets/images/sleep/back_button.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFE6E7F2),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'Sleep Music',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE6E7F2),
            ),
          ),
          const Spacer(),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildMusicGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.85,
      ),
      itemCount: _sleepMusicItems.length,
      itemBuilder: (context, index) {
        return _buildMusicItem(_sleepMusicItems[index]);
      },
    );
  }

  Widget _buildMusicItem(SleepMusicItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SleepPlayerScreen(
              title: item.title,
              subtitle: '${item.duration} · ${item.type}',
              duration: const Duration(minutes: 45),
              backgroundColor: const Color(0xFF03174C),
              backgroundImage: null,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF4C53B4).withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/sleep/moon_vector.svg',
                  width: 60,
                  height: 60,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.8),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.duration,
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF98A1BD),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF98A1BD),
                        ),
                      ),
                      Text(
                        item.type,
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF98A1BD),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE6E7F2),
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
        color: const Color(0xFF03174D),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(0, -5),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            'assets/images/sleep/home_icon.svg', 
            'Home', 
            false, 
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
          ),
          _buildNavItem(
            'assets/images/sleep/meditate_icon.svg', 
            'Meditate', 
            false, 
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MeditateScreen()),
              );
            }
          ),
          _buildNavItem(
            'assets/images/sleep/music_icon.svg', 
            'Music', 
            false, 
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MusicScreen()),
              );
            }
          ),
          _buildNavItem(
            'assets/images/sleep/sleep_icon.svg', 
            'Sleep', 
            true, 
            onTap: () {}
          ),
          _buildNavItem(
            'assets/images/sleep/profile_icon.svg', 
            'Afsar', 
            false, 
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            }
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, bool isSelected, {required VoidCallback onTap}) {
    final Color activeColor = const Color(0xFFE6E7F2);
    final Color inactiveColor = const Color(0xFF98A1BD);
    final Color activeBackgroundColor = const Color(0xFF8E97FD);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isSelected)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: activeBackgroundColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: SvgPicture.asset(
                iconPath,
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                  activeColor,
                  BlendMode.srcIn,
                ),
              ),
            )
          else
            SvgPicture.asset(
              iconPath,
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                inactiveColor,
                BlendMode.srcIn,
              ),
            ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}

class SleepMusicItem {
  final String title;
  final String duration;
  final String type;

  const SleepMusicItem({
    required this.title,
    required this.duration,
    required this.type,
  });
}
