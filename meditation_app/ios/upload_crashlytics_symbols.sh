#!/bin/bash

# Script to upload dSYMs to Firebase Crashlytics

# Path to the upload-symbols script
UPLOAD_SYMBOLS_PATH="./ios/Pods/FirebaseCrashlytics/upload-symbols"

# Path to GoogleService-Info.plist
GOOGLE_SERVICE_INFO_PATH="./ios/Runner/GoogleService-Info.plist"

# Path to dSYMs folder - this will be an argument
DSYMS_PATH="$1"

# Verify that the upload-symbols script exists
if [ ! -f "$UPLOAD_SYMBOLS_PATH" ]; then
    echo "Error: upload-symbols script not found at $UPLOAD_SYMBOLS_PATH"
    exit 1
fi

# Verify that the GoogleService-Info.plist exists
if [ ! -f "$GOOGLE_SERVICE_INFO_PATH" ]; then
    echo "Error: GoogleService-Info.plist not found at $GOOGLE_SERVICE_INFO_PATH"
    exit 1
fi

# Verify that a dSYM path was provided
if [ -z "$DSYMS_PATH" ]; then
    echo "Error: No dSYM path provided."
    echo "Usage: $0 /path/to/dSYMs"
    exit 1
fi

# Verify that the dSYM path exists
if [ ! -d "$DSYMS_PATH" ]; then
    echo "Error: dSYM directory not found at $DSYMS_PATH"
    exit 1
fi

# Print information
echo "Uploading dSYMs to Firebase Crashlytics..."
echo "dSYM location: $DSYMS_PATH"

# Execute the upload-symbols command
"$UPLOAD_SYMBOLS_PATH" -gsp "$GOOGLE_SERVICE_INFO_PATH" -p ios "$DSYMS_PATH"

# Check the result
if [ $? -eq 0 ]; then
    echo "dSYMs uploaded successfully."
else
    echo "Failed to upload dSYMs."
    exit 1
fi 