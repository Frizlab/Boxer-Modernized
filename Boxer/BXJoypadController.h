/* 
 Copyright (c) 2013 Alun Bestor and contributors. All rights reserved.
 This source file is released under the GNU General Public License 2.0. A full copy of this license
 can be found in this XCode project at Resources/English.lproj/BoxerHelp/pages/legalese.html, or read
 online at [http://www.gnu.org/licenses/gpl-2.0.txt].
 */

//BXJoyPadController listens for and receives input from iOS devices running JoyPad.
//q.v. http://getjoypad.com/ and https://github.com/lzell/JoypadSDK#readme

#import <Foundation/Foundation.h>
#if defined(__x86_64__) || defined(__i386__)
#import "JoypadSDK.h"
#else
@class JoypadManager, JoypadControllerLayout, JoypadDevice;
@protocol JoypadManagerDelegate;
#endif

#if defined(__x86_64__) || defined(__i386__)
@interface BXJoypadController : NSObject <JoypadManagerDelegate>
#else
@interface BXJoypadController : NSObject
#endif
{
#if defined(__x86_64__) || defined(__i386__)
    JoypadManager *joypadManager;
    JoypadControllerLayout *currentLayout;
#else
    id joypadManager;
    id currentLayout;
#endif
    BOOL hasJoypadDevices;
}
#if defined(__x86_64__) || defined(__i386__)
@property (readonly, nonatomic) JoypadManager *joypadManager;
#else
@property (readonly, nonatomic) id joypadManager;
#endif

//An array of all currently-connected joypad devices being used by Boxer.
@property (readonly, nonatomic) NSArray *joypadDevices;

//The current joystick controller layout in use.
#if defined(__x86_64__) || defined(__i386__)
@property (retain, nonatomic) JoypadControllerLayout *currentLayout;
#else
@property (retain, nonatomic) id currentLayout;
#endif

//Returns YES if there are any joypad devices connected or in the process
//of connecting, NO otherwise.
//Note that this may return YES before a device has appeared in joypadDevices.
@property (readonly, nonatomic) BOOL hasJoypadDevices;

@end
