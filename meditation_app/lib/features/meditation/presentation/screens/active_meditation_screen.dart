import 'package:flutter/material.dart';
import 'package:meditation_app/features/meditation/presentation/widgets/meditation_timer.dart';

class ActiveMeditationScreen extends StatefulWidget {
  final String title;
  final Duration duration;

  const ActiveMeditationScreen({
    super.key,
    required this.title,
    required this.duration,
  });

  @override
  State<ActiveMeditationScreen> createState() => _ActiveMeditationScreenState();
}

class _ActiveMeditationScreenState extends State<ActiveMeditationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            
            // Timer display
            Expanded(
              child: Center(
                child: MeditationTimer(
                  initialDuration: widget.duration,
                  onTick: (remaining) {
                    // Handle timer tick updates
                  },
                  onComplete: () {
                    // Handle session completion
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Meditation session completed!')),
                    );
                  },
                ),
              ),
            ),
            
            // Background sound controls
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () {},
                        iconSize: 36,
                      ),
                      const Text('Volume'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.music_note),
                        onPressed: () {},
                        iconSize: 36,
                      ),
                      const Text('Ambient Sound'),
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
}
