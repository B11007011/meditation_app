class ReminderSettings {
  final int hour;
  final int minute;
  final String amPm;
  final List<String> days;

  ReminderSettings({
    required this.hour,
    required this.minute,
    required this.amPm,
    required this.days,
  });

  // Create from a map
  factory ReminderSettings.fromMap(Map<String, dynamic> map) {
    return ReminderSettings(
      hour: map['hour'] as int,
      minute: map['minute'] as int,
      amPm: map['ampm'] as String,
      days: List<String>.from(map['days'] as List),
    );
  }

  // Convert to a map
  Map<String, dynamic> toMap() {
    return {
      'hour': hour,
      'minute': minute,
      'ampm': amPm,
      'days': days,
    };
  }

  // Get a formatted time string (e.g. "11:30 AM")
  String get formattedTime {
    return '$hour:${minute.toString().padLeft(2, '0')} $amPm';
  }

  // Get a formatted days string (e.g. "SU, M, T, W, S")
  String get formattedDays {
    return days.join(', ');
  }

  // Check if a specific day is selected
  bool isDaySelected(String day) {
    return days.contains(day);
  }

  // Add a day to the selected days
  ReminderSettings addDay(String day) {
    if (!days.contains(day)) {
      final newDays = List<String>.from(days)..add(day);
      return ReminderSettings(
        hour: hour,
        minute: minute,
        amPm: amPm,
        days: newDays,
      );
    }
    return this;
  }

  // Remove a day from the selected days
  ReminderSettings removeDay(String day) {
    if (days.contains(day)) {
      final newDays = List<String>.from(days)..remove(day);
      return ReminderSettings(
        hour: hour,
        minute: minute,
        amPm: amPm,
        days: newDays,
      );
    }
    return this;
  }

  // Toggle a day's selection
  ReminderSettings toggleDay(String day) {
    return isDaySelected(day) ? removeDay(day) : addDay(day);
  }

  // Create a copy with updated values
  ReminderSettings copyWith({
    int? hour,
    int? minute,
    String? amPm,
    List<String>? days,
  }) {
    return ReminderSettings(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      amPm: amPm ?? this.amPm,
      days: days ?? this.days,
    );
  }
} 