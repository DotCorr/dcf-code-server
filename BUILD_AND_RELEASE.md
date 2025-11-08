# Building and Releasing dcf-code-server

## Quick Build Guide

### Prerequisites
- Node.js 22.x
- npm
- Git

### Step 1: Build code-server

```bash
cd ide/dcf-code-server

# Install dependencies
npm install

# Build VS Code (this takes a while)
npm run build:vscode

# Build code-server
npm run build

# Create release package
npm run release

# Build standalone releases for each platform
npm run release:standalone
```

### Step 2: Build Platform-Specific Packages

The build process creates files in `release-packages/` directory:

```bash
# The build-packages.sh script creates:
# - code-server-VERSION-linux-x64.tar.gz
# - code-server-VERSION-linux-arm64.tar.gz
# - code-server-VERSION-darwin-x64.tar.gz
# - code-server-VERSION-darwin-arm64.tar.gz
# - code-server-VERSION-windows-x64.zip

# Build packages (this uses the standalone release)
./ci/build/build-packages.sh
```

### Step 3: Create GitHub Release

1. Go to: https://github.com/DotCorr/dcf-code-server/releases/new
2. Tag version: `v4.104.1` (or your version)
3. Upload all files from `release-packages/`:
   - `code-server-*-darwin-x64.tar.gz`
   - `code-server-*-darwin-arm64.tar.gz`
   - `code-server-*-linux-x64.tar.gz`
   - `code-server-*-linux-arm64.tar.gz`
   - `code-server-*-windows-x64.zip`
4. Publish release

### Step 4: CLI Auto-Detection

The CLI will automatically:
1. Check for `dcf-code-server` releases first
2. Download the correct binary for user's platform
3. Use your custom build instead of standard code-server
4. Fall back to standard code-server if no release found

## Build Commands Reference

```bash
# Clean previous builds
npm run clean

# Build VS Code (required first)
npm run build:vscode

# Build code-server
npm run build

# Create NPM release package
npm run release

# Create standalone release (includes Node.js)
npm run release:standalone

# Build platform-specific packages
npm run package
# or
./ci/build/build-packages.sh

# Build for specific architecture (Linux ARM64 cross-compile)
./ci/build/build-packages.sh arm64
```

## File Locations

- `release/` - NPM package (generic)
- `release-standalone/` - Standalone release (includes Node.js)
- `release-packages/` - Platform-specific archives (what you upload to GitHub)

## Testing

After creating a release:
1. Delete `~/.dcf-ide` directory
2. Run `dcf go` and press `c`
3. CLI should download your custom build

