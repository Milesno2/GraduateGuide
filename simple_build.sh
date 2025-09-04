#!/usr/bin/env bash
set -e

echo "🚀 Starting simplified Flutter web build..."

# Install Flutter
echo "📦 Installing Flutter 3.35.2..."
git clone https://github.com/flutter/flutter.git -b 3.35.2 flutter-sdk
export PATH="$PWD/flutter-sdk/bin:$PATH"

# Verify Flutter
echo "🔍 Verifying Flutter..."
flutter --version

# Create .env file
echo "📝 Creating .env file..."
cat > .env << EOF
SUPABASE_URL=${SUPABASE_URL:-https://zqcykjxwsnlxmtzcmiga.supabase.co}
SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY:-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpxY3lranh3c25seG10emNtaWdhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4NDI4MDgsImV4cCI6MjA3MjQxODgwOH0.dkH258TCMv4q7XXLknfnLNCJu1LVqEGdzabsh-0Oj7s}
APP_NAME=${APP_NAME:-Graduate Assistant Hub}
APP_VERSION=${APP_VERSION:-1.0.0}
EOF

# Configure Flutter
echo "⚙️ Configuring Flutter..."
flutter config --enable-web

# Clean and get dependencies
echo "🧹 Cleaning..."
flutter clean

echo "📚 Getting dependencies..."
flutter pub get

# Build for web
echo "🔨 Building web app..."
flutter build web --release --no-tree-shake-icons

echo "✅ Build completed successfully!"