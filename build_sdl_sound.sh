#!/bin/bash
# Build script for SDL_sound 2.0 as a 64-bit universal framework

set -e  # Exit on error

echo "Building SDL_sound 2.0 for macOS (x86_64 + arm64)..."

# Clean up any previous build
cd /tmp
rm -rf SDL_sound SDL_sound_build

# Clone and checkout SDL_sound 2.0.4
echo "Cloning SDL_sound repository..."
git clone https://github.com/icculus/SDL_sound.git
cd SDL_sound
git checkout v2.0.4

# Create build directory
echo "Configuring build..."
mkdir -p build
cd build

# Configure CMake
cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
  -DCMAKE_PREFIX_PATH="/Users/daniel/projects/Boxer/Frameworks" \
  -DSDLSOUND_SHARED=ON \
  -DSDLSOUND_INSTALL=ON

# Build
echo "Building SDL_sound..."
cmake --build . --config Release

# Find the built library (SDL_sound 2.0 builds as libSDL2_sound.dylib)
BUILT_LIB=$(find . -name "libSDL2_sound.dylib" -o -name "libSDL_sound*.dylib" | head -1)
if [ -z "$BUILT_LIB" ]; then
    echo "Error: Could not find built library"
    echo "Searching for any dylib files..."
    find . -name "*.dylib" | head -5
    exit 1
fi

echo "Found built library: $BUILT_LIB"

# Create framework structure
echo "Creating framework structure..."
FRAMEWORK_DIR="/tmp/SDL_sound_build/SDL_sound.framework"
mkdir -p "$FRAMEWORK_DIR/Versions/A/Headers"
mkdir -p "$FRAMEWORK_DIR/Versions/A/Resources"

# Copy the library
cp "$BUILT_LIB" "$FRAMEWORK_DIR/Versions/A/SDL_sound"

# Copy headers
cp -R ../src/*.h "$FRAMEWORK_DIR/Versions/A/Headers/" 2>/dev/null || true

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
fi

# Verify the build
echo "Verifying build..."
file "$FRAMEWORK_DIR/Versions/A/SDL_sound"
lipo -info "$FRAMEWORK_DIR/Versions/A/SDL_sound"

echo ""
echo "Build complete! Framework is at: $FRAMEWORK_DIR"
echo "To install, run:"
echo "  cp -R $FRAMEWORK_DIR /Users/daniel/projects/Boxer/Frameworks/"
echo ""
echo "Or review the framework first before replacing the old one."
