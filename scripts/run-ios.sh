#!/bin/bash
set -ex
cd ios

SCHEME="{{ project-name | capitalize }}"
APP_NAME="{{ project-name | capitalize }}"
BUNDLE_ID="com.rmp.{{ project-name | downcase }}.{{ project-name | capitalize }}" # FIXME: why the extra .Counter?
DESTINATION='platform=iOS Simulator,name=iPhone 16 Pro,OS=latest'

# Build the app
xcodebuild -scheme "$SCHEME" -destination "$DESTINATION" build

# Find the built app
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "$APP_NAME.app" | head -n 1)

if [ -z "$APP_PATH" ]; then
    echo "App not found!"
    exit 1
fi

# Install the app on the simulator
xcrun simctl install booted "$APP_PATH"

# Launch the app
xcrun simctl launch booted "$BUNDLE_ID"