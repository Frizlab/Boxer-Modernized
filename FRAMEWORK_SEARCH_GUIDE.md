# Guide to Finding Updated Versions of BGHUDAppKit and DDHidLib

## BGHUDAppKit

**What it is:** A framework that provides HUD-style UI elements (dark translucent controls) for macOS applications.

**Current status:** The original BGHUDAppKit is likely abandoned or not maintained for modern macOS.

### Search Strategy:

1. **GitHub Search:**
   - Search: `BGHUDAppKit` on GitHub
   - Look for forks with recent commits
   - Check for forks that mention "64-bit", "arm64", "Apple Silicon", or "modern macOS"

2. **Alternative Approaches:**
   - **Replace with modern AppKit:** macOS 10.14+ has built-in support for dark mode and modern UI styles. You might be able to replace BGHUDAppKit usage with standard AppKit controls styled appropriately.
   - **Check if it's actually needed:** Review what BGHUDAppKit provides and see if you can achieve the same look with modern AppKit APIs.

3. **What to look for:**
   - Forks with commits from 2020 or later
   - Mentions of "Universal Binary" or "arm64"
   - Updated build scripts or Xcode project files
   - Issues/PRs discussing 64-bit or modern macOS support

### Files using BGHUDAppKit in Boxer:
- `Boxer/BXThemes.h`
- `Boxer/BXThemedButtonCell.h`
- `Boxer/BXThemedSliderCell.h`
- `Boxer/BXThemedPopUpButtonCell.h`
- `Boxer/BXThemedSegmentedCell.h`
- `Boxer/BXThemedControls.h`

**Classes used:**
- `BGGradientTheme`
- `BGHUDButtonCell`
- `BGHUDLabel`
- Other BGHUD* classes

## DDHidLib

**What it is:** A library for accessing HID (Human Interface Device) devices on macOS, used for game controllers and joysticks.

**Current status:** DDHidLib is old and may not be maintained. Modern macOS has better alternatives.

### Search Strategy:

1. **GitHub Search:**
   - Search: `DDHidLib` on GitHub
   - Look for forks with recent activity
   - Check for "IOKit" alternatives

2. **Modern Alternative: IOKit**
   - macOS has built-in IOKit framework for HID access
   - Game Controller framework (macOS 10.9+) for gamepads
   - Consider migrating to these modern APIs

3. **What to look for:**
   - Forks updated for 64-bit
   - Projects that migrated from DDHidLib to IOKit
   - Updated versions that work with modern macOS

### Files using DDHidLib in Boxer:
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

## Recommended Search Steps

### Step 1: Search GitHub

```bash
# For BGHUDAppKit
# Visit: https://github.com/search?q=BGHUDAppKit&type=repositories
# Sort by: Recently updated
# Look for: Forks with recent commits

# For DDHidLib  
# Visit: https://github.com/search?q=DDHidLib&type=repositories
# Sort by: Recently updated
# Look for: Forks mentioning 64-bit or modern macOS
```

### Step 2: Check Original Repositories

1. **BGHUDAppKit:**
   - Original might be on SourceForge or old GitHub
   - Check for any official updates or migration guides

2. **DDHidLib:**
   - Original might be on SourceForge or old repositories
   - Look for migration guides to IOKit

### Step 3: Evaluate Alternatives

**For BGHUDAppKit:**
- Modern AppKit with `NSAppearance` and dark mode
- Custom drawing with `NSView` subclasses
- Third-party modern UI frameworks (if needed)

**For DDHidLib:**
- IOKit framework (built into macOS)
- Game Controller framework (for gamepads)
- Consider if the HID functionality is still needed or can be simplified

### Step 4: If You Find Updated Versions

1. **Verify it's 64-bit:**
   ```bash
   file FrameworkName.framework/Versions/A/FrameworkName
   # Should show: Mach-O 64-bit or universal binary
   ```

2. **Check architectures:**
   ```bash
   lipo -info FrameworkName.framework/Versions/A/FrameworkName
   # Should show: x86_64 arm64 (for universal)
   ```

3. **Test compatibility:**
   - Build your project with the new framework
   - Check for API changes
   - Test on both Intel and Apple Silicon Macs

### Step 5: If No Updated Versions Exist

**Option A: Build from Source**
- Get the source code
- Update build settings for 64-bit
- Fix any compilation errors
- Create a framework bundle

**Option B: Replace with Modern APIs**
- This is the recommended long-term solution
- More work upfront but better maintainability
- Uses Apple-supported APIs

**Option C: Remove/Disable Features**
- If the features aren't critical, consider disabling them
- Document what's missing
- Plan to add back with modern APIs later

## Quick Links to Try

1. **GitHub Search:**
   - https://github.com/search?q=BGHUDAppKit
   - https://github.com/search?q=DDHidLib

2. **SourceForge (old projects often here):**
   - Search for original repositories

3. **CocoaPods/Carthage:**
   - Check if there are podspecs or package definitions

4. **Homebrew:**
   - `brew search` for any packages

## Next Steps

1. Start with GitHub searches for both frameworks
2. Check if there are active forks
3. Evaluate if you can replace with modern APIs
4. If you find something, test it thoroughly
5. If not, consider building from source or replacing functionality
