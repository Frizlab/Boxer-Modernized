# Framework Update Notes

All frameworks in the `Frameworks/` directory are currently 32-bit (i386) and need to be replaced with 64-bit versions for macOS 10.15+ compatibility.

## Required Framework Updates

### 1. SDL.framework → SDL2.framework
- **Current**: 32-bit SDL 1.2.14
- **Needed**: SDL2.framework (64-bit, universal - x86_64 and arm64)
- **Source**: https://www.libsdl.org/download-2.0.php or build from source
- **Status**: ⚠️ **YOU NEED TO GET THIS** - Download SDL2.framework and place in `Frameworks/` directory
- **Note**: Code has been updated to use SDL2 APIs:
  - `SDL_Init()` - removed `SDL_INIT_CDROM` and `SDL_INIT_NOPARACHUTE` (not in SDL2)
  - `SDL_OpenAudio()` → `SDL_OpenAudioDevice()` (SDL2 API)
  - `SDL_PauseAudio()` → `SDL_PauseAudioDevice()` (SDL2 API)
  - CD audio support removed (SDL2 doesn't support it)
  - All imports updated to `<SDL2/SDL.h>`

### 2. SDL_net.framework → SDL2_net.framework
- **Current**: 32-bit SDL_net 1.2 (includes PowerPC)
- **Needed**: SDL2_net.framework (64-bit, universal)
- **Source**: https://github.com/libsdl-org/SDL_net (build from source) or https://www.libsdl.org/projects/SDL_net/
- **Status**: ✅ Already have SDL2_net.framework in Frameworks/ (but need to verify it's 64-bit)
- **Note**: Code updated to use `<SDL2_net/SDL_net.h>`. SDL2_net API is compatible with SDL_net 1.2, so minimal code changes needed

### 3. SDL_sound.framework
- **Current**: 32-bit SDL_sound 1.0.x (for SDL 1.2)
- **Needed**: SDL_sound 2.0 (64-bit, for SDL2)
- **Source**: https://github.com/icculus/SDL_sound (version 2.0+)
- **Status**: ✅ Updated and working (v2.0.4, universal x86_64 + arm64)
- **Note**: SDL_sound 2.0 dropped SDL 1.2 support, so you need version 2.0+ which works with SDL2

### 4. Sparkle.framework
- **Current**: 32-bit old version
- **Needed**: Modern 64-bit Sparkle (2.x or later)
- **Source**: https://sparkle-project.org/
- **Note**: Modern Sparkle supports macOS 10.15+ and Apple Silicon

### 5. MT32Emu.framework
- **Current**: 32-bit
- **Needed**: 64-bit version
- **Source**: https://github.com/munt/munt or rebuild from source
- **Note**: May need to rebuild from source

### 6. DDHidLib.framework
- **Current**: 32-bit
- **Needed**: 64-bit version or alternative
- **Source**: May need to rebuild from source or find maintained fork
- **Note**: This is a third-party HID library. Consider IOKit alternatives if unavailable.

### 7. BGHUDAppKit.framework
- **Current**: 32-bit
- **Needed**: 64-bit version or alternative
- **Source**: May need to rebuild from source or find maintained fork
- **Note**: This provides HUD-style UI elements. May need to replace with modern AppKit alternatives.

## Building Universal Binaries

For Apple Silicon support, frameworks should ideally be universal binaries containing both x86_64 and arm64 architectures:
```bash
lipo -create -output UniversalFramework x86_64/Framework arm64/Framework
```

## Installation Steps

1. Download or build 64-bit versions of each framework
2. Replace the frameworks in `Frameworks/` directory
3. Update framework search paths in Xcode project if needed
4. Test build and fix any API compatibility issues
5. Update code if frameworks have breaking API changes (e.g., SDL1 → SDL2 - code already updated)

## What You Need To Do

### Step 1: Get SDL2.framework
You need to download or build SDL2.framework (64-bit, universal for x86_64 and arm64):

**Option A: Download prebuilt (if available)**
- Check https://www.libsdl.org/download-2.0.php
- Look for macOS framework downloads
- Ensure it's 64-bit (x86_64 and/or arm64)

**Option B: Build from source**
```bash
# Clone SDL2
git clone https://github.com/libsdl-org/SDL.git
cd SDL
mkdir build && cd build

# Configure for universal binary (x86_64 + arm64)
cmake .. -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
         -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15

# Build
cmake --build . --config Release

# The framework will be in build/SDL2.framework
# Copy it to your Frameworks/ directory
cp -R build/SDL2.framework /Users/daniel/projects/Boxer/Frameworks/
```

**Option C: Use Homebrew (then copy framework)**
```bash
brew install sdl2
# Framework location: /opt/homebrew/lib/SDL2.framework (Apple Silicon)
# or /usr/local/lib/SDL2.framework (Intel)
# Copy to your Frameworks/ directory
```

### Step 2: Verify SDL2_net.framework
Check that your existing SDL2_net.framework is 64-bit:
```bash
cd /Users/daniel/projects/Boxer
file Frameworks/SDL2_net.framework/Versions/A/SDL2_net
# Should show: Mach-O universal binary with 2 architectures: [x86_64] [arm64]
```

If it's not 64-bit, you'll need to build SDL2_net from source:
```bash
git clone https://github.com/libsdl-org/SDL_net.git
cd SDL_net
mkdir build && cd build
cmake .. -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
         -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
         -DSDL2_DIR=/path/to/SDL2
cmake --build . --config Release
# Copy SDL2_net.framework to Frameworks/
```

### Step 3: Update Xcode Project
After adding SDL2.framework, the Xcode project needs to be updated to reference it instead of SDL.framework. This will be done automatically when you open the project, or you can manually update the framework references in Xcode.

### Step 4: Build and Test
Try building the project - it should now link against SDL2 instead of SDL 1.2.
