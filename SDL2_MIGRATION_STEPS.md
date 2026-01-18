# SDL2 Migration - What You Need To Do

## ✅ Code Changes Complete

All code has been updated to use SDL2 instead of SDL 1.2:
- ✅ Imports changed to `<SDL2/SDL.h>` and `<SDL2_net/SDL_net.h>`
- ✅ Audio API updated: `SDL_OpenAudioDevice()`, `SDL_PauseAudioDevice()`
- ✅ Removed CD audio support (SDL2 doesn't support it)
- ✅ Updated SDL_Init() calls (removed deprecated flags)

## 📋 What You Need To Do

### 1. Get SDL2.framework (REQUIRED)

You need a 64-bit SDL2.framework (universal binary with x86_64 and arm64).

**Option A: Download Prebuilt (Easiest)**
1. Visit https://www.libsdl.org/download-2.0.php
2. Look for "macOS" or "Framework" downloads
3. Download SDL2.framework
4. Verify it's 64-bit:
   ```bash
   file SDL2.framework/SDL2
   # Should show: Mach-O universal binary with 2 architectures: [x86_64] [arm64]
   ```
5. Copy to your Frameworks directory:
   ```bash
   cp -R SDL2.framework /Users/daniel/projects/Boxer/Frameworks/
   ```

**Option B: Build from Source**
```bash
# Clone SDL2 repository
git clone https://github.com/libsdl-org/SDL.git
cd SDL
mkdir build && cd build

# Configure for universal binary
cmake .. -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
         -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15

# Build
cmake --build . --config Release

# Copy framework to your project
cp -R SDL2.framework /Users/daniel/projects/Boxer/Frameworks/
```

**Option C: Use Homebrew (Then Copy)**
```bash
# Install SDL2 via Homebrew
brew install sdl2

# Find the framework location
# Apple Silicon: /opt/homebrew/lib/SDL2.framework
# Intel: /usr/local/lib/SDL2.framework

# Copy to your project
cp -R /opt/homebrew/lib/SDL2.framework /Users/daniel/projects/Boxer/Frameworks/
# OR
cp -R /usr/local/lib/SDL2.framework /Users/daniel/projects/Boxer/Frameworks/
```

### 2. Verify SDL2_net.framework

Check that your existing SDL2_net.framework is 64-bit:
```bash
cd /Users/daniel/projects/Boxer
file Frameworks/SDL2_net.framework/Versions/A/SDL2_net
```

**Expected output:**
```
Mach-O universal binary with 2 architectures: [x86_64:Mach-O 64-bit dynamically linked shared library x86_64] [arm64:Mach-O 64-bit dynamically linked shared library arm64]
```

**If it's NOT 64-bit**, you'll need to build SDL2_net from source:
```bash
git clone https://github.com/libsdl-org/SDL_net.git
cd SDL_net
mkdir build && cd build

# Point to your SDL2 installation
cmake .. -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
         -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
         -DSDL2_DIR=/path/to/SDL2/build

cmake --build . --config Release

# Copy to Frameworks
cp -R SDL2_net.framework /Users/daniel/projects/Boxer/Frameworks/
```

### 3. Update Xcode Project

After adding SDL2.framework, you need to update the Xcode project:

1. Open `Boxer.xcodeproj` in Xcode
2. In the Project Navigator, find `Frameworks` group
3. Remove the old `SDL.framework` reference (if it's still there)
4. Add `SDL2.framework`:
   - Right-click on `Frameworks` folder
   - Select "Add Files to Boxer..."
   - Navigate to `Frameworks/SDL2.framework`
   - Make sure "Copy items if needed" is **unchecked** (it's already in the right place)
   - Click "Add"
5. In Build Phases:
   - Remove `SDL.framework` from "Link Binary With Libraries"
   - Add `SDL2.framework` to "Link Binary With Libraries"
   - Remove `SDL.framework` from "Copy Bundle Resources" (if present)
   - Add `SDL2.framework` to "Copy Bundle Resources" (if needed)

### 4. Build and Test

Try building the project:
```bash
cd /Users/daniel/projects/Boxer
xcodebuild -project Boxer.xcodeproj -scheme Boxer -configuration Debug build
```

If you get linker errors about missing SDL2 symbols, make sure:
- SDL2.framework is in the Frameworks directory
- SDL2.framework is added to "Link Binary With Libraries" in Xcode
- Framework search paths include the Frameworks directory

## 📝 Summary of Changes Made

### Code Files Updated:
- `Boxer/BXEmulator.mm` - Updated SDL imports and SDL_Init()
- `Boxer/BXEmulator+BXAudio.mm` - Updated audio pause/resume to use SDL_PauseAudioDevice()
- `Boxer/BXEmulator+BXDOSFileSystem.mm` - Removed SDL CD audio checks
- `DOSBox/include/SDL.h` - Updated to import SDL2
- `DOSBox/include/SDL_net.h` - Updated to import SDL2_net
- `DOSBox/src/hardware/mixer.cpp` - Updated to use SDL_OpenAudioDevice() and SDL_PauseAudioDevice()

### API Changes:
- `SDL_Init()` - Removed `SDL_INIT_CDROM` and `SDL_INIT_NOPARACHUTE` flags
- `SDL_OpenAudio()` → `SDL_OpenAudioDevice()`
- `SDL_PauseAudio()` → `SDL_PauseAudioDevice()`
- CD audio functions removed (SDL_CDNumDrives, etc.)

## ⚠️ Remaining Work

After you add SDL2.framework, you'll still need to update:
- SDL_sound.framework (needs SDL_sound 2.0 for SDL2)
- Other frameworks (Sparkle, MT32Emu, DDHidLib, BGHUDAppKit) - see FRAMEWORK_UPDATE_NOTES.md

But SDL2 and SDL2_net are the critical ones to get the project building.
