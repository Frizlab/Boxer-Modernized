/* 
 Copyright (c) 2013 Alun Bestor and contributors. All rights reserved.
 This source file is released under the GNU General Public License 2.0. A full copy of this license
 can be found in this XCode project at Resources/English.lproj/BoxerHelp/pages/legalese.html, or read
 online at [http://www.gnu.org/licenses/gpl-2.0.txt].
 */

#if defined(__x86_64__) || defined(__i386__)
#import "JoypadSDK.h"
#else
#import <Foundation/Foundation.h>
@class JoypadControllerLayout;
#endif

//BXJoypadLayot is a base class for our custom joypad controller layouts.
//It mostly provides functions to register layouts for particular joystick types.

@protocol BXEmulatedJoystick;


//Additional constants for Boxer-specific buttons
enum {
    BXJoyInputFirstIdentifier = 100,
    BXJoyInputFakeDPadButtonUp,
    BXJoyInputFakeDPadButtonRight,
    BXJoyInputFakeDPadButtonDown,
    BXJoyInputFakeDPadButtonLeft
};

#if defined(__x86_64__) || defined(__i386__)
@interface BXJoypadLayout : JoypadControllerLayout
#else
@interface BXJoypadLayout : NSObject
#endif

//Register a Joypad controller layout as matching the specified joystick type.
//Used by BXJoypadLayout subclasses to register themeselves.
+ (void) registerLayout: (Class)layoutClass forJoystickType: (Class)joystickType;

//Returns the registered layout class appropriate for the specified joystick type,
//or nil if none has been registered.
+ (Class) layoutClassForJoystickType: (Class)joystickType;

//Returns a fully prepared custom joystick controller layout for the specified
//joystick type, suitable for passing to JoypadManager.
#if defined(__x86_64__) || defined(__i386__)
+ (JoypadControllerLayout *) layoutForJoystickType: (Class)joystickType;

//Returns an empty JoypadControllerLayout. Intended to be overridden by subclasses
//to provide fully-configured layouts.
//NOTE: we must provide instances of JoypadControllerLayout because the Joypad SDK
//does not support subclassing JoypadControllerLayout.
+ (JoypadControllerLayout *) layout;
#else
+ (id) layoutForJoystickType: (Class)joystickType;
+ (id) layout;
#endif

@end
