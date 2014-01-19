//
//  GGPullToRefreshClock.h
//  Clock-Pull-To-Refresh
//
//  Created by Josh Sklar on 6/25/13.
//  Copyright (c) 2013 Josh Sklar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSPullToRefreshClock : UIView

/*
 Animates the clock hands towards the noon position
 */
- (void)scrollViewDidScrollDown:(CGFloat)amount;
/*
 Animates the clock hands towards the 6 o'clocl position
 */
- (void)scrollViewDidScrollUp:(CGFloat)amount;

/*
 Called when the data source is loading. Animates the clock hands counter-clockwise
 */
- (void)startAnimatingClockHands;
/*
 Called when the loading is complete
 */
- (void)stopAnimatingClockHands;

/*
 Sets the clock hands to stop animating and places them in their original
 positions 
 */
- (void)reset;

@end
