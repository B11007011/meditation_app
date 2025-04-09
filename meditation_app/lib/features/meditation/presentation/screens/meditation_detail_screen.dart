import 'package:flutter/material.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/features/meditation/domain/models/meditation.dart';
import 'package:meditation_app/features/meditation/domain/repositories/meditation_repository.dart';
import 'package:meditation_app/features/meditation/presentation/screens/meditation_player_screen.dart';
import 'package:meditation_app/shared/services/analytics_service.dart';

class MeditationDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final String duration;
  final String? meditationId;

  const MeditationDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.duration,
    this.meditationId,
  });

  @override
  State<MeditationDetailScreen> createState() => _MeditationDetailScreenState();
}

class _MeditationDetailScreenState extends State<MeditationDetailScreen> {
  final MeditationRepository _repository = MeditationRepository();
  final AnalyticsService _analytics = AnalyticsService();
  Meditation? _meditation;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _analytics.logScreenView('meditation_detail');
    _loadMeditation();
  }

  Future<void> _loadMeditation() async {
    if (widget.meditationId != null) {
      try {
        final meditation = _repository.getMeditationById(widget.meditationId!);
        setState(() {
          _meditation = meditation;
        });
      } catch (e) {
        // If meditation not found by ID, create a temporary one from the provided details
        setState(() {
          _meditation = Meditation(
            id: 'temp_${widget.title.toLowerCase().replaceAll(' ', '_')}',
            title: widget.title,
            description: widget.description,
            category: 'General',
            imageUrl: 'assets/images/meditation/default.jpg',
            audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
            duration: _parseDuration(widget.duration),
            narrator: 'Silent Moon',
          );
        });
      }
    } else {
      // Create a temporary meditation from the provided details
      setState(() {
        _meditation = Meditation(
          id: 'temp_${widget.title.toLowerCase().replaceAll(' ', '_')}',
          title: widget.title,
          description: widget.description,
          category: 'General',
          imageUrl: 'assets/images/meditation/default.jpg',
          audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
          duration: _parseDuration(widget.duration),
          narrator: 'Silent Moon',
        );
      });
    }
  }

  Duration _parseDuration(String durationStr) {
    // Parse durations like "10 MIN" or "5-10 MIN"
    final regex = RegExp(r'(\d+)(?:-(\d+))? MIN');
    final match = regex.firstMatch(durationStr);
    
    if (match != null) {
      final minutes = int.tryParse(match.group(1) ?? '10') ?? 10;
      return Duration(minutes: minutes);
    }
    
    return const Duration(minutes: 10); // Default duration
  }

  Future<void> _toggleDownload() async {
    if (_meditation == null) return;
    
    setState(() {
      _isDownloading = true;
    });
    
    try {
      if (_meditation!.isDownloaded) {
        await _repository.deleteDownloadedMeditation(_meditation!.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meditation removed from downloads')),
        );
      } else {
        await _repository.downloadMeditation(_meditation!.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meditation downloaded for offline use')),
        );
      }
      
      // Refresh meditation data
      _loadMeditation();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  void _startMeditation() {
    if (_meditation == null) return;
    
    _analytics.logEvent('meditation_started', parameters: {
      'meditation_id': _meditation!.id,
      'meditation_title': _meditation!.title,
    });
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeditationPlayerScreen(meditation: _meditation!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _meditation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Background image
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_meditation!.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Gradient overlay
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
                // Content
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _meditation!.title,
                                    style: const TextStyle(
                                      fontFamily: 'HelveticaNeue',
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF3F414E),
                                    ),
                                  ),
                                ),
                                if (_meditation!.id.startsWith('meditation_'))
                                  IconButton(
                                    icon: Icon(
                                      _meditation!.isDownloaded
                                          ? Icons.delete_outline
                                          : Icons.download_outlined,
                                      color: AppColors.primary,
                                    ),
                                    onPressed: _isDownloading ? null : _toggleDownload,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _formatDuration(_meditation!.duration),
                                    style: TextStyle(
                                      fontFamily: 'HelveticaNeue',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _meditation!.category,
                                    style: TextStyle(
                                      fontFamily: 'HelveticaNeue',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                if (_meditation!.isPremium) ...[  
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'PREMIUM',
                                      style: TextStyle(
                                        fontFamily: 'HelveticaNeue',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3F414E),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _meditation!.description,
                              style: const TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontSize: 16,
                                color: Color(0xFF5F6368),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Narrator',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3F414E),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: AppColors.primary.withOpacity(0.1),
                                  child: Text(
                                    _meditation!.narrator.substring(0, 1),
                                    style: TextStyle(
                                      fontFamily: 'HelveticaNeue',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  _meditation!.narrator,
                                  style: const TextStyle(
                                    fontFamily: 'HelveticaNeue',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF3F414E),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: _startMeditation,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'START MEDITATION',
                                  style: TextStyle(
                                    fontFamily: 'HelveticaNeue',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Back button
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _formatDuration(Duration duration) {
    return '${duration.inMinutes} MIN';
  }
}
