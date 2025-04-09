import 'package:hive/hive.dart';

part 'meditation.g.dart';

@HiveType(typeId: 1)
class Meditation {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  final String audioUrl;

  @HiveField(6)
  final Duration duration;

  @HiveField(7)
  final String narrator;

  @HiveField(8)
  final bool isPremium;

  @HiveField(9)
  final bool isDownloaded;

  @HiveField(10)
  final String? localAudioPath;

  const Meditation({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.audioUrl,
    required this.duration,
    required this.narrator,
    this.isPremium = false,
    this.isDownloaded = false,
    this.localAudioPath,
  });

  Meditation copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? imageUrl,
    String? audioUrl,
    Duration? duration,
    String? narrator,
    bool? isPremium,
    bool? isDownloaded,
    String? localAudioPath,
  }) {
    return Meditation(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      narrator: narrator ?? this.narrator,
      isPremium: isPremium ?? this.isPremium,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      localAudioPath: localAudioPath ?? this.localAudioPath,
    );
  }
}
