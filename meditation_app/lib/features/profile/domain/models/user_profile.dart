/// Represents a user's profile and meditation statistics.
/// 
/// This immutable class provides methods to safely modify and serialize user data.
class UserProfile {
  /// The user's full name.
  final String name;

  /// The user's email address.
  final String email;

  /// URL to the user's profile photo, if available.
  final String? photoUrl;

  /// Total minutes the user has meditated.
  final int meditationMinutes;

  /// Number of meditation sessions completed.
  final int sessionsCompleted;

  /// Longest streak of consecutive meditation days.
  final int longestStreak;

  /// Current streak of consecutive meditation days.
  final int currentStreak;

  /// Whether the user has a premium subscription.
  final bool isPremium;

  /// Creates a [UserProfile] instance with required user information.
  ///
  /// Validates input parameters to ensure:
  /// - [name] and [email] are non-empty
  /// - All numerical values are non-negative
  UserProfile({
    required this.name,
    required this.email,
    this.photoUrl,
    this.meditationMinutes = 0,
    this.sessionsCompleted = 0,
    this.longestStreak = 0,
    this.currentStreak = 0,
    this.isPremium = false,
  }) : assert(name.isNotEmpty, 'Name cannot be empty'),
       assert(email.isNotEmpty, 'Email cannot be empty'),
       assert(meditationMinutes >= 0, 'Meditation minutes cannot be negative'),
       assert(sessionsCompleted >= 0, 'Sessions completed cannot be negative'),
       assert(longestStreak >= 0, 'Longest streak cannot be negative'),
       assert(currentStreak >= 0, 'Current streak cannot be negative');

  /// Creates a copy of this profile with updated values.
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

  /// Creates a [UserProfile] from JSON data.
  ///
  /// Handles type conversion safely with default values for missing/invalid data.
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: _parseString(map['name']),
      email: _parseString(map['email']),
      photoUrl: _parseNullableString(map['photoUrl']),
      meditationMinutes: _parseInt(map['meditationMinutes']),
      sessionsCompleted: _parseInt(map['sessionsCompleted']),
      longestStreak: _parseInt(map['longestStreak']),
      currentStreak: _parseInt(map['currentStreak']),
      isPremium: _parseBool(map['isPremium']),
    );
  }

  /// Converts this profile to JSON format.
  ///
  /// Omits null values and prepares for storage/transmission.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'meditationMinutes': meditationMinutes,
      'sessionsCompleted': sessionsCompleted,
      'longestStreak': longestStreak,
      'currentStreak': currentStreak,
      'isPremium': isPremium,
    };
  }

  /// Increments the sessions counter by 1
  UserProfile incrementSessions() {
    return copyWith(sessionsCompleted: sessionsCompleted + 1);
  }

  /// Adds meditation minutes to the total
  UserProfile addMeditationTime(int minutes) {
    assert(minutes >= 0, 'Cannot add negative minutes');
    return copyWith(meditationMinutes: meditationMinutes + minutes);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          photoUrl == other.photoUrl &&
          meditationMinutes == other.meditationMinutes &&
          sessionsCompleted == other.sessionsCompleted &&
          longestStreak == other.longestStreak &&
          currentStreak == other.currentStreak &&
          isPremium == other.isPremium;

  @override
  int get hashCode =>
      name.hashCode ^
      email.hashCode ^
      photoUrl.hashCode ^
      meditationMinutes.hashCode ^
      sessionsCompleted.hashCode ^
      longestStreak.hashCode ^
      currentStreak.hashCode ^
      isPremium.hashCode;

  // Safe parsing helpers
  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static String? _parseNullableString(dynamic value) {
    return value?.toString();
  }

  static int _parseInt(dynamic value) => (value is num ? value : 0).toInt();

  static bool _parseBool(dynamic value) => value is bool ? value : false;
}