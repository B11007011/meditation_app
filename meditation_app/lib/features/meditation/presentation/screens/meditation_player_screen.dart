import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/features/meditation/domain/models/meditation.dart';
import 'package:meditation_app/features/meditation/domain/services/meditation_player_service.dart';
import 'package:meditation_app/features/meditation/domain/repositories/meditation_repository.dart';
import 'package:meditation_app/features/meditation/presentation/widgets/music_selector_widget.dart';
import 'package:meditation_app/features/music/domain/controllers/music_player_controller.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/shared/services/analytics_service.dart';

class MeditationPlayerScreen extends ConsumerStatefulWidget {
  final Meditation meditation;

  const MeditationPlayerScreen({super.key, required this.meditation});

  @override
  ConsumerState<MeditationPlayerScreen> createState() => _MeditationPlayerScreenState();
}

class _MeditationPlayerScreenState extends ConsumerState<MeditationPlayerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final MeditationRepository _repository = MeditationRepository();
  final AnalyticsService _analytics = AnalyticsService();
  bool _isDownloading = false;
  bool _isDeleting = false;
  double _volume = 1.0;
  double _musicVolume = 0.5;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _analytics.logScreenView('meditation_player');
    _analytics.logEvent('meditation_player_opened', parameters: {
      'meditation_id': widget.meditation.id,
      'meditation_title': widget.meditation.title,
    });

    // Start playing the meditation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final playerService = ref.read(meditationPlayerServiceProvider.notifier);
      playerService.play(widget.meditation);
      
      // Load meditation music playlist
      _loadMeditationMusic();
    });
  }

  Future<void> _loadMeditationMusic() async {
    final musicController = ref.read(musicPlayerControllerProvider.notifier);
    try {
      final tracks = await ref.read(musicRepositoryProvider).getTracksByCategory('meditation');
      await musicController.setPlaylist(tracks);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading background music: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> _toggleDownload() async {
    final meditation = widget.meditation;
    
    if (meditation.isDownloaded) {
      // Delete the downloaded meditation
      setState(() {
        _isDeleting = true;
      });
      
      try {
        await _repository.deleteDownloadedMeditation(meditation.id);
        _analytics.logEvent('meditation_deleted', parameters: {
          'meditation_id': meditation.id,
          'meditation_title': meditation.title,
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Meditation deleted from device')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting meditation: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isDeleting = false;
          });
        }
      }
    } else {
      // Download the meditation
      setState(() {
        _isDownloading = true;
      });
      
      try {
        await _repository.downloadMeditation(meditation.id);
        _analytics.logEvent('meditation_downloaded', parameters: {
          'meditation_id': meditation.id,
          'meditation_title': meditation.title,
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Meditation downloaded for offline use')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error downloading meditation: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isDownloading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final playerService = ref.watch(meditationPlayerServiceProvider.notifier);
        final playbackState = ref.watch(meditationPlayerServiceProvider);
        final isPlaying = playbackState == PlaybackState.playing;
        
        if (isPlaying && !_animationController.isAnimating) {
          _animationController.forward();
        } else if (!isPlaying && _animationController.isCompleted) {
          _animationController.reverse();
        }
        
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF8E97FD),
                  const Color(0xFF6B75CA).withOpacity(0.8),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: _buildMeditationContent(playerService, playbackState),
                  ),
                  _buildPlayerControls(playerService, playbackState),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'PLAYING NOW',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          IconButton(
            icon: Icon(
              widget.meditation.isDownloaded
                  ? Icons.delete_outline
                  : Icons.download_outlined,
              color: Colors.white,
            ),
            onPressed: _isDownloading || _isDeleting ? null : _toggleDownload,
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationContent(MeditationPlayerService playerService, PlaybackState playbackState) {
    return Consumer(
      builder: (context, ref, child) {
        final position = playerService.position;
        final duration = playerService.duration;
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Meditation image
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(125),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(widget.meditation.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Meditation title
              Text(
                widget.meditation.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Narrator
              Text(
                'Narrated by ${widget.meditation.narrator}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Progress bar
              Column(
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.white.withOpacity(0.3),
                      thumbColor: Colors.white,
                      overlayColor: Colors.white.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: position.inMilliseconds.toDouble(),
                      min: 0,
                      max: duration.inMilliseconds.toDouble() == 0
                          ? widget.meditation.duration.inMilliseconds.toDouble()
                          : duration.inMilliseconds.toDouble(),
                      onChanged: (value) {
                        playerService.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(position),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _formatDuration(duration.inMilliseconds > 0
                              ? duration
                              : widget.meditation.duration),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Volume control
              Row(
                children: [
                  const Icon(Icons.volume_down, color: Colors.white, size: 20),
                  Expanded(
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white.withOpacity(0.3),
                        thumbColor: Colors.white,
                        overlayColor: Colors.white.withOpacity(0.2),
                      ),
                      child: Slider(
                        value: _volume,
                        min: 0,
                        max: 1,
                        onChanged: (value) {
                          setState(() {
                            _volume = value;
                          });
                          playerService.setVolume(value);
                        },
                      ),
                    ),
                  ),
                  const Icon(Icons.volume_up, color: Colors.white, size: 20),
                ],
              ),
              const SizedBox(height: 32),
              
              // Add music selector
              MusicSelectorWidget(
                volume: _musicVolume,
                onVolumeChanged: (value) {
                  setState(() {
                    _musicVolume = value;
                  });
                  final musicController = ref.read(musicPlayerControllerProvider.notifier);
                  musicController.setVolume(_musicVolume);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayerControls(MeditationPlayerService playerService, PlaybackState playbackState) {
    return Consumer(
      builder: (context, ref, child) {
        final position = playerService.position;
        final duration = playerService.duration;
        final isPlaying = playbackState == PlaybackState.playing;
        final isPaused = playbackState == PlaybackState.paused;
        
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Rewind 15 seconds
              IconButton(
                icon: const Icon(Icons.replay, color: Colors.white, size: 35),
                onPressed: () {
                  final newPosition = position - const Duration(seconds: 15);
                  playerService.seek(newPosition.isNegative ? Duration.zero : newPosition);
                },
              ),
              // Play/Pause button
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _animationController,
                    size: 40,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      playerService.pause();
                    } else if (isPaused) {
                      playerService.resume();
                    } else {
                      playerService.play(widget.meditation);
                    }
                  },
                ),
              ),
              // Forward 15 seconds
              IconButton(
                icon: const Icon(Icons.forward_30, color: Colors.white, size: 35),
                onPressed: () {
                  final newPosition = position + const Duration(seconds: 15);
                  final maxDuration = duration.inMilliseconds > 0
                      ? duration
                      : widget.meditation.duration;
                  playerService.seek(newPosition > maxDuration ? maxDuration : newPosition);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
