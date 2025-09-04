#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Starting Flutter web build for Netlify..."

# Check if Node.js is available
if ! command -v node >/dev/null 2>&1; then
  echo "📦 Node.js not found, using system Node.js..."
  # Netlify should provide Node.js automatically
fi

# Install or reuse Flutter SDK
if ! command -v flutter >/dev/null 2>&1; then
  if [ -d flutter-sdk ]; then
    echo "📦 Using cached Flutter SDK in flutter-sdk/"
  else
    echo "📦 Installing Flutter (3.35.2)..."
    git clone https://github.com/flutter/flutter.git -b 3.35.2 flutter-sdk
  fi
  export PATH="$PWD/flutter-sdk/bin:$PATH"
  flutter --version
else
  echo "✅ Flutter found: $(flutter --version)"
fi

# Configure Flutter for web
echo "⚙️ Configuring Flutter for web..."
flutter config --enable-web

# Clean and get dependencies
echo "🧹 Cleaning previous builds..."
flutter clean

echo "📚 Getting Flutter dependencies..."
flutter pub get

# Verify dependencies
echo "🔍 Verifying dependencies..."
flutter pub deps

# Create .env file from Netlify environment variables
echo "📝 Creating .env file from environment variables..."
cat > .env << EOF
# Supabase Configuration
SUPABASE_URL=${SUPABASE_URL:-https://zqcykjxwsnlxmtzcmiga.supabase.co}
SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY:-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpxY3lranh3c25seG10emNtaWdhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4NDI4MDgsImV4cCI6MjA3MjQxODgwOH0.dkH258TCMv4q7XXLknfnLNCJu1LVqEGdzabsh-0Oj7s}

# App Configuration
APP_NAME=${APP_NAME:-Graduate Assistant Hub}
APP_VERSION=${APP_VERSION:-1.0.0}
EOF

echo "✅ Environment variables configured"

# Build for web with specific renderer
echo "🔨 Building Flutter web app..."
flutter build web --release --web-renderer html --no-tree-shake-icons

echo "✅ Build completed successfully!"
echo "📁 Build output: build/web/"