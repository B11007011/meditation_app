# Silent Moon Meditation App

A Flutter meditation application designed to help users practice mindfulness, reduce stress, and improve sleep.

## Features

- **Meditation Sessions**: Guided and unguided meditation sessions with various themes
- **Sleep Stories**: Peaceful bedtime stories to help users fall asleep
- **Background Music**: Calming sounds and music for meditation and relaxation
- **User Profiles**: Track progress and statistics of meditation practice
- **Reminders**: Set reminders for meditation practice
- **Offline Functionality**: Download meditations for offline use

## Project Structure

The project follows a feature-based architecture:

```
lib/
├── features/
│   ├── auth/            # Authentication related code
│   ├── home/            # Home screen related code 
│   ├── meditation/      # Meditation features
│   ├── music/           # Music player features
│   ├── profile/         # User profile features
│   ├── sleep/           # Sleep stories features
│   └── splash/          # Splash screen
├── shared/              # Shared code across features
│   ├── adapters/        # Hive adapters
│   ├── providers/       # Riverpod providers
│   ├── services/        # Common services
│   └── theme/           # App theming
└── main.dart            # Application entry point
```

## Firebase Integration

This project uses several Firebase services:

- **Firebase Authentication**: User authentication with email/password and social logins
- **Firebase Firestore**: Store and sync meditation and user data
- **Firebase Storage**: Store media files like audio and images
- **Firebase Crashlytics**: Track and fix crashes in real-time

### Crashlytics Setup

Firebase Crashlytics is integrated to help identify and fix crashes quickly. The app includes:

1. Automatic crash reporting
2. Manual error logging
3. User identifiers for better crash debugging
4. Custom keys for additional context

#### Debug Symbol Uploads

For proper iOS crash reporting, debug symbols (dSYMs) need to be uploaded to Firebase:

1. Archive your app in Xcode
2. Run the provided script to upload dSYMs:

```bash
./ios/upload_crashlytics_symbols.sh /path/to/dSYMs
```

For more details, see [iOS/README_CRASHLYTICS.md](ios/README_CRASHLYTICS.md).

## Data Storage

The app uses Hive for local data persistence:

- User profiles
- Meditation history
- Downloaded content
- App settings

## Development

### Prerequisites

- Flutter (2.10.0 or higher)
- Dart (2.16.0 or higher)
- Firebase project setup

### Getting Started

1. Clone the repository
2. Install dependencies:
   ```
   flutter pub get
   ```
3. Run the app:
   ```
   flutter run
   ```

### Build for Production

#### Android

```bash
flutter build appbundle
```

#### iOS

```bash
flutter build ios
```
Then open the Xcode workspace and archive from Xcode.

## Troubleshooting

### Hive Adapter Issues

If you encounter Hive-related errors, make sure all adapters are properly registered:

```dart
// Register adapters with explicit typeIds
Hive.registerAdapter(UserProfileAdapter());   // typeId: 3
Hive.registerAdapter(MeditationAdapter());    // typeId: 5
Hive.registerAdapter(DurationAdapter());      // typeId: 4
Hive.registerAdapter(DateTimeAdapter());      // typeId: 33
```

flutter pub run build_runner build --delete-conflicting-outputs

 flutter run -d macos 

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements
- Design inspiration from various meditation apps
- Open-source Flutter packages that made this project possible
