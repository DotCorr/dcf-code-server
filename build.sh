#!/usr/bin/env bash
set -euo pipefail

# Automated build script for dcf-code-server
# This script builds code-server and creates release packages

echo "🔧 Building dcf-code-server..."
echo ""

# Check Node.js version
REQUIRED_NODE="22"
CURRENT_NODE=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)

if [ "$CURRENT_NODE" != "$REQUIRED_NODE" ]; then
  echo "❌ Node.js version mismatch!"
  echo "   Required: Node.js $REQUIRED_NODE"
  echo "   Current:  Node.js $CURRENT_NODE"
  echo ""
  echo "💡 Install Node.js 22:"
  echo "   nvm install 22"
  echo "   nvm use 22"
  echo "   # or"
  echo "   brew install node@22"
  exit 1
fi

echo "✅ Node.js version: $(node --version)"
echo ""

# Clean previous builds
echo "🧹 Cleaning previous builds..."
npm run clean || true

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Build VS Code (this takes a while)
echo "🔨 Building VS Code (this may take 30-60 minutes)..."
npm run build:vscode

# Build code-server
echo "🔨 Building code-server..."
npm run build

# Create release
echo "📦 Creating release package..."
npm run release

# Create standalone release
echo "📦 Creating standalone release..."
npm run release:standalone

# Build platform packages
echo "📦 Building platform-specific packages..."
npm run package

echo ""
echo "✅ Build complete!"
echo ""
echo "📁 Release packages are in: release-packages/"
echo "   Files ready to upload to GitHub:"
ls -lh release-packages/ | grep -E "\.(tar\.gz|zip)$" || echo "   (No packages found)"
echo ""
echo "📤 Next step: Upload files from release-packages/ to GitHub release"


