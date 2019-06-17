//
//  AppDelegate.m
//  Physcape
//
//  Created by Krzysztof Czarnota on 17/06/2019.
//  Copyright © 2019 Krzysztof Czarnota. All rights reserved.
//

#import "AppDelegate.h"
#import <IOKit/hidsystem/IOHIDEventSystemClient.h>
#import <IOKit/hidsystem/IOHIDServiceClient.h>
#import <IOKit/hid/IOHIDUsageTables.h>



@interface AppDelegate ()

@property(weak) IBOutlet NSMenu *statusMenu;
@property(strong) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    // Prepare status bar item
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    self.statusItem.button.image = [NSImage imageNamed:@"Icon"];
    self.statusItem.button.toolTip = [NSString stringWithFormat:@"Physcape %@", version];
    self.statusItem.menu = self.statusMenu;
    
    [self mapESC];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [self unmapESC];
}


- (IBAction)onQuit:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}


- (void)mapESC {
    IOHIDEventSystemClientRef system;
    CFArrayRef services;
    
    uint64_t src_key = 0x700000064;     // Keyboard Non-US \ and |
    uint64_t dst_key = 0x700000029;     // Keyboard Escape
    
    NSArray *map = @[
                     @{@kIOHIDKeyboardModifierMappingSrcKey:@(src_key),
                       @kIOHIDKeyboardModifierMappingDstKey:@(dst_key)},
                     ];
    
    system = IOHIDEventSystemClientCreateSimpleClient(kCFAllocatorDefault);
    services = IOHIDEventSystemClientCopyServices(system);
    for(CFIndex i = 0; i < CFArrayGetCount(services); i++) {
        IOHIDServiceClientRef service = (IOHIDServiceClientRef)CFArrayGetValueAtIndex(services, i);
        if(IOHIDServiceClientConformsTo(service, kHIDPage_GenericDesktop, kHIDUsage_GD_Keyboard)) {
            IOHIDServiceClientSetProperty(service, CFSTR(kIOHIDUserKeyUsageMapKey), (CFArrayRef)map);
        }
    }
    
    CFRelease(services);
    CFRelease(system);
}


- (void)unmapESC {
    IOHIDEventSystemClientRef system;
    CFArrayRef services;
    
    system = IOHIDEventSystemClientCreateSimpleClient(kCFAllocatorDefault);
    services = IOHIDEventSystemClientCopyServices(system);
    for(CFIndex i = 0; i < CFArrayGetCount(services); i++) {
        IOHIDServiceClientRef service = (IOHIDServiceClientRef)CFArrayGetValueAtIndex(services, i);
        if(IOHIDServiceClientConformsTo(service, kHIDPage_GenericDesktop, kHIDUsage_GD_Keyboard)) {
            IOHIDServiceClientSetProperty(service, CFSTR(kIOHIDUserKeyUsageMapKey), (CFArrayRef)@[]);
        }
    }
    
    CFRelease(services);
    CFRelease(system);
}


@end
