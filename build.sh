#!/usr/bin/env bash
set -e

echo "🚀 Building Flutter web app..."

# Install Flutter if not available
if ! command -v flutter >/dev/null 2>&1; then
  echo "📦 Installing Flutter..."
  git clone https://github.com/flutter/flutter.git -b 3.35.2 flutter-sdk
  export PATH="$PWD/flutter-sdk/bin:$PATH"
fi

# Configure and build
flutter config --enable-web
flutter clean
flutter pub get
flutter build web --release

echo "✅ Build completed!"