import 'package:hive/hive.dart';

part 'music_track.g.dart';

@HiveType(typeId: 2)
class MusicTrack {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String artist;
  
  @HiveField(3)
  final String audioUrl;
  
  @HiveField(4)
  final String? imageUrl;
  
  @HiveField(5)
  final Duration duration;
  
  @HiveField(6)
  final bool isDownloaded;

  MusicTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.audioUrl,
    this.imageUrl,
    required this.duration,
    this.isDownloaded = false,
  });

  MusicTrack copyWith({
    String? id,
    String? title,
    String? artist,
    String? audioUrl,
    String? imageUrl,
    Duration? duration,
    bool? isDownloaded,
  }) {
    return MusicTrack(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      duration: duration ?? this.duration,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
}
