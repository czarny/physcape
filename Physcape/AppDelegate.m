//
//  AppDelegate.m
//  Physcape
//
//  Created by Krzysztof Czarnota on 17/06/2019.
//  Copyright © 2019 Krzysztof Czarnota. All rights reserved.
//

#import "AppDelegate.h"



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
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (IBAction)onQuit:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}


@end
