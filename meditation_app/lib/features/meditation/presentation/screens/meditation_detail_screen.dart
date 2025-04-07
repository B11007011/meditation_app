import 'package:flutter/material.dart';
import 'package:meditation_app/shared/theme/app_theme.dart';

class MeditationDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String duration;
  
  const MeditationDetailScreen({
    super.key,
    this.title = 'Happy Morning',
    this.description = 'Ease the mind into a restful night\'s sleep with these deep, ambient tones.',
    this.duration = '10 MIN',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    _buildCourseStats(),
                    const SizedBox(height: 40),
                    _buildNarratorSection(),
                    const SizedBox(height: 40),
                    _buildDivider(),
                    const SizedBox(height: 30),
                    _buildSessionsList(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        // Header background and image
        Container(
          height: 300,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF3E476E),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Center(
            child: Icon(
              Icons.self_improvement,
              size: 120,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
        
        // Safe area for top padding
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Course indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'COURSE',
                    style: TextStyle(
                      color: Color(0xFFA1A4B2),
                      fontSize: 14,
                      fontFamily: 'HelveticaNeue',
                      letterSpacing: 0.7,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Title and description
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF3F414E),
                  fontSize: 34,
                  fontFamily: 'HelveticaNeue',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFFA1A4B2),
                  fontSize: 16,
                  fontFamily: 'HelveticaNeue',
                  fontWeight: FontWeight.w300,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCourseStats() {
    return Row(
      children: [
        // Favorites
        Row(
          children: [
            Icon(
              Icons.favorite,
              color: const Color(0xFFFF84A2),
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              '24,234 FAVORITES',
              style: TextStyle(
                color: Color(0xFFA1A4B2),
                fontSize: 14,
                fontFamily: 'HelveticaNeue',
              ),
            ),
          ],
        ),
        const SizedBox(width: 25),
        // Listening
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFF67C8C1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.headset,
                color: Colors.white,
                size: 12,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '34,234 LISTENING',
              style: TextStyle(
                color: Color(0xFFA1A4B2),
                fontSize: 14,
                fontFamily: 'HelveticaNeue',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNarratorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pick a Narrator',
          style: TextStyle(
            color: Color(0xFF3F414E),
            fontSize: 20,
            fontFamily: 'HelveticaNeue',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            // Male voice option (selected)
            Expanded(
              child: Container(
                height: 63,
                decoration: BoxDecoration(
                  color: const Color(0xFF8E97FD),
                  borderRadius: BorderRadius.circular(38),
                ),
                child: const Center(
                  child: Text(
                    'MALE VOICE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'HelveticaNeue',
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Female voice option
            Expanded(
              child: Container(
                height: 63,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(38),
                  border: Border.all(
                    color: const Color(0xFFEBEAEC),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'FEMALE VOICE',
                    style: TextStyle(
                      color: Color(0xFF3F414E),
                      fontSize: 16,
                      fontFamily: 'HelveticaNeue',
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 5,
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6E6),
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }

  Widget _buildSessionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Focus Attention - selected session
        _buildSessionItem(
          title: 'Focus Attention',
          duration: '10 MIN',
          isSelected: true,
        ),
        const SizedBox(height: 20),
        _buildSessionItem(
          title: 'Body Scan',
          duration: '5 MIN',
          isSelected: false,
        ),
        const SizedBox(height: 20),
        _buildSessionItem(
          title: 'Making Happiness',
          duration: '3 MIN',
          isSelected: false,
        ),
      ],
    );
  }

  Widget _buildSessionItem({
    required String title,
    required String duration,
    required bool isSelected,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                duration,
                style: const TextStyle(
                  color: Color(0xFFA1A4B2),
                  fontSize: 11,
                  fontFamily: 'HelveticaNeue',
                  letterSpacing: 0.55,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF3F414E),
                  fontSize: 16,
                  fontFamily: 'HelveticaNeue',
                ),
              ),
            ],
          ),
        ),
        // Play button
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected 
                ? const Color(0xFF8E97FD) 
                : Colors.transparent,
            border: isSelected 
                ? null 
                : Border.all(color: const Color(0xFFA1A4B2), width: 1),
          ),
          child: Icon(
            Icons.play_arrow,
            color: isSelected 
                ? Colors.white 
                : const Color(0xFFA1A4B2),
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(20),
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
        children: [
          // Download button
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFE6E7F2),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.file_download_outlined,
              color: Color(0xFFE6E7F2),
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
          // Play button
          Expanded(
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF8E97FD),
                borderRadius: BorderRadius.circular(38),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'PLAY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'HelveticaNeue',
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 