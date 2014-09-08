/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2014 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIView.h"
#import "TiModule.h"

@interface MaCarNativecodeSlideView : TiUIView {
    UIView *square;
    TiUIView *touchArea;
    TiUIView *viewContainer;
    
    CGFloat touchWidth;
    CGFloat pageWidth;
    int     pageNum;
    int     curPage;
    BOOL    dragging;
    BOOL    moving;
    float   oldX;
    float   oldY;
    float   originX;
    float   startX;
    KrollCallback* moveEndCallback;
}

-(void)scaleAnimation:(TiUIView*)view scale:(float)scale;

@end
