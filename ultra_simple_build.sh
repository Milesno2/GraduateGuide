#!/bin/bash
set -e

echo "🚀 Starting ultra-simple Flutter web build..."

# Install Flutter
git clone https://github.com/flutter/flutter.git -b 3.35.2 flutter-sdk
export PATH="$PWD/flutter-sdk/bin:$PATH"

# Build with environment variables
flutter config --enable-web
flutter clean
flutter pub get
flutter build web --release --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY --dart-define=APP_NAME=$APP_NAME

echo "✅ Ultra-simple build completed!"