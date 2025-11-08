#!/usr/bin/env bash
# Quick script to check build status and show where release files are

cd "$(dirname "$0")"

echo "📊 Build Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if VS Code build is complete
if [ -d "lib/vscode-reh-web-linux-x64" ]; then
  echo "✅ VS Code build: COMPLETE"
else
  if ps aux | grep -q "[g]ulp.*vscode-reh"; then
    echo "⏳ VS Code build: RUNNING"
  else
    echo "❌ VS Code build: NOT STARTED or FAILED"
  fi
fi

# Check if code-server is built
if [ -d "out" ] && [ -f "out/node/entry.js" ]; then
  echo "✅ code-server build: COMPLETE"
else
  echo "⏳ code-server build: NOT STARTED"
fi

# Check if release packages exist
if [ -d "release-packages" ] && [ "$(ls -A release-packages/*.{tar.gz,zip} 2>/dev/null | wc -l)" -gt 0 ]; then
  echo "✅ Release packages: READY"
  echo ""
  echo "📁 Release files location:"
  echo "   $(pwd)/release-packages/"
  echo ""
  echo "📦 Files ready for GitHub release:"
  ls -lh release-packages/*.{tar.gz,zip} 2>/dev/null | awk '{print "   " $9 " (" $5 ")"}'
else
  echo "⏳ Release packages: NOT READY"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

