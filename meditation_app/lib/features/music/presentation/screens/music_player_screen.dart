import 'package:flutter/material.dart';
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

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late Duration _currentPosition;
  late bool _isPlaying;
  double _volume = 0.8;

  @override
  void initState() {
    super.initState();
    _currentPosition = const Duration(minutes: 1, seconds: 30);
    _isPlaying = widget.isPlaying;
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
      backgroundColor: const Color(0xFFFAF7F2),
      body: Stack(
        children: [
          // Background decorations
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 0.8,
                  colors: [
                    const Color(0xFFF2EDE4),
                    const Color(0xFFFAF7F2).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.6,
                  colors: [
                    const Color(0xFFF2EDE4),
                    const Color(0xFFF2EDE4).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const Spacer(),
                _buildMusicInfo(),
                const SizedBox(height: 60),
                _buildProgressBar(),
                const SizedBox(height: 60),
                _buildVolumeControl(),
                const SizedBox(height: 60),
                _buildControls(),
                const Spacer(),
              ],
            ),
          ),
        ],
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
                border: Border.all(
                  color: const Color(0xFFEBEAEC),
                  width: 1,
                ),
                color: Colors.white,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF3F414E),
                size: 20,
              ),
            ),
          ),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFB6B8BF).withOpacity(0.8),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Music visualization effect
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFA0A3B1).withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
              Icon(
                Icons.music_note,
                size: 80,
                color: const Color(0xFF3F414E).withOpacity(0.8),
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
            color: Color(0xFF3F414E),
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
            color: Color(0xFFA0A3B1),
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
              activeTrackColor: const Color(0xFF3F414E),
              inactiveTrackColor: const Color(0xFFA0A3B1).withOpacity(0.5),
              thumbColor: const Color(0xFF3F414E),
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
                  color: Color(0xFF3F414E),
                ),
              ),
              Text(
                _formatDuration(widget.totalDuration),
                style: const TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 16,
                  color: Color(0xFF3F414E),
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
            color: Color(0xFFA0A3B1),
            size: 24,
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                activeTrackColor: const Color(0xFF3F414E),
                inactiveTrackColor: const Color(0xFFA0A3B1).withOpacity(0.5),
                thumbColor: const Color(0xFF3F414E),
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
            color: Color(0xFFA0A3B1),
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
              color: const Color(0xFFC4C5CA),
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
              });
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFEBEAEC),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: const Color(0xFF3F414E),
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
              color: const Color(0xFFC4C5CA),
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