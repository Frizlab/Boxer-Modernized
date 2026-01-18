# Building MT32Emu Framework from Source

MT32Emu is part of the [munt project](https://github.com/munt/munt) and provides MT-32 synthesizer emulation for DOS games.

## Step 1: Clone the Repository

```bash
# Clone the munt repository (outside your Boxer project)
cd ~
git clone https://github.com/munt/munt.git
cd munt
```

## Step 2: Navigate to mt32emu Directory

The `mt32emu` subdirectory contains the library you need:

```bash
cd mt32emu
```

## Step 3: Build with CMake

The munt project uses CMake. You need to build the `mt32emu` library component:

```bash
# Create build directory
mkdir build && cd build

# Configure CMake for universal binary (x86_64 + arm64)
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
    -Dlibmt32emu_SHARED=ON

# Build
cmake --build . --config Release
```

**Note**: The exact CMake options may vary. Check if there's a `CMakeLists.txt` in the `mt32emu` directory and look for framework build options.

## Step 4: Create Framework Structure

After building, you'll need to create a macOS framework structure. The build will produce a library file (`.dylib` or `.a`), but you need to wrap it in a framework.

### Find the Built Library

```bash
# The library might be in different locations depending on the build
find . -name "libmt32emu*.dylib" -o -name "libmt32emu*.a" | head -1
```

### Create Framework Manually

```bash
# Go back to munt root or wherever you want to create the framework
cd ~/munt

# Create framework structure
mkdir -p MT32Emu.framework/Versions/A/Headers
mkdir -p MT32Emu.framework/Versions/A/Resources

# Find and copy the built library
LIB_PATH=$(find . -name "libmt32emu*.dylib" -o -name "libmt32emu*.a" | head -1)
cp "$LIB_PATH" MT32Emu.framework/Versions/A/MT32Emu

# Copy headers (usually in mt32emu/src/ or mt32emu/include/)
# Check the source directory structure first
ls mt32emu/src/  # or mt32emu/include/
cp mt32emu/src/*.h MT32Emu.framework/Versions/A/Headers/ 2>/dev/null || \
cp mt32emu/include/*.h MT32Emu.framework/Versions/A/Headers/ 2>/dev/null || \
echo "Check mt32emu directory for header files"

# Create symlinks
cd MT32Emu.framework
ln -s Versions/A/Headers Headers
ln -s Versions/A/Resources Resources
ln -s Versions/A/MT32Emu MT32Emu
cd Versions
ln -s A Current
cd ../..

# Create Info.plist
cat > MT32Emu.framework/Versions/A/Resources/Info.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>English</string>
    <key>CFBundleIdentifier</key>
    <string>net.munt.mt32emu</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundlePackageType</key>
    <string>FMWK</string>
    <key>CFBundleShortVersionString</key>
    <string>2.7</string>
    <key>CFBundleVersion</key>
    <string>1</string>
</dict>
</plist>
EOF

# Copy to your Boxer project
cp -R MT32Emu.framework /Users/daniel/projects/Boxer/Frameworks/
```

## Step 5: Verify the Framework

```bash
cd /Users/daniel/projects/Boxer

# Check architecture
file Frameworks/MT32Emu.framework/Versions/A/MT32Emu

# Should show: Mach-O universal binary with 2 architectures: [x86_64] [arm64]
# Or at least one 64-bit architecture

# Verify it's 64-bit (not 32-bit)
lipo -info Frameworks/MT32Emu.framework/Versions/A/MT32Emu
```

## Step 6: Check Headers

Make sure the headers are in place:

```bash
ls Frameworks/MT32Emu.framework/Headers/
# Should show header files like: Synth.h, ROMInfo.h, etc.
```

## Troubleshooting

### If CMake configuration fails:
- Make sure you have Xcode Command Line Tools: `xcode-select --install`
- Install CMake if needed: `brew install cmake`
- Check the `CMakeLists.txt` file in the `mt32emu` directory for specific requirements

### If the library is static (.a) instead of dynamic (.dylib):
- You may need to adjust the `libmt32emu_SHARED` flag or check CMake options
- Static libraries can still be used in frameworks, but you'll need to link differently

### If headers are missing:
- Check the `mt32emu/src/` or `mt32emu/include/` directory in the source tree
- Common headers needed: `Synth.h`, `ROMInfo.h`, `FileStream.h`, etc.
- You may need to copy headers from the source directory manually

### If build produces errors:
- Check the munt repository's README or documentation
- Look for build instructions in the repository
- The project might have specific dependencies or build requirements

## Alternative: Check for Pre-built Versions

Before building from source, check if there are pre-built frameworks available:
- Check the munt releases page: https://github.com/munt/munt/releases
- Look for macOS framework downloads
- Check if Homebrew has a formula: `brew search munt`

## Notes

- **ROM Files Required**: MT32Emu requires ROM files to function (MT32_CONTROL.ROM, MT32_PCM.ROM, etc.)
  - These ROMs are copyrighted by Roland and cannot be distributed
  - Users must provide their own ROM files
  - Boxer should handle ROM loading separately

- **Licensing**: The framework is LGPL-2.1 licensed, so ensure compliance with licensing requirements if your app is closed-source

- **Current Framework**: Your existing MT32Emu.framework is 32-bit (i386), so it definitely needs to be rebuilt for 64-bit
