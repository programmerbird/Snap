//
//  DragStatusView.h
//  Snap
//
//  Created by Sittipon Simasanti on 3/2/56 BE.
//  Copyright (c) 2556 Sittipon Simasanti. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  DragStatusViewDelegate <NSObject>
-(void)dragStatusView: (id)sender didDragOperations: (NSArray*)fileNames;
@end

@interface DragStatusView : NSView

@property (nonatomic, assign) IBOutlet id<DragStatusViewDelegate> delegate;
@end
