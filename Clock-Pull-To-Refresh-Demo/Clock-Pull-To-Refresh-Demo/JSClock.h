//
//  GGPullToRefreshClock.h
//  Merge
//
//  Created by Josh Sklar on 6/25/13.
//  Copyright (c) 2013 Josh Sklar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSClock : UIView

- (void)scrollViewDidScrollDown;
- (void)scrollViewDidScrollUp;

- (void)startAnimatingClockHands;
- (void)stopAnimatingClockHands;

- (void)reset;
@end
