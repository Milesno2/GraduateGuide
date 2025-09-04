#!/bin/bash
set -e

echo "🚀 Starting ultra-simple Flutter web build..."

# Install Flutter
git clone https://github.com/flutter/flutter.git -b 3.35.2 flutter-sdk
export PATH="$PWD/flutter-sdk/bin:$PATH"

# Build
flutter config --enable-web
flutter clean
flutter pub get
flutter build web --release

echo "✅ Ultra-simple build completed!"