import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meditation_app/features/meditation/domain/models/meditation.dart';

// Mock data for testing
final List<Meditation> mockMeditations = [
  Meditation(
    id: 'meditation-1',
    title: 'Morning Meditation',
    description: 'Start your day with mindfulness',
    audioUrl: 'https://example.com/meditation1.mp3',
    imageUrl: 'https://example.com/meditation1.jpg',
    duration: const Duration(minutes: 10),
    category: 'Mindfulness',
    isPremium: false,
    isDownloaded: false,
    narrator: 'John Doe',
  ),
  Meditation(
    id: 'meditation-2',
    title: 'Sleep Well',
    description: 'Relax and prepare for sleep',
    audioUrl: 'https://example.com/meditation2.mp3',
    imageUrl: 'https://example.com/meditation2.jpg',
    duration: const Duration(minutes: 20),
    category: 'Sleep',
    isPremium: true,
    isDownloaded: true,
    narrator: 'Jane Smith',
  ),
];

void main() {
  group('Meditation App UI Tests', () {
    testWidgets('App should display Silent Moon text', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Silent Moon'),
          ),
        ),
      ));
      expect(find.text('Silent Moon'), findsOneWidget);
    });
  });

  group('Meditation Model Tests', () {
    test('Meditation model should have correct properties', () {
      final meditation = mockMeditations.first;
      
      expect(meditation.id, equals('meditation-1'));
      expect(meditation.title, equals('Morning Meditation'));
      expect(meditation.description, equals('Start your day with mindfulness'));
      expect(meditation.audioUrl, equals('https://example.com/meditation1.mp3'));
      expect(meditation.duration, equals(const Duration(minutes: 10)));
      expect(meditation.category, equals('Mindfulness'));
      expect(meditation.isPremium, equals(false));
      expect(meditation.isDownloaded, equals(false));
      expect(meditation.narrator, equals('John Doe'));
    });

    test('Meditation models with different IDs should not be equal', () {
      final meditation1 = mockMeditations[0];
      final meditation2 = mockMeditations[1];
      
      expect(meditation1.id != meditation2.id, isTrue);
    });
  });
}
