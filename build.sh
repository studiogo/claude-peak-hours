#!/bin/bash
set -e

APP_NAME="Claude Peak Hours"
BUNDLE_NAME="ClaudePeakHours"
BUILD_DIR="build"
APP_DIR="$BUILD_DIR/$APP_NAME.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

SRC_DIR="ClaudePeakHours"

echo "🔨 Building $APP_NAME..."

# Clean
rm -rf "$BUILD_DIR"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"

# Compile
swiftc \
    -target arm64-apple-macos13.0 \
    -sdk $(xcrun --show-sdk-path) \
    -O \
    -o "$MACOS_DIR/$BUNDLE_NAME" \
    "$SRC_DIR/main.swift" \
    "$SRC_DIR/PeakHoursManager.swift" \
    "$SRC_DIR/PopoverView.swift" \
    "$SRC_DIR/AppDelegate.swift" \
    "$SRC_DIR/Strings.swift" \
    -framework Cocoa \
    -framework SwiftUI \
    -framework UserNotifications \
    -framework ServiceManagement \
    -framework Combine

# Copy Info.plist
cp "$SRC_DIR/Info.plist" "$CONTENTS_DIR/Info.plist"

# Sign the app (required for notifications)
codesign --force --sign - --entitlements "$SRC_DIR/ClaudePeakHours.entitlements" "$APP_DIR"

echo "✅ Built: $APP_DIR"
echo ""
echo "To run: open \"$APP_DIR\""
echo "To install: cp -r \"$APP_DIR\" /Applications/"
