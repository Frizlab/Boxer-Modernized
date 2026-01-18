#!/bin/bash
# Create framework from already-built SDL_sound library

set -e

BUILD_DIR="/tmp/SDL_sound/build"
FRAMEWORK_DIR="/tmp/SDL_sound_build/SDL_sound.framework"

# Find the built library
BUILT_LIB="$BUILD_DIR/libSDL2_sound.dylib"
if [ ! -f "$BUILT_LIB" ]; then
    echo "Error: Could not find built library at $BUILT_LIB"
    echo "Looking for dylib files..."
    find "$BUILD_DIR" -name "*.dylib" | head -5
    exit 1
fi

echo "Found built library: $BUILT_LIB"

# Create framework structure
echo "Creating framework structure..."
mkdir -p "$FRAMEWORK_DIR/Versions/A/Headers"
mkdir -p "$FRAMEWORK_DIR/Versions/A/Resources"

# Copy the library
cp "$BUILT_LIB" "$FRAMEWORK_DIR/Versions/A/SDL_sound"

# Copy headers
echo "Copying headers..."
cp -R /tmp/SDL_sound/src/*.h "$FRAMEWORK_DIR/Versions/A/Headers/" 2>/dev/null || true

# Create symlinks
cd "$FRAMEWORK_DIR"
ln -sf Versions/A/SDL_sound SDL_sound
ln -sf Versions/A/Headers Headers
ln -sf Versions/A/Resources Resources
cd Versions
ln -sf A Current
cd ../..

# Copy Ogg and Vorbis frameworks from existing SDL_sound
echo "Copying Ogg and Vorbis frameworks..."
if [ -d "/Users/daniel/projects/Boxer/Frameworks/SDL_sound.framework/Versions/A/Frameworks" ]; then
    cp -R "/Users/daniel/projects/Boxer/Frameworks/SDL_sound.framework/Versions/A/Frameworks" "$FRAMEWORK_DIR/Versions/A/"
    echo "Copied Ogg and Vorbis frameworks"
else
    echo "Warning: Could not find Ogg/Vorbis frameworks to copy"
fi

# Verify the build
echo ""
echo "Verifying build..."
file "$FRAMEWORK_DIR/Versions/A/SDL_sound"
lipo -info "$FRAMEWORK_DIR/Versions/A/SDL_sound"

echo ""
echo "Framework created at: $FRAMEWORK_DIR"
echo ""
echo "To install, run:"
echo "  cp -R $FRAMEWORK_DIR /Users/daniel/projects/Boxer/Frameworks/"
echo ""
echo "This will replace your old SDL_sound.framework"
