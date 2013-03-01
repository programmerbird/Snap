//
//  DragStatusView.m
//  Snap
//
//  Created by Sittipon Simasanti on 3/2/56 BE.
//  Copyright (c) 2556 Sittipon Simasanti. All rights reserved.
//

#import "DragStatusView.h"

@implementation DragStatusView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //register for drags
        [self registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType, nil]];
    }
    
    return self;
}


//we want to copy the files
- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    return NSDragOperationCopy;
}

//perform the drag and log the files that are dropped
- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        
        [self.delegate dragStatusView:self didDragOperations:files];
        
    }
    return YES;
}

-(void)dealloc {
    self.delegate = nil;
    [super dealloc];
}

@end