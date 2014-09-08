/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2014 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "MaCarNativecodeSlideView.h"
#import "MaCarNativecodeSlideViewProxy.h"
#import "TiBase.h"
#import "TiUtils.h"

@implementation MaCarNativecodeSlideView

-(void)dealloc
{
	NSLog(@"[VIEW LIFECYCLE EVENT] dealloc");
	
	// Release objects and memory allocated by the view
	RELEASE_TO_NIL(square);
    RELEASE_TO_NIL(touchArea);
    RELEASE_TO_NIL(viewContainer);
	
	[super dealloc];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
	NSLog(@"[VIEW LIFECYCLE EVENT] willMoveToSuperview");
}

-(void)initializeState
{
	// This method is called right after allocating the view and
	// is useful for initializing anything specific to the view
	
	[super initializeState];
	
    /*
    if (viewContainer == nil) {
		viewContainer = [[TiUIView alloc] initWithFrame:[self frame]];
		[self addSubview:viewContainer];
	}
    */
    //curPage = 0;
    //pageNum = 0;
    
	NSLog(@"[VIEW LIFECYCLE EVENT] initializeState");
}

-(void)configurationSet
{
	// This method is called right after all view properties have
	// been initialized from the view proxy. If the view is dependent
	// upon any properties being initialized then this is the method
	// to implement the dependent functionality.
	
    [super configurationSet];
    
    if (touchArea == nil) {
        CGRect rect1 = [self frame];
        rect1.size.width = touchWidth;
		touchArea = [[TiUIView alloc] initWithFrame:rect1];
		[self addSubview:touchArea];
        
        //touchArea.backgroundColor = [UIColor yellowColor];
	}
    
	NSLog(@"[VIEW LIFECYCLE EVENT] configurationSet");
}

-(UIView*)square
{
	// Return the square view. If this is the first time then allocate and
	// initialize it.
	if (square == nil) {
		NSLog(@"[VIEW LIFECYCLE EVENT] square");
		
		square = [[UIView alloc] initWithFrame:[self frame]];
		[self addSubview:square];
	}
	
	return square;
}

-(void)notifyOfColorChange:(TiColor*)newColor
{
	NSLog(@"[VIEW LIFECYCLE EVENT] notifyOfColorChange");
	
	// The event listeners for a view are actually attached to the view proxy.
	// You must reference 'self.proxy' to get the proxy for this view
	
	// It is a good idea to check if there are listeners for the event that
	// is about to fired. There could be zero or multiple listeners for the
	// specified event.
	if ([self.proxy _hasListeners:@"colorChange"]) {
		NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
							   newColor,@"color",
							   nil
							   ];
        
		[self.proxy fireEvent:@"colorChange" withObject:event];
	}
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
	// You must implement this method for your view to be sized correctly.
	// This method is called each time the frame / bounds / center changes
	// within Titanium.
	
	NSLog(@"[VIEW LIFECYCLE EVENT] frameSizeChanged");
    NSLog(@"%@", NSStringFromCGRect(bounds));
    /*
	if (square != nil) {
		
		// You must call the special method 'setView:positionRect' against
		// the TiUtils helper class. This method will correctly layout your
		// child view within the correct layout boundaries of the new bounds
		// of your view.
		
		[TiUtils setView:square positionRect:bounds];
	}
    */
    //[TiUtils setView:viewContainer positionRect:bounds];
    CGRect rec = bounds;
    rec.size.width = touchWidth;
    [TiUtils setView:touchArea positionRect:rec];
    NSLog(@"%@", NSStringFromCGRect(viewContainer.frame));
}

-(void)setColor_:(id)color
{
	// This method is a property 'setter' for the 'color' property of the
	// view. View property methods are named using a special, required
	// convention (the underscore suffix).
	
	NSLog(@"[VIEW LIFECYCLE EVENT] Property Set: setColor_");
	
	// Use the TiUtils methods to get the values from the arguments
    
	TiColor *newColor = [TiUtils colorValue:color];
	UIColor *clr = [newColor _color];
	//viewContainer.backgroundColor = clr;

	// Signal a property change notification to demonstrate the use
	// of the proxy for the event listeners
	[self notifyOfColorChange:newColor];
}

-(void)setTouchWidth_:(id)width
{
	NSLog(@"[VIEW LIFECYCLE EVENT] Property Set: setTouchWidth_");
	NSLog(@"%@", width);
    touchWidth = [width floatValue];
}

-(void)setPageWidth_:(id)width
{
	NSLog(@"[VIEW LIFECYCLE EVENT] Property Set: setPageWidth_");
	NSLog(@"%@", width);
    pageWidth = [width floatValue];
}

-(void)setViewContainer_:(id)con
{
	NSLog(@"[VIEW LIFECYCLE EVENT] Property Set: setViewContainer_");
	//NSLog(@"%@", width);
    viewContainer = [con view];
    [self addSubview:viewContainer];
    startX = viewContainer.frame.origin.x;
    //NSLog( @"%@", [[viewContainer proxy] children][0] );
}

