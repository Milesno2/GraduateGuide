#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Starting Flutter web build for Netlify..."

# Install or reuse Flutter SDK
if ! command -v flutter >/dev/null 2>&1; then
  if [ -d flutter-sdk ]; then
    echo "📦 Using cached Flutter SDK in flutter-sdk/"
  else
    echo "📦 Installing Flutter (stable)..."
    git clone https://github.com/flutter/flutter.git -b stable flutter-sdk
  fi
  export PATH="$PWD/flutter-sdk/bin:$PATH"
  flutter --version
else
  echo "✅ Flutter found: $(flutter --version)"
fi

# Configure Flutter for web
echo "⚙️ Configuring Flutter for web..."
flutter config --enable-web

# Get dependencies
echo "📚 Getting Flutter dependencies..."
flutter pub get

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Build for web
echo "🔨 Building Flutter web app..."
flutter build web --release --web-renderer html

echo "✅ Build completed successfully!"
echo "📁 Build output: build/web/"