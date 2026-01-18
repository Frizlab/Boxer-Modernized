# SDL_sound 2.0 Build Instructions

SDL_sound is the last framework that needs to be updated to 64-bit. The current version in `Frameworks/SDL_sound.framework` is 32-bit only (i386).

**Note:** SDL_sound is used by DOSBox for CD audio image support (playing audio tracks from CD image files like .cue/.bin).

## Option 1: Build from Source (Recommended)

SDL_sound 2.0 works with SDL2. Here's how to build it as a universal 64-bit framework:

### Prerequisites
- Xcode with command-line tools
- CMake (install via `brew install cmake` if needed)
- SDL2.framework (already in your project)

### Build Steps

1. **Clone SDL_sound 2.0 source:**
   ```bash
   cd /tmp
   git clone https://github.com/icculus/SDL_sound.git
   cd SDL_sound
   git checkout v2.0.4
   ```

2. **Create build directory:**
   ```bash
   mkdir build
   cd build
   ```

3. **Configure for universal 64-bit build:**
   
   First, find where SDL2 is installed. If you have SDL2.framework in your project:
   ```bash
   SDL2_FRAMEWORK_PATH="/Users/daniel/projects/Boxer/Frameworks/SDL2.framework"
   ```
   
   Then configure:
   ```bash
   cmake .. \
     -DCMAKE_BUILD_TYPE=Release \
     -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
     -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
     -DSDL2_DIR="$SDL2_FRAMEWORK_PATH" \
     -DSDLSOUND_INSTALL=ON \
     -DSDLSOUND_SHARED=ON
   ```

   **Note:** If CMake can't find SDL2:
   - Try: `-DCMAKE_PREFIX_PATH="/Users/daniel/projects/Boxer/Frameworks"`
   - Or: `-DSDL2_INCLUDE_DIR="$SDL2_FRAMEWORK_PATH/Headers" -DSDL2_LIBRARY="$SDL2_FRAMEWORK_PATH/SDL2"`

4. **Build:**
   ```bash
   cmake --build . --config Release
   ```

5. **Create Framework Structure:**
   
   SDL_sound may not build as a framework by default. You may need to manually create the framework structure:
   
   ```bash
   # Find the built library (usually in the build directory)
   BUILT_LIB=$(find . -name "libSDL_sound*.dylib" -o -name "SDL_sound*.dylib" | head -1)
   
   # Create framework directory structure
   mkdir -p SDL_sound.framework/Versions/A/Headers
   mkdir -p SDL_sound.framework/Versions/A/Resources
   
   # Copy the library
   cp "$BUILT_LIB" SDL_sound.framework/Versions/A/SDL_sound
   
   # Copy headers from source
   cp -R ../src/*.h SDL_sound.framework/Versions/A/Headers/
   
   # Create symlinks
   cd SDL_sound.framework
   ln -sf Versions/A/SDL_sound SDL_sound
   ln -sf Versions/A/Headers Headers
   ln -sf Versions/A/Resources Resources
   cd Versions
   ln -sf A Current
   cd ../..
   ```
   
   **Note:** Your existing SDL_sound.framework also includes Ogg and Vorbis frameworks. You may need to:
   - Copy those from the old framework: `cp -R /Users/daniel/projects/Boxer/Frameworks/SDL_sound.framework/Versions/A/Frameworks SDL_sound.framework/Versions/A/`
   - Or rebuild them as 64-bit as well if they're also 32-bit

7. **Replace old framework:**
   ```bash
   cp -R SDL_sound.framework /Users/daniel/projects/Boxer/Frameworks/
   ```

8. **Verify it's 64-bit:**
   ```bash
   file /Users/daniel/projects/Boxer/Frameworks/SDL_sound.framework/Versions/A/SDL_sound
   lipo -info /Users/daniel/projects/Boxer/Frameworks/SDL_sound.framework/Versions/A/SDL_sound
   ```

   You should see: `Mach-O universal binary with 2 architectures: [x86_64] [arm64]`

## Option 2: Use Homebrew (Alternative)

If you prefer, you can install SDL_sound via Homebrew and link against it:

```bash
brew install sdl2_sound
```

However, this installs it system-wide, not as a framework in your project. You would need to:
1. Update Xcode project settings to link against the Homebrew library
2. Update library search paths
3. Handle distribution (the library needs to be bundled with your app)

## Troubleshooting

- **CMake can't find SDL2:** Make sure `SDL2_DIR` points to the directory containing `SDL2.framework`, not the framework itself
- **Build fails:** Check that you have all required dependencies (SDL2, and any codec libraries SDL_sound needs)
- **Framework structure:** SDL_sound may build as a `.dylib` by default. You'll need to manually create the framework structure as shown above

## Current Status

- ✅ SDL2.framework - Updated to 64-bit
- ✅ SDL2_net.framework - Updated to 64-bit  
- ✅ Sparkle.framework - Updated to 64-bit
- ✅ MT32Emu.framework - Updated to 64-bit
- ✅ BGHUDAppKit.framework - Updated to 64-bit
- ✅ DDHidLib.framework - Updated to 64-bit
- ✅ libJoypadCocoa.a - Made conditional (x86_64 only)
- ⚠️ SDL_sound.framework - **Still needs 64-bit version**
