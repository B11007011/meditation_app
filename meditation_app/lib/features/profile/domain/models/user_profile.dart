import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 3)
class UserProfile {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String? email;
  
  @HiveField(3)
  final String? avatarUrl;
  
  @HiveField(4)
  final DateTime? lastMeditationDate;
  
  @HiveField(5)
  final int totalSessions;
  
  @HiveField(6)
  final Duration totalMeditationTime;

  UserProfile({
    required this.id,
    required this.name,
    this.email,
    this.avatarUrl,
    this.lastMeditationDate,
    this.totalSessions = 0,
    this.totalMeditationTime = Duration.zero,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    DateTime? lastMeditationDate,
    int? totalSessions,
    Duration? totalMeditationTime,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastMeditationDate: lastMeditationDate ?? this.lastMeditationDate,
      totalSessions: totalSessions ?? this.totalSessions,
      totalMeditationTime: totalMeditationTime ?? this.totalMeditationTime,
    );
  }
}
