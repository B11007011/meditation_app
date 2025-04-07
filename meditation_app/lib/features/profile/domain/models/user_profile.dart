class UserProfile {
  final String name;
  final String email;
  final String? photoUrl;
  final int meditationMinutes;
  final int sessionsCompleted;
  final int longestStreak;
  final int currentStreak;
  final bool isPremium;

  UserProfile({
    required this.name,
    required this.email,
    this.photoUrl,
    this.meditationMinutes = 0,
    this.sessionsCompleted = 0,
    this.longestStreak = 0,
    this.currentStreak = 0,
    this.isPremium = false,
  });

  // Create a copy with updated values
  UserProfile copyWith({
    String? name,
    String? email,
    String? photoUrl,
    int? meditationMinutes,
    int? sessionsCompleted,
    int? longestStreak,
    int? currentStreak,
    bool? isPremium,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      meditationMinutes: meditationMinutes ?? this.meditationMinutes,
      sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
      longestStreak: longestStreak ?? this.longestStreak,
      currentStreak: currentStreak ?? this.currentStreak,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  // Create from a map (for storage/backend)
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] as String,
      email: map['email'] as String,
      photoUrl: map['photoUrl'] as String?,
      meditationMinutes: map['meditationMinutes'] as int? ?? 0,
      sessionsCompleted: map['sessionsCompleted'] as int? ?? 0,
      longestStreak: map['longestStreak'] as int? ?? 0,
      currentStreak: map['currentStreak'] as int? ?? 0,
      isPremium: map['isPremium'] as bool? ?? false,
    );
  }

  // Convert to a map (for storage/backend)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'meditationMinutes': meditationMinutes,
      'sessionsCompleted': sessionsCompleted,
      'longestStreak': longestStreak,
      'currentStreak': currentStreak,
      'isPremium': isPremium,
    };
  }
} 