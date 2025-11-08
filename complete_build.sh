#!/usr/bin/env bash
set -euo pipefail

# Complete build script that waits for VS Code build and finishes everything
# This script will:
# 1. Wait for VS Code build to complete (check for lib/vscode-reh-web-linux-x64)
# 2. Build code-server
# 3. Create release packages
# 4. Show where release files are located

export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

cd "$(dirname "$0")"

echo "🔍 Checking VS Code build status..."
echo ""

# Wait for VS Code build to complete
MAX_WAIT=7200  # 2 hours max
WAIT_INTERVAL=30  # Check every 30 seconds
ELAPSED=0

while [ ! -d "lib/vscode-reh-web-linux-x64" ]; do
  if [ $ELAPSED -ge $MAX_WAIT ]; then
    echo "❌ VS Code build timeout! Please check build logs."
    exit 1
  fi
  
  if [ $ELAPSED -eq 0 ]; then
    echo "⏳ Waiting for VS Code build to complete..."
    echo "   (This can take 30-60 minutes)"
  fi
  
  sleep $WAIT_INTERVAL
  ELAPSED=$((ELAPSED + WAIT_INTERVAL))
  
  # Show progress every 5 minutes
  if [ $((ELAPSED % 300)) -eq 0 ]; then
    echo "   ⏱️  Waited $((ELAPSED / 60)) minutes..."
  fi
done

echo "✅ VS Code build complete!"
echo ""

# Build code-server
echo "🔨 Building code-server..."
npm run build

# Create release
echo "📦 Creating release package..."
export VERSION="1.0.0"
npm run release

# Create standalone release
echo "📦 Creating standalone release..."
npm run release:standalone

# Build platform-specific packages
echo "📦 Building platform-specific packages..."
npm run package

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ BUILD COMPLETE!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📁 RELEASE FILES LOCATION:"
echo "   $(pwd)/release-packages/"
echo ""
echo "📦 Files ready for GitHub release:"
ls -lh release-packages/*.{tar.gz,zip} 2>/dev/null | awk '{print "   " $9 " (" $5 ")"}' || echo "   (No packages found)"
echo ""
echo "📤 Next steps:"
echo "   1. Go to: https://github.com/DotCorr/dcf-code-server/releases/new"
echo "   2. Create a new release tag (e.g., v1.0.0)"
echo "   3. Upload all files from: $(pwd)/release-packages/"
echo "   4. Publish the release"
echo ""
echo "💡 The CLI will automatically download from your fork's releases!"
echo ""

