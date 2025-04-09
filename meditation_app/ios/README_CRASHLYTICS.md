# Firebase Crashlytics Symbol Upload Guide

This document provides instructions on how to upload dSYM files to Firebase Crashlytics to improve crash reporting for your iOS app.

## Why Upload dSYMs?

When your app crashes in production, Firebase Crashlytics collects the crash reports and helps you diagnose the issue. However, without the debug symbol files (dSYMs), the crash reports will only show memory addresses rather than meaningful class names, method names, and line numbers.

## Using the Upload Script

A script has been created to simplify the process of uploading dSYMs to Firebase Crashlytics:

```bash
./upload_crashlytics_symbols.sh /path/to/dSYMs
```

### When to Run the Script

You should run this script:
1. After creating an App Store archive
2. After distributing the app through TestFlight
3. After any release build where you want proper crash reporting

## Manual Upload Command

If you need to upload dSYMs manually, you can use this command:

```bash
./ios/Pods/FirebaseCrashlytics/upload-symbols -gsp ./ios/Runner/GoogleService-Info.plist -p ios /path/to/dSYMs
```

## Finding dSYM Files

dSYM files are generated during the archiving process. They can typically be found:

1. In Xcode after archiving, in the Organizer window
2. In the archive file (right-click the archive in Organizer and select "Show in Finder")
3. In `~/Library/Developer/Xcode/Archives`

To extract dSYMs from an archive:
1. Right-click the .xcarchive file in Finder
2. Select "Show Package Contents"
3. Navigate to dSYMs folder

## Troubleshooting

If you encounter issues with symbol upload:

1. Make sure Firebase Crashlytics is properly configured in your project
2. Verify that the GoogleService-Info.plist file is in the correct location
3. Ensure you have the correct path to your dSYM files
4. Check that the upload-symbols script is executable (`chmod +x upload-symbols`)

## Additional Resources

- [Firebase Crashlytics Documentation](https://firebase.google.com/docs/crashlytics)
- [iOS dSYM Upload Guide](https://firebase.google.com/docs/crashlytics/get-deobfuscated-reports) 