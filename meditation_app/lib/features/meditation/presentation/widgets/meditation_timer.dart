import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeditationTimer extends ConsumerStatefulWidget {
  final Duration initialDuration;
  final Function(Duration) onTick;
  final Function() onComplete;

  const MeditationTimer({
    super.key,
    required this.initialDuration,
    required this.onTick,
    required this.onComplete,
  });

  @override
  ConsumerState<MeditationTimer> createState() => _MeditationTimerState();
}

class _MeditationTimerState extends ConsumerState<MeditationTimer> {
  late Duration _remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.initialDuration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime -= const Duration(seconds: 1);
          widget.onTick(_remainingTime);
        } else {
          _timer.cancel();
          widget.onComplete();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer.cancel();
  }

  void _resumeTimer() {
    _startTimer();
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _remainingTime = widget.initialDuration;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Column(
      children: [
        Text(
          '$minutes:$seconds',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: _pauseTimer,
              iconSize: 36,
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: _resumeTimer,
              iconSize: 36,
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: _resetTimer,
              iconSize: 36,
            ),
          ],
        ),
      ],
    );
  }
}
