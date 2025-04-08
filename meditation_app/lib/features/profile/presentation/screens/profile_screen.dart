import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/features/profile/domain/models/user_profile.dart';
import 'package:meditation_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:meditation_app/features/home/presentation/screens/home_screen.dart';
import 'package:meditation_app/features/meditation/presentation/screens/meditate_screen.dart';
import 'package:meditation_app/features/music/presentation/screens/music_screen.dart';
import 'package:meditation_app/features/sleep/presentation/screens/sleep_screen.dart';
import 'package:meditation_app/features/profile/presentation/screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Consumer<ProfileProvider>(
            builder: (context, profileProvider, _) {
              final UserProfile userProfile = profileProvider.userProfile;
              
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildProfileCard(userProfile),
                    _buildStatisticsSection(userProfile),
                    _buildMembershipSection(userProfile),
                    _buildSettingsSection(),
                  ],
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Text(
        'Profile',
        style: TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Color(0xFF3F414E),
        ),
      ),
    );
  }

  Widget _buildProfileCard(UserProfile profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.2),
              border: Border.all(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                size: 40,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name ?? 'No name',
                  style: const TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3F414E),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  profile.email ?? 'No email',
                  style: const TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 14,
                    color: Color(0xFFA1A4B2),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(UserProfile profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistics',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3F414E),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.access_time,
                  title: '${profile.totalMeditationTime.inMinutes}',
                  subtitle: 'Minutes',
                  color: const Color(0xFFFFCF86),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.favorite,
                  title: '${profile.totalSessions}',
                  subtitle: 'Sessions',
                  color: const Color(0xFFB5C8FF),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.local_fire_department,
                  title: '${profile.lastMeditationDate != null ? (DateTime.now().difference(profile.lastMeditationDate!).inDays == 0 ? 1 : 0) : 0}',
                  subtitle: 'Day Streak',
                  color: const Color(0xFFAFDBC5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3F414E),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 12,
              color: Color(0xFFA1A4B2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipSection(UserProfile profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8E97FD), Color(0xFF6B75CA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Membership',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'PRO',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Unlock all features and content',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement membership upgrade
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color(0xFF8E97FD),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'Upgrade Now',
              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF8E97FD),
              ),
            ),
          ),
        ],
      ),
    );
  }

    Widget _buildSettingsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3F414E),
            ),
          ),
          const SizedBox(height: 15),
          _buildSettingsItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {
              // TODO: Implement notifications settings
            },
          ),
          _buildSettingsItem(
            icon: Icons.lock_outline,
            title: 'Privacy',
            onTap: () {
              // TODO: Implement privacy settings
            },
          ),
          _buildSettingsItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              // TODO: Implement help & support
            },
          ),
          _buildSettingsItem(
            icon: Icons.info_outline,
            title: 'About',
            onTap: () {
              // TODO: Implement about
            },
          ),
          _buildSettingsItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              // TODO: Implement logout
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFF2F2F7),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF3F414E),
              size: 24,
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 16,
                color: Color(0xFF3F414E),
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFA1A4B2),
              size: 24,
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }),
          _buildNavItem(Icons.bedtime, 'Sleep', false, onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SleepScreen()),
            );
          }),
          _buildNavItem(Icons.favorite_border, 'Meditate', false, onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MeditateScreen()),
            );
          }),
          _buildNavItem(Icons.music_note, 'Music', false, onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MusicScreen()),
            );
          }),
          _buildNavItem(Icons.person_outline, 'Profile', true, onTap: () {}),
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
