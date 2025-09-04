#!/bin/bash
set -e

echo "🚀 Starting simple Flutter web build..."

# Install Flutter
git clone https://github.com/flutter/flutter.git -b 3.35.2 flutter-sdk
export PATH="$PWD/flutter-sdk/bin:$PATH"

# Configure and build
flutter config --enable-web
flutter clean
flutter pub get
flutter build web

echo "✅ Simple build completed!"