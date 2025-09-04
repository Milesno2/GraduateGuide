#!/bin/bash
set -e

echo "🚀 Starting Flutter web build..."

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

# Clean and get dependencies
echo "🧹 Cleaning..."
flutter clean

echo "📚 Getting dependencies..."
flutter pub get

# Check for compilation issues
echo "🔍 Checking for compilation issues..."
flutter analyze --no-fatal-infos || true

# Build for web with detailed output
echo "🔨 Building web app..."
flutter build web --release --verbose

echo "✅ Build completed successfully!"