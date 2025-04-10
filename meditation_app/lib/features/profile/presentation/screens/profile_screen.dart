import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation_app/features/auth/presentation/screens/signup_signin_screen.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/features/profile/domain/models/user_profile.dart';
import 'package:meditation_app/shared/providers/shared_providers.dart';
import 'package:meditation_app/features/home/presentation/screens/home_screen.dart';
import 'package:meditation_app/features/meditation/presentation/screens/meditate_screen.dart';
import 'package:meditation_app/features/music/presentation/screens/music_screen.dart';
import 'package:meditation_app/features/sleep/presentation/screens/sleep_screen.dart';
import 'package:meditation_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:meditation_app/features/profile/presentation/screens/notifications_screen.dart';
import 'package:meditation_app/features/profile/presentation/screens/privacy_screen.dart';
import 'package:meditation_app/features/profile/presentation/screens/help_support_screen.dart';
import 'package:meditation_app/features/profile/presentation/screens/about_screen.dart';
import 'package:meditation_app/features/premium/presentation/screens/premium_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(profileProvider);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: userProfile == null
          ? _buildLoadingView()
          : SingleChildScrollView(
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
            ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Loading profile...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () {
                // Force refresh of the profile provider
                ref.refresh(profileProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
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
              color: Color.fromRGBO(142, 151, 253, 0.2),
              border: Border.all(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: profile.avatarUrl != null
                  ? Image.network(
                      profile.avatarUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset(
                        'assets/images/logo.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Image.asset(
                      'assets/images/logo.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
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
        color: Color.fromRGBO(255, 207, 134, 0.3),
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
                  color: Color.fromRGBO(255, 255, 255, 0.2),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PremiumScreen()),
              );
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            },
          ),
          _buildSettingsItem(
            icon: Icons.lock_outline,
            title: 'Privacy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyScreen()),
              );
            },
          ),
          _buildSettingsItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
              );
            },
          ),
          _buildSettingsItem(
            icon: Icons.info_outline,
            title: 'About',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          _buildSettingsItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
                  ),
                  (route) => false,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: ${e.toString()}')),
                );
              }
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
            color: Color.fromRGBO(0, 0, 0, 0.05),
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