-(void)setPageNum_:(id)num
{
	NSLog(@"[VIEW LIFECYCLE EVENT] Property Set: setPageNum_");
	NSLog(@"%@", num);
    pageNum = [num intValue];
}

-(void)setTouchEndCallback_:(id)callback
{
	NSLog(@"[VIEW LIFECYCLE EVENT] Property Set: setTouchEndCallback_");
    NSLog(@"%@", callback);
    self->moveEndCallback = callback;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"[VIEW LIFECYCLE EVENT] touchesBegan");
    if(pageNum <= 0 || moving){
        return;
    }
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touchArea];
    
    if (CGRectContainsPoint(touchArea.frame, touchLocation)) {
        
        dragging = YES;
        oldX = touchLocation.x;
        originX = touchLocation.x;
        //NSLog(@"%f", oldX);
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"[VIEW LIFECYCLE EVENT] touchesMoved");
    if(pageNum <= 0 || moving){
        return;
    }
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touchArea];
    //NSLog(@"%@", NSStringFromCGPoint(touchLocation));
    if (CGRectContainsPoint(touchArea.frame, touchLocation) && dragging) {
        CGRect frame = viewContainer.frame;
        frame.origin.x = (viewContainer.frame.origin.x + touchLocation.x - oldX);
        //frame.origin.y = (viewContainer.frame.origin.y + touchLocation.y - oldY);
        oldX = touchLocation.x;
        //NSLog(@"%f", frame.origin.x);
        viewContainer.frame = frame;
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(pageNum <= 0){
        return;
    }
    //NSLog(@"[VIEW LIFECYCLE EVENT] touchesEnded");
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touchArea];
    
    //if (CGRectContainsPoint(touchArea.frame, touchLocation)) {
        moving = YES;
        //NSLog(@"pre Current page: %d", curPage);
        if(fabsf(touchLocation.x - originX) > 10){
            curPage = (touchLocation.x - originX) > 0 ? (curPage-1):(curPage+1);
        }
        if(curPage < 0){
            curPage = 0;
        }
        if(curPage >= pageNum){
            curPage = pageNum - 1;
        }
        //NSLog(@"Current page: %d", curPage);
        CGRect frame = viewContainer.frame;
        float finialX = startX-(curPage*pageWidth);
        //NSLog(@"Current x: %f", self.frame.origin.x);
        //NSLog(@"Current page width: %f", pageWidth);
        //NSLog(@"Current page offset: %f", -curPage*pageWidth);
        //NSLog(@"final x: %f", finialX);
        frame.origin.x = finialX;
        
        [UIView animateWithDuration:0.2
                delay:0
                options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                animations:^{
                    viewContainer.frame = frame;
        } completion:^(BOOL finished) {
            dragging = NO;
            moving = NO;
            
            if ([[self proxy] _hasListeners:@"touchMoveEnd"]) {
                NSString *page = [NSString stringWithFormat:@"%d",curPage];
                NSDictionary* dict = [[[NSDictionary alloc] initWithObjectsAndKeys:page, @"currentPage", nil] autorelease];
                [[self proxy] fireEvent:@"touchMoveEnd" withObject:dict];
            }
            
            NSUInteger count = [[[viewContainer proxy] children] count];
            for (NSUInteger i = 0; i < count; i++) {
                TiUIView *childView = [[[viewContainer proxy] children][i] view];
                if( i == curPage ){
                    [UIView animateWithDuration:0.05 delay:0
                                        options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                                     animations:^{
                                         [childView setTransform:CGAffineTransformMakeScale(1.16, 1.16)];
                                     }
                                     completion:^(BOOL finished) {
                                         [UIView animateWithDuration:0.05 delay:0
                                                             options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                                                          animations:^{
                                                              [childView setTransform:CGAffineTransformMakeScale(1.12, 1.12)];
                                                          }
                                                          completion:nil
                                          ];
                                     }
                     ];
                }
                else{
                    [UIView animateWithDuration:0.05 delay:0
                                        options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                                     animations:^{
                                         [childView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                                     }
                                     completion:nil
                     ];
                }
            }
        }];

    //}
}

/*
- (UIView *)hitTest:(CGPoint) point withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromCGPoint(point));
	BOOL hasTouchListeners = [self hasTouchableListener];
    
	// if we don't have any touch listeners, see if interaction should
	// be handled at all.. NOTE: we don't turn off the views interactionEnabled
	// property since we need special handling ourselves and if we turn it off
	// on the view, we'd never get this event
	if (hasTouchListeners == NO && [self interactionEnabled]==NO)
	{
		return nil;
	}
	
    // OK, this is problematic because of the situation where:
    // touchDelegate --> view --> button
    // The touch never reaches the button, because the touchDelegate is as deep as the touch goes.
 
     // delegate to our touch delegate if we're hit but it's not for us
     if (hasTouchListeners==NO && touchDelegate!=nil)
     {
     return touchDelegate;
     }

    return [super hitTest:point withEvent:event];
}
*/

@end
