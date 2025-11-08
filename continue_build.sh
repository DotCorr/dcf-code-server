#!/usr/bin/env bash
# Continue build after VS Code is built
# Run this after build:vscode completes

export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

cd "$(dirname "$0")"

echo "🔨 Building code-server..."
npm run build

echo "📦 Creating release package..."
npm run release

echo "📦 Creating standalone release..."
npm run release:standalone

echo "📦 Building platform-specific packages..."
npm run package

echo ""
echo "✅ Build complete!"
echo ""
echo "📁 Release packages are in: release-packages/"
ls -lh release-packages/ 2>/dev/null | grep -E "\.(tar\.gz|zip)$" || echo "   (No packages found yet)"

