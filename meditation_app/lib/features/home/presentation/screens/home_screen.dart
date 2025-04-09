import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/features/meditation/presentation/screens/meditate_screen.dart';
import 'package:meditation_app/features/music/presentation/screens/music_screen.dart';
import 'package:meditation_app/features/sleep/presentation/screens/sleep_screen.dart';
import 'package:meditation_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:meditation_app/features/meditation/presentation/screens/meditation_detail_screen.dart';
import 'package:meditation_app/features/meditation/domain/repositories/meditation_repository.dart';
import 'package:meditation_app/features/meditation/domain/models/meditation.dart';
import 'package:meditation_app/shared/services/analytics_service.dart';
import 'package:meditation_app/shared/providers/shared_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final MeditationRepository _repository = MeditationRepository();
  final AnalyticsService _analytics = AnalyticsService();
  List<Meditation> _featuredMeditations = [];
  List<Meditation> _recentMeditations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _analytics.logScreenView('home_screen');
    _loadMeditations();
  }

  Future<void> _loadMeditations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final allMeditations = _repository.getAllMeditations();
      
      // In a real app, these would be fetched from the backend with proper filtering
      setState(() {
        _featuredMeditations = allMeditations.where((m) => m.isPremium).take(5).toList();
        _recentMeditations = allMeditations.take(3).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading meditations: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildWelcomeCard(),
                    _buildSectionTitle('Featured Meditations'),
                    _buildFeaturedMeditations(),
                    _buildSectionTitle('Recent Sessions'),
                    _buildRecentSessions(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    final userProfile = ref.watch(profileProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userProfile?.name != null && userProfile!.name!.isNotEmpty
                      ? 'Good Morning, ${userProfile.name!.split(" ")[0]}'
                      : 'Good Morning',
                  style: const TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3F414E),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 5),
                Text(
                  'We wish you have a good day',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: userProfile?.avatarUrl != null
                    ? Image.network(
                        userProfile!.avatarUrl!,
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/images/logo.png',
                          width: 55,
                          height: 55,
                          fit: BoxFit.contain,
                        ),
                      )
                    : Image.asset(
                        'assets/images/logo.png',
                        width: 55,
                        height: 55,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Meditation',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Take a moment to pause and breathe',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to the first meditation in the list
                  if (_featuredMeditations.isNotEmpty) {
                    final meditation = _featuredMeditations.first;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MeditationDetailScreen(
                          title: meditation.title,
                          description: meditation.description,
                          duration: '${meditation.duration.inMinutes} MIN',
                          meditationId: meditation.id,
                        ),
                      ),
                    );
                    
                    _analytics.logEvent('daily_meditation_selected', parameters: {
                      'meditation_id': meditation.id,
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text(
                  'START',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MeditateScreen()),
                  );
                  
                  _analytics.logEvent('browse_meditations_clicked', parameters: null);
                },
                icon: const Icon(Icons.library_books, color: Colors.white),
                label: const Text(
                  'Browse All',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFF3F414E),
        ),
      ),
    );
  }

  Widget _buildFeaturedMeditations() {
    if (_featuredMeditations.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            'No featured meditations available',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: _featuredMeditations.length,
        itemBuilder: (context, index) {
          final meditation = _featuredMeditations[index];
          return _buildFeaturedMeditationCard(meditation);
        },
      ),
    );
  }

  Widget _buildFeaturedMeditationCard(Meditation meditation) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeditationDetailScreen(
              title: meditation.title,
              description: meditation.description,
              duration: '${meditation.duration.inMinutes} MIN',
              meditationId: meditation.id,
            ),
          ),
        );
        
        _analytics.logEvent('featured_meditation_selected', parameters: {
          'meditation_id': meditation.id,
          'meditation_title': meditation.title,
        });
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF67548B),
              const Color(0xFFD3C265),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Gradient overlay for text readability
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (meditation.isPremium)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Text(
                    meditation.title,
                    style: const TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${meditation.duration.inMinutes} MIN',
                        style: const TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      if (meditation.isDownloaded) ...[  
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.download_done,
                          size: 14,
                          color: Colors.green,
                        ),
                      ],
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

  Widget _buildRecentSessions() {
    if (_recentMeditations.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            'No recent sessions',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _recentMeditations.length,
      itemBuilder: (context, index) {
        final meditation = _recentMeditations[index];
        return _buildRecentSessionItem(meditation);
      },
    );
  }

  Widget _buildRecentSessionItem(Meditation meditation) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeditationDetailScreen(
              title: meditation.title,
              description: meditation.description,
              duration: '${meditation.duration.inMinutes} MIN',
              meditationId: meditation.id,
            ),
          ),
        );
        
        _analytics.logEvent('recent_session_selected', parameters: {
          'meditation_id': meditation.id,
          'meditation_title': meditation.title,
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.7),
                    AppColors.primary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meditation.title,
                    style: const TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3F414E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${meditation.duration.inMinutes} MIN • ${meditation.category}',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            if (meditation.isDownloaded)
              const Icon(
                Icons.download_done,
                color: Colors.green,
                size: 20,
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
    Color color = isSelected ? AppColors.primary : const Color(0xFFA0A3B1);
    
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 70, // Fixed width for each navigation item
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
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}