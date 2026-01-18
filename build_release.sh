#!/bin/bash
# Build Release version of Boxer and prepare for distribution

set -e

echo "Building Boxer Release version..."

# Build the Release version
xcodebuild -project Boxer.xcodeproj \
  -scheme Boxer \
  -configuration Release \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  build

# Find the Release app
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData/Boxer-*/Build/Products/Release -name "Boxer.app" -type d 2>/dev/null | head -1)

if [ -z "$APP_PATH" ]; then
    echo "Error: Could not find Release app"
    exit 1
fi

echo "Found Release app at: $APP_PATH"

# Set environment variables for the copy script
export BUILT_PRODUCTS_DIR="$(dirname "$APP_PATH")"
export FRAMEWORKS_FOLDER_PATH="Boxer.app/Contents/Frameworks"
export SRCROOT="$(pwd)"

# Copy required dylibs
echo "Copying framework dylibs..."
bash copy_sdl_sound_dylib.sh

# Verify the app
echo ""
echo "Verifying app bundle..."
file "$APP_PATH/Contents/MacOS/Boxer"
ls -la "$APP_PATH/Contents/Frameworks/" | grep -E "dylib|framework" | head -10

echo ""
echo "✅ Release build complete!"
echo ""
echo "To install to Applications folder:"
echo "  cp -R \"$APP_PATH\" /Applications/"
echo ""
echo "Or drag and drop Boxer.app from:"
echo "  $APP_PATH"
echo ""
echo "To Applications folder in Finder"
