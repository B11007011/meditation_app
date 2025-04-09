import 'package:flutter/material.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/features/meditation/presentation/screens/meditation_detail_screen.dart';
import 'package:meditation_app/features/home/presentation/screens/home_screen.dart';
import 'package:meditation_app/features/music/presentation/screens/music_screen.dart';
import 'package:meditation_app/features/sleep/presentation/screens/sleep_screen.dart';
import 'package:meditation_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:meditation_app/features/meditation/domain/repositories/meditation_repository.dart';
import 'package:meditation_app/features/meditation/domain/models/meditation.dart';
import 'package:meditation_app/shared/services/analytics_service.dart';

class MeditateScreen extends StatefulWidget {
  const MeditateScreen({super.key});

  @override
  State<MeditateScreen> createState() => _MeditateScreenState();
}

class _MeditateScreenState extends State<MeditateScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'My', 'Sleep', 'Anxious', 'Kids', 'Downloaded'];
  final MeditationRepository _repository = MeditationRepository();
  final AnalyticsService _analytics = AnalyticsService();
  List<Meditation> _meditations = [];
  List<Meditation> _filteredMeditations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _analytics.logScreenView('meditate_screen');
    _loadMeditations();
  }

  Future<void> _loadMeditations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final meditations = _repository.getAllMeditations();
      setState(() {
        _meditations = meditations;
        _filterMeditations();
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

  void _filterMeditations() {
    if (_selectedFilter == 'All') {
      _filteredMeditations = _meditations;
    } else if (_selectedFilter == 'Downloaded') {
      _filteredMeditations = _meditations.where((m) => m.isDownloaded).toList();
    } else if (_selectedFilter == 'My') {
      // In a real app, this would filter for user's saved meditations
      _filteredMeditations = _meditations.take(3).toList();
    } else {
      _filteredMeditations = _meditations
          .where((m) => m.category.toLowerCase() == _selectedFilter.toLowerCase())
          .toList();
    }
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
            _buildFilterTabs(),
            const SizedBox(height: 30),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredMeditations.isEmpty
                      ? _buildEmptyState()
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              _buildDailyCalm(),
                              const SizedBox(height: 20),
                              _buildMeditationGrid(),
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
                _filterMeditations();
              });
              
              _analytics.logEvent('meditation_filter_changed', parameters: {
                'filter': filter,
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
    // Find the first meditation or use a default
    final dailyMeditation = _meditations.isNotEmpty ? _meditations.first : null;
    
    return GestureDetector(
      onTap: () {
        if (dailyMeditation != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MeditationDetailScreen(
                title: dailyMeditation.title,
                description: dailyMeditation.description,
                duration: '${dailyMeditation.duration.inMinutes} MIN',
                meditationId: dailyMeditation.id,
              ),
            ),
          );
          
          _analytics.logEvent('daily_calm_selected', parameters: {
            'meditation_id': dailyMeditation.id,
          });
        }
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
                          Text(
                            DateTime.now().day.toString().padLeft(2, '0') + ' ' + 
                            _getMonthAbbreviation(DateTime.now().month),
                            style: const TextStyle(
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

  String _getMonthAbbreviation(int month) {
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return months[month - 1];
  }

  Widget _buildMeditationGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.8,
      ),
      itemCount: _filteredMeditations.length,
      itemBuilder: (context, index) {
        final meditation = _filteredMeditations[index];
        return _buildMeditationCard(meditation);
      },
    );
  }

  Widget _buildMeditationCard(Meditation meditation) {
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
        
        _analytics.logEvent('meditation_selected', parameters: {
          'meditation_id': meditation.id,
          'meditation_title': meditation.title,
          'is_premium': meditation.isPremium,
          'is_downloaded': meditation.isDownloaded,
        });
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF67548B),
              const Color(0xFFD3C265),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            // Gradient overlay for text readability
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.5),
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
            // Content
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Title
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
                  // Duration
                  Text(
                    '${meditation.duration.inMinutes} MIN',
                    style: const TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  // Status indicators
                  Row(
                    children: [
                      if (meditation.isPremium)
                        Container(
                          margin: const EdgeInsets.only(top: 5, right: 5),
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
                      if (meditation.isDownloaded)
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.download_done, color: Colors.white, size: 10),
                              SizedBox(width: 2),
                              Text(
                                'OFFLINE',
                                style: TextStyle(
                                  fontFamily: 'HelveticaNeue',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: AppColors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'No meditations found',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _selectedFilter == 'Downloaded'
                ? 'You haven\'t downloaded any meditations yet'
                : 'Try selecting a different filter',
            style: const TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 14,
              color: Color(0xFFA0A3B1),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          if (_selectedFilter == 'Downloaded')
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedFilter = 'All';
                  _filterMeditations();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                'Browse Meditations',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
        ],
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