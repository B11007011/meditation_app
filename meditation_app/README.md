# Silent Moon Meditation App

## Overview
Silent Moon is a meditation and mindfulness app designed to help users reduce stress, improve focus, and enhance their overall well-being. The app offers guided meditations, sleep stories, and relaxing music to help users find peace in their daily lives.

## Features
- **Guided Meditations**: Various meditation sessions categorized by duration and purpose
- **Meditation Playback**: Play, pause, and resume meditation audio with progress tracking
- **Offline Content**: Download meditations for offline use
- **Sleep Stories**: Calming narratives to help users fall asleep
- **Music**: Relaxing sounds and music for focus and relaxation
- **User Profiles**: Track meditation progress and statistics
- **Reminders**: Set meditation reminders to build a consistent practice
- **Analytics**: Track user engagement and app usage

## Technical Details

### Built With
- Flutter framework for cross-platform development
- Firebase Authentication for user management
- Firebase Analytics for usage tracking
- Hive for local data persistence
- Provider pattern for state management
- AudioPlayers for meditation audio playback

### Requirements
- Flutter 3.1.0 or higher
- Dart 3.1.3 or higher
- Firebase project setup

## Getting Started

### Installation
1. Clone the repository
   ```
   git clone https://github.com/yourusername/meditation_app.git
   ```

2. Install dependencies
   ```
   flutter pub get
   ```

3. Run the app
   ```
   flutter run
   ```

### Firebase Setup
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android and iOS apps to your Firebase project
3. Download and add the configuration files (google-services.json for Android, GoogleService-Info.plist for iOS)
4. Enable Authentication methods (Email/Password, Google, Facebook)

## Testing
Run the automated tests to verify the app's functionality:

```
flutter test
```

The test suite includes:
- Widget tests for UI components
- Unit tests for the meditation repository
- Unit tests for the meditation player service

## Publishing Checklist
- [x] Update app icons and splash screens
- [x] Implement meditation playback functionality
- [x] Add offline content storage
- [x] Implement analytics for user engagement tracking
- [x] Create privacy policy
- [x] Create comprehensive test plan
- [ ] Complete all TODOs in the codebase
- [ ] Test on multiple devices and screen sizes
- [ ] Prepare app store screenshots and descriptions
- [ ] Set up in-app purchases for premium content

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements
- Design inspiration from various meditation apps
- Open-source Flutter packages that made this project possible
