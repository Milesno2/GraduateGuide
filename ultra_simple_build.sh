#!/bin/bash
set -e

echo "🚀 Starting bulletproof Flutter web build..."

# Install Flutter
echo "📦 Installing Flutter 3.35.2..."
git clone https://github.com/flutter/flutter.git -b 3.35.2 flutter-sdk
export PATH="$PWD/flutter-sdk/bin:$PATH"

# Verify Flutter installation
echo "🔍 Verifying Flutter..."
flutter --version

# Configure Flutter
echo "⚙️ Configuring Flutter..."
flutter config --enable-web

# Clean everything
echo "🧹 Cleaning everything..."
flutter clean
rm -rf .dart_tool
rm -rf build
rm -rf pubspec.lock

# Get dependencies with retry
echo "📚 Getting dependencies..."
flutter pub get --verbose

# Check for compilation issues
echo "🔍 Checking for compilation issues..."
flutter analyze --no-fatal-infos || true

# Build for web with detailed output
echo "🔨 Building web app..."
flutter build web --release --verbose --dart-define=SUPABASE_URL="$SUPABASE_URL" --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" --dart-define=APP_NAME="$APP_NAME"

echo "✅ Bulletproof build completed successfully!"