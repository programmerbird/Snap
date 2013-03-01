//
//  AppDelegate.m
//  Snap
//
//  Created by Sittipon Simasanti on 3/1/56 BE.
//  Copyright (c) 2556 Sittipon Simasanti. All rights reserved.
//

#import "AppDelegate.h"
#import "NSImage+MGCropExtensions.h"

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
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

-(void)application:(NSApplication *)sender openFiles:(NSArray *)fileNames {
    
    
    NSMutableArray *outputs = [[NSMutableArray alloc] init];
    for(NSString *fileName in fileNames)
    {
        if(![[fileName lowercaseString] hasSuffix:@"@2x.png"]) continue;
        
        NSString *outputFileName = [fileName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
        [self unretinaFile: fileName to: outputFileName];
        
        [outputs addObject: [NSURL fileURLWithPath: fileName]];
        [outputs addObject: [NSURL fileURLWithPath: outputFileName]];
    }

    // [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs: outputs];
    [outputs release];
    
    if(!self.shutterSound){
        NSSound *sound = [[NSSound alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shutter" ofType:@"wav"] byReference:NO];
        [self setShutterSound: sound];
        [sound release];
    }
    [self.shutterSound play];
}

-(void)dealloc {
    self.shutterSound = nil;
    [super dealloc];
}
@end
