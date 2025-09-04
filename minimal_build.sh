#!/bin/bash
set -e

echo "🚀 Starting minimal Flutter web build..."

# Ensure a clean workspace
rm -rf flutter-sdk
rm -rf .dart_tool
rm -rf build
rm -f pubspec.lock

# Install Flutter
git clone https://github.com/flutter/flutter.git -b 3.35.2 flutter-sdk
export PATH="$PWD/flutter-sdk/bin:$PATH"

# Build
flutter config --enable-web
flutter clean
flutter pub get
flutter build web

echo "✅ Minimal build completed!"