import 'package:hive/hive.dart';

part 'meditation_session.g.dart';

@HiveType(typeId: 0)
class MeditationSession {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final Duration duration;
  
  @HiveField(4)
  final String audioUrl;
  
  @HiveField(5)
  final String imageUrl;
  
  @HiveField(6)
  final DateTime createdAt;
  
  @HiveField(7)
  final bool isFavorite;

  MeditationSession({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.audioUrl,
    required this.imageUrl,
    required this.createdAt,
    this.isFavorite = false,
  });

  MeditationSession copyWith({
    String? id,
    String? title,
    String? description,
    Duration? duration,
    String? audioUrl,
    String? imageUrl,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return MeditationSession(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
