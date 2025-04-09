# App Icon Generation Guide

This document provides instructions for generating app icons for your Silent Moon meditation app.

## Required Icon Sizes

### iOS
- App Store: 1024x1024 pixels
- iPhone: 60x60, 120x120, 180x180 pixels
- iPad: 76x76, 152x152, 167x167 pixels
- Settings: 29x29, 58x58, 87x87 pixels
- Spotlight: 40x40, 80x80, 120x120 pixels

### Android
- Play Store: 512x512 pixels
- Launcher icons: 48x48, 72x72, 96x96, 144x144, 192x192 pixels
- Adaptive icons: 108x108 pixels (foreground and background layers)

## Design Guidelines

1. **Keep it simple**: The icon should be recognizable even at small sizes
2. **Use your brand colors**: Maintain consistency with your app's color scheme
3. **Avoid text**: Text is often illegible at smaller sizes
4. **Test at different sizes**: Ensure your icon looks good at all required dimensions
5. **Consider platform differences**: iOS icons are rounded squares, Android allows various shapes

## Recommended Tools

- **Adobe Illustrator/Photoshop**: Professional design tools
- **Figma/Sketch**: Modern design alternatives
- **App Icon Generators**:
  - [AppIcon.co](https://appicon.co/)
  - [MakeAppIcon](https://makeappicon.com/)
  - [Icon Kitchen](https://icon.kitchen/)

## Implementation Steps

### For Flutter

1. **iOS**: Place icons in `ios/Runner/Assets.xcassets/AppIcon.appiconset`
2. **Android**: Place icons in `android/app/src/main/res/mipmap-*` directories

### Using flutter_launcher_icons package

1. Add the package to `pubspec.yaml`:
   ```yaml
   dev_dependencies:
     flutter_launcher_icons: ^0.13.1
   ```

2. Configure icon settings in `pubspec.yaml`:
   ```yaml
   flutter_icons:
     android: true
     ios: true
     image_path: "assets/images/app_icon.png"
     adaptive_icon_background: "#FFFFFF" # For Android adaptive icons
     adaptive_icon_foreground: "assets/images/app_icon_foreground.png"
   ```

3. Run the package:
   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons
   ```

## Recommended Icon Design for Silent Moon

For the Silent Moon meditation app, consider using:

- A minimalist moon symbol with a gradient of purple to blue (matching your app's color scheme)
- A clean circular background
- No text elements
- Subtle shadow effects for depth

The icon should convey tranquility and mindfulness, aligning with your app's purpose.
