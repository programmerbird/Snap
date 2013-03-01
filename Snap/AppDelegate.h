//
//  AppDelegate.h
//  Snap
//
//  Created by Sittipon Simasanti on 3/1/56 BE.
//  Copyright (c) 2556 Sittipon Simasanti. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DragStatusView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, DragStatusViewDelegate>

@property (nonatomic, retain) NSSound *shutterSound;
@property (nonatomic, retain) IBOutlet NSStatusItem *statusItem;
@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property (assign) IBOutlet NSWindow *window;

@end
