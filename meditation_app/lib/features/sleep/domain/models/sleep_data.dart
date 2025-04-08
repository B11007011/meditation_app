import 'package:hive/hive.dart';

part 'sleep_data.g.dart';

@HiveType(typeId: 1)
class SleepData {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final DateTime startTime;
  
  @HiveField(2)
  final DateTime endTime;
  
  @HiveField(3)
  final int qualityRating;
  
  @HiveField(4)
  final String? notes;

  SleepData({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.qualityRating,
    this.notes,
  });

  Duration get duration => endTime.difference(startTime);

  SleepData copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? qualityRating,
    String? notes,
  }) {
    return SleepData(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      qualityRating: qualityRating ?? this.qualityRating,
      notes: notes ?? this.notes,
    );
  }
}
