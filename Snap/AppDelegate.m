//
//  AppDelegate.m
//  Snap
//
//  Created by Sittipon Simasanti on 3/1/56 BE.
//  Copyright (c) 2556 Sittipon Simasanti. All rights reserved.
//

#import "AppDelegate.h"
#import "NSImage+MGCropExtensions.h"
#import "DragStatusView.h"


@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    
    DragStatusView* dragView = [[DragStatusView alloc] initWithFrame:NSMakeRect(0, 0, 24, 24)];
    [dragView setDelegate: self];

    NSImageView *bg = [[NSImageView alloc] initWithFrame: dragView.bounds];
    [bg setImage: [NSImage imageNamed: @"camera-icon"]];
    [bg addSubview: dragView];
    [dragView release];
    
    [self.statusItem setMenu: self.statusMenu];
    [self.statusItem setView:bg];
    [bg release];

    
}

-(void)unretinaFile: (NSString*)fileName to: (NSString*)outputFilename{
    
    
    @autoreleasepool {
        // Getting source image
        NSImage *image = [[NSImage alloc] initWithContentsOfFile: fileName];
        NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData: [image TIFFRepresentation]];
        float w = [imageRep pixelsWide] / 2;
        float h = [imageRep pixelsHigh] / 2;
        
        NSImage *secondaryImage = [image imageToFitSize:NSMakeSize(w, h) method:MGImageResizeScale];
        
        // Four lines below are from aforementioned "ImageReducer.m"
        NSSize size = [secondaryImage size];
        [secondaryImage lockFocus];
        NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, size.width, size.height)];
        [secondaryImage unlockFocus];
        
        NSDictionary *prop = [NSDictionary dictionaryWithObject: [NSNumber numberWithFloat: 1.0] forKey: NSImageCompressionFactor];
        NSData *outputData = [bitmapImageRep representationUsingType:NSPNGFileType properties: prop];
        [outputData writeToFile:outputFilename atomically:YES];
        
        // release from memory
        [image release];    
        [bitmapImageRep release];
    }
    
}

-(void)processFiles: (NSArray*)fileNames{
    int count = 0;
    NSMutableArray *outputs = [[NSMutableArray alloc] init];
    for(NSString *fileName in fileNames)
    {
        if(![[fileName lowercaseString] hasSuffix:@"@2x.png"]) continue;
        
        NSString *outputFileName = [fileName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
        [self unretinaFile: fileName to: outputFileName];
        
        [outputs addObject: [NSURL fileURLWithPath: fileName]];
        [outputs addObject: [NSURL fileURLWithPath: outputFileName]];
        count += 1;
    }
    
    // [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs: outputs];
    [outputs release];
    
    if(count > 0){
        if(!self.shutterSound){
            NSSound *sound = [[NSSound alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shutter" ofType:@"wav"] byReference:NO];
            [self setShutterSound: sound];
            [sound release];
        }
        [self.shutterSound play];
    
    }

}
-(void)application:(NSApplication *)sender openFiles:(NSArray *)fileNames {
    
    [self processFiles:fileNames];
}

#pragma mark DragStatusViewDelegate
-(void)dragStatusView:(id)sender didDragOperations:(NSArray *)fileNames {
    [self processFiles:fileNames];

}
#pragma mark -
#pragma mark Memory
-(void)dealloc {
    self.statusItem = nil;
    self.statusMenu = nil;
    self.shutterSound = nil;
    [super dealloc];
}
@end
