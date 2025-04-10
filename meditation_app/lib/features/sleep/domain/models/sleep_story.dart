import 'package:hive/hive.dart';

part 'sleep_story.g.dart';

@HiveType(typeId: 6)
class SleepStory {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String type;
  
  @HiveField(3)
  final Duration duration;
  
  @HiveField(4)
  final String? imageUrl;
  
  @HiveField(5)
  final String? audioUrl;
  
  @HiveField(6)
  final String? narrator;
  
  @HiveField(7)
  final String? description;
  
  @HiveField(8)
  final bool isPremium;
  
  @HiveField(9)
  final bool isDownloaded;
  
  @HiveField(10)
  final String? localAudioPath;
  
  @HiveField(11)
  final List<String> tags;

  SleepStory({
    required this.id,
    required this.title,
    required this.type,
    required this.duration,
    this.imageUrl,
    this.audioUrl,
    this.narrator,
    this.description,
    this.isPremium = false,
    this.isDownloaded = false,
    this.localAudioPath,
    this.tags = const [],
  });

  String get durationText {
    final minutes = duration.inMinutes;
    if (minutes < 60) {
      return '$minutes MIN';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours HR';
      } else {
        return '$hours HR $remainingMinutes MIN';
      }
    }
  }
  
  SleepStory copyWith({
    String? id,
    String? title,
    String? type,
    Duration? duration,
    String? imageUrl,
    String? audioUrl,
    String? narrator,
    String? description,
    bool? isPremium,
    bool? isDownloaded,
    String? localAudioPath,
    List<String>? tags,
  }) {
    return SleepStory(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      narrator: narrator ?? this.narrator,
      description: description ?? this.description,
      isPremium: isPremium ?? this.isPremium,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      localAudioPath: localAudioPath ?? this.localAudioPath,
      tags: tags ?? this.tags,
    );
  }
} 