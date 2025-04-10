import 'package:flutter/material.dart';
import 'dart:math';
import 'package:meditation_app/shared/theme/app_theme.dart';
import 'package:meditation_app/features/home/presentation/screens/home_screen.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final Duration totalDuration;
  final bool isPlaying;

  const MusicPlayerScreen({
    super.key,
    this.title = 'Focus Attention',
    this.subtitle = '7 DAYS OF CALM',
    this.totalDuration = const Duration(minutes: 45),
    this.isPlaying = false,
  });

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> with SingleTickerProviderStateMixin {
  late Duration _currentPosition;
  late bool _isPlaying;
  double _volume = 0.8;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _currentPosition = const Duration(minutes: 1, seconds: 30);
    _isPlaying = widget.isPlaying;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8E97FD), Color(0xFFF2F6FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const Spacer(),
              _buildMusicInfo(),
              const SizedBox(height: 60),
              _buildProgressBar(),
              const SizedBox(height: 50),
              _buildVolumeControl(),
              const SizedBox(height: 50),
              _buildControls(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(255, 255, 255, 0.3),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const Text(
            'PLAYING NOW',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.download_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicInfo() {
    return Column(
      children: [
        Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF67548B), Color(0xFFD3C265)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animated music visualization effect
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: MusicVisualizerPainter(
                      progress: _animationController.value,
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                    ),
                    size: const Size(180, 180),
                  );
                }
              ),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.music_note,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.1,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          widget.subtitle,
          style: const TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 14,
            letterSpacing: 0.7,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    final progress = _currentPosition.inMilliseconds / widget.totalDuration.inMilliseconds;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              activeTrackColor: Colors.white,
              inactiveTrackColor: Color.fromRGBO(255, 255, 255, 0.3),
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            ),
            child: Slider(
              value: progress,
              onChanged: (value) {
                setState(() {
                  _currentPosition = Duration(
                    milliseconds: (value * widget.totalDuration.inMilliseconds).round(),
                  );
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_currentPosition),
                style: const TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Text(
                _formatDuration(widget.totalDuration),
                style: const TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeControl() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          const Icon(
            Icons.volume_down,
            color: Colors.white,
            size: 24,
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                activeTrackColor: Colors.white,
                inactiveTrackColor: Color.fromRGBO(255, 255, 255, 0.3),
                thumbColor: Colors.white,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              ),
              child: Slider(
                value: _volume,
                onChanged: (value) {
                  setState(() {
                    _volume = value;
                  });
                },
              ),
            ),
          ),
          const Icon(
            Icons.volume_up,
            color: Colors.white,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Backward button
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(255, 255, 255, 0.3),
            ),
            child: const Icon(
              Icons.replay_10,
              color: Colors.white,
              size: 28,
            ),
          ),
          
          // Play/Pause button
          GestureDetector(
            onTap: () {
              setState(() {
                _isPlaying = !_isPlaying;
                if (_isPlaying) {
                  _animationController.repeat();
                } else {
                  _animationController.stop();
                }
              });
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: AppColors.primary,
                size: 40,
              ),
            ),
          ),
          
          // Forward button
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(255, 255, 255, 0.3),
            ),
            child: const Icon(
              Icons.forward_10,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class MusicVisualizerPainter extends CustomPainter {
  final double progress;
  final Color color;

  MusicVisualizerPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Draw circular waves
    for (int i = 0; i < 5; i++) {
      final waveRadius = (radius - 20) * (0.3 + (i / 10)) + 10 * 
          (1 + sin(progress * 2 * 3.14 + i * 0.5)) * 
          (1 + i / 10);
      
      canvas.drawCircle(center, waveRadius, paint);
    }
  }

  @override
  bool shouldRepaint(MusicVisualizerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
} 