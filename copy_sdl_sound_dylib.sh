#!/bin/bash
# Copy framework dylibs to app bundle Frameworks folder
# This script should be run as a build phase in Xcode

set -e

# Use Xcode build settings if available, otherwise try to infer
if [ -z "$BUILT_PRODUCTS_DIR" ]; then
    echo "Warning: BUILT_PRODUCTS_DIR not set, trying to find app bundle..."
    APP_FRAMEWORKS=""
else
    APP_FRAMEWORKS="${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}"
fi

if [ -z "$SRCROOT" ]; then
    SRCROOT="$(cd "$(dirname "$0")" && pwd)"
fi

# If APP_FRAMEWORKS is empty, try to find it
if [ -z "$APP_FRAMEWORKS" ] || [ ! -d "$APP_FRAMEWORKS" ]; then
    # Try to find the app bundle in common locations
    POSSIBLE_APP=$(find ~/Library/Developer/Xcode/DerivedData/Boxer-*/Build/Products -name "Boxer.app" -type d 2>/dev/null | head -1)
    if [ -n "$POSSIBLE_APP" ]; then
        APP_FRAMEWORKS="${POSSIBLE_APP}/Contents/Frameworks"
    else
        echo "Error: Could not find app bundle Frameworks directory"
        exit 1
    fi
fi

echo "Copying dylibs to: $APP_FRAMEWORKS"

# Copy SDL_sound dylib
SDL_SOUND_DYLIB="${SRCROOT}/Frameworks/SDL_sound.framework/Versions/A/SDL_sound"
if [ -f "$SDL_SOUND_DYLIB" ]; then
    cp "$SDL_SOUND_DYLIB" "${APP_FRAMEWORKS}/libSDL2_sound.2.dylib"
    install_name_tool -id @rpath/libSDL2_sound.2.dylib "${APP_FRAMEWORKS}/libSDL2_sound.2.dylib" 2>/dev/null || true
    echo "✅ Copied SDL_sound dylib to app bundle"
else
    echo "Warning: SDL_sound.framework not found at $SDL_SOUND_DYLIB"
fi

# Copy MT32Emu dylib
MT32EMU_DYLIB="${SRCROOT}/Frameworks/MT32Emu.framework/Versions/A/MT32Emu"
if [ -f "$MT32EMU_DYLIB" ]; then
    cp "$MT32EMU_DYLIB" "${APP_FRAMEWORKS}/libmt32emu.2.dylib"
    install_name_tool -id @rpath/libmt32emu.2.dylib "${APP_FRAMEWORKS}/libmt32emu.2.dylib" 2>/dev/null || true
    echo "✅ Copied MT32Emu dylib to app bundle"
else
    echo "Warning: MT32Emu.framework not found at $MT32EMU_DYLIB"
fi
