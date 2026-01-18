# DDHidLib Search and Update Guide

## What is DDHidLib?

DDHidLib is a library for accessing HID (Human Interface Device) devices on macOS. In Boxer, it's used for:
- Game controller/joystick input
- Reading HID device information
- Managing HID device connections

## Where to Search

### 1. GitHub (Primary Search)

**Direct Search:**
- Go to: https://github.com/search?q=DDHidLib&type=repositories
- Sort by: "Recently updated"
- Look for:
  - Forks with commits from 2020 or later
  - Mentions of "64-bit", "arm64", "Apple Silicon", or "Universal Binary"
  - Updated Xcode projects or build scripts

**Alternative Search Terms:**
- Search: `DDHid` (broader search)
- Search: `"DDHidLib" 64-bit`
- Search: `"DDHidLib" arm64`
- Search: `"DDHidLib" macOS`

### 2. SourceForge (Original May Be Here)

Many old macOS projects were hosted on SourceForge:
- Search: https://sourceforge.net/directory/?q=DDHidLib
- Check for original repository or forks

### 3. CocoaPods / Package Managers

- Check if there's a CocoaPods spec: `pod search DDHidLib`
- Check Homebrew: `brew search ddhid`
- Check MacPorts: Search for DDHidLib

### 4. Check Boxer's Original Source

- Look at Boxer's git history or documentation
- Check if there's a reference to where DDHidLib came from
- Look for any build scripts or documentation mentioning DDHidLib

## What to Look For

### Good Signs:
- ✅ Repository with commits from 2020 or later
- ✅ Mentions "64-bit" or "Universal Binary" in README
- ✅ Updated Xcode project files
- ✅ Issues/PRs discussing modern macOS support
- ✅ Build instructions for modern Xcode

### Red Flags:
- ❌ Last commit before 2015
- ❌ Only 32-bit builds
- ❌ Mentions "deprecated" or "use IOKit instead"
- ❌ No activity for years

## Modern Alternative: IOKit

**Important:** DDHidLib is old. Modern macOS has built-in alternatives:

### IOKit Framework
- Built into macOS (no external dependency)
- Modern, Apple-supported API
- Better performance and security
- Supports all HID devices

### Game Controller Framework (macOS 10.9+)
- For gamepads specifically
- Simpler API for game controllers
- Built into macOS

## Migration Strategy

If you can't find an updated DDHidLib, you have two options:

### Option A: Build from Source (if source is available)
1. Find the original DDHidLib source code
2. Update build settings for 64-bit:
   - `ARCHS = "x86_64 arm64"`
   - `MACOSX_DEPLOYMENT_TARGET = 10.15`
3. Fix any compilation errors
4. Build as a framework

### Option B: Migrate to IOKit (Recommended Long-term)
This is more work but better for the future:
1. Replace DDHidLib calls with IOKit APIs
2. Use Game Controller framework for gamepads
3. More maintainable and future-proof

## Files in Boxer Using DDHidLib

Based on the codebase, these files use DDHidLib:
- `Boxer/BXJoystickController.h`
- `Boxer/BXJoystickController.m`
- `Boxer/BXInputController.h`
- `Boxer/BXHIDControllerProfile.h`
- Various controller profile files

**Classes used:**
- `DDHidDevice`
- `DDHidQueue`
- `DDHidElement`
- Other DDHid* classes

## Quick Search Commands

```bash
# Search GitHub via command line (if you have GitHub CLI)
gh search repos DDHidLib

# Or use curl to search GitHub API
curl "https://api.github.com/search/repositories?q=DDHidLib" | grep -i "full_name\|updated_at"
```

## Next Steps

1. **Start with GitHub search** (most likely to find something)
2. **Check the original repository** (if you can find it) for any migration guides
3. **Evaluate IOKit migration** - consider if it's worth the effort
4. **If you find something**, verify it's 64-bit:
   ```bash
   file FrameworkName.framework/Versions/A/FrameworkName
   lipo -info FrameworkName.framework/Versions/A/FrameworkName
   ```

## If Nothing is Found

If you can't find an updated version:
1. Check if the source code is available (even if old)
2. Try building from source with updated settings
3. Consider temporarily disabling HID/joystick features
4. Plan migration to IOKit for a future update
