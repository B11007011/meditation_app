import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';

class SleepPlayerScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final Duration duration;
  final Color backgroundColor;
  final String? backgroundImage;

  const SleepPlayerScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.backgroundColor,
    this.backgroundImage,
  });

  @override
  State<SleepPlayerScreen> createState() => _SleepPlayerScreenState();
}

class _SleepPlayerScreenState extends State<SleepPlayerScreen> {
  bool _isPlaying = false;
  double _currentSliderValue = 0.0;
  double _volumeValue = 0.7;
  Duration _currentPosition = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03174C), // Dark blue background from Figma
      body: Stack(
        children: [
          // Background with gradient and stars
          Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              image: widget.backgroundImage != null 
                ? DecorationImage(
                    image: AssetImage(widget.backgroundImage!),
                    fit: BoxFit.cover,
                  ) 
                : null,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF03174C).withOpacity(0.8),
                        const Color(0xFF03174C),
                      ],
                    ),
                  ),
                ),
                // Star 1
                Positioned(
                  top: 100,
                  right: 60,
                  child: Opacity(
                    opacity: 0.7,
                    child: SvgPicture.asset(
                      'assets/images/sleep/vector_star_1.svg',
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
                // Star 2
                Positioned(
                  top: 180,
                  left: 40,
                  child: Opacity(
                    opacity: 0.5,
                    child: SvgPicture.asset(
                      'assets/images/sleep/vector_star_2.svg',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
                // Star 3
                Positioned(
                  bottom: 200,
                  right: 30,
                  child: Opacity(
                    opacity: 0.6,
                    child: SvgPicture.asset(
                      'assets/images/sleep/vector_star_3.svg',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                // Star 4
                Positioned(
                  bottom: 300,
                  left: 70,
                  child: Opacity(
                    opacity: 0.8,
                    child: SvgPicture.asset(
                      'assets/images/sleep/vector_star_4.svg',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSleepInfo(),
                        const SizedBox(height: 40),
                        _buildPlayControls(),
                        const SizedBox(height: 40),
                        _buildProgressBar(),
                        const SizedBox(height: 40),
                        _buildVolumeControl(),
                      ],
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF03174C).withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
          ),
          Text(
            'PLAYING NOW',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 1,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF03174C).withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.favorite_border,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepInfo() {
    return Column(
      children: [
        // Moon illustration with SVG
        Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            color: const Color(0xFF4C53B4).withOpacity(0.2),
            borderRadius: BorderRadius.circular(130),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Moon glow effect
              Opacity(
                opacity: 0.7,
                child: SvgPicture.asset(
                  'assets/images/sleep/moon_glow.svg',
                  width: 210,
                  height: 210,
                ),
              ),
              // Moon vector
              SvgPicture.asset(
                'assets/images/sleep/moon_vector.svg',
                width: 140,
                height: 140,
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.subtitle,
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: Colors.white.withOpacity(0.8),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {
            // Skip backwards 15 seconds
            setState(() {
              _currentPosition = Duration(
                seconds: (_currentPosition.inSeconds - 15).clamp(
                  0,
                  widget.duration.inSeconds,
                ),
              );
              _currentSliderValue =
                  _currentPosition.inSeconds / widget.duration.inSeconds;
            });
          },
          icon: const Icon(
            Icons.replay_10,
            color: Colors.white,
            size: 24,
          ),
        ),
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
              color: const Color(0xFF8E97FD),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8E97FD).withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            // Skip forward 15 seconds
            setState(() {
              _currentPosition = Duration(
                seconds: (_currentPosition.inSeconds + 15).clamp(
                  0,
                  widget.duration.inSeconds,
                ),
              );
              _currentSliderValue =
                  _currentPosition.inSeconds / widget.duration.inSeconds;
            });
          },
          icon: const Icon(
            Icons.forward_10,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
    }

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF8E97FD),
            inactiveTrackColor: Colors.white.withOpacity(0.2),
            thumbColor: Colors.white,
            trackHeight: 4.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
          ),
          child: Slider(
            value: _currentSliderValue,
            onChanged: (value) {
              setState(() {
                _currentSliderValue = value;
                _currentPosition = Duration(
                  seconds: (value * widget.duration.inSeconds).round(),
                );
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDuration(_currentPosition),
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              Text(
                formatDuration(widget.duration),
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVolumeControl() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.volume_down,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF8E97FD),
                  inactiveTrackColor: Colors.white.withOpacity(0.2),
                  thumbColor: Colors.white,
                  trackHeight: 4.0,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
                ),
                child: Slider(
                  value: _volumeValue,
                  onChanged: (value) {
                    setState(() {
                      _volumeValue = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.volume_up,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Time options
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimeOption('5 MIN', false),
            const SizedBox(width: 10),
            _buildTimeOption('10 MIN', false),
            const SizedBox(width: 10),
            _buildTimeOption('15 MIN', false),
            const SizedBox(width: 10),
            _buildTimeOption('30 MIN', true),
            const SizedBox(width: 10),
            _buildTimeOption('45 MIN', false),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeOption(String time, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected 
            ? const Color(0xFF8E97FD) 
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        time,
        style: TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          color: isSelected 
              ? Colors.white 
              : Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }
} 