//
//  GGPullToRefreshClock.m
//  Merge
//
//  Created by Josh Sklar on 6/25/13.
//  Copyright (c) 2013 Josh Sklar. All rights reserved.
//

#import "JSClock.h"
#import <QuartzCore/QuartzCore.h>
#define kTimeIntervalSpinningClockHandsIntervalIncrementAmount 0.00001

@interface JSClock ()
{
    CGFloat backgroundClockAngle, handsAngle;
    
    UIImageView *clockBackground, *clockHands;
    
    /* flag for if the content is loading, then ignore dragging */
    BOOL loading;
    
    NSTimer *timerForSpinningClockHands;
    
    NSTimeInterval timeIntervalSpinningClockHands;
}

@end

@implementation JSClock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        backgroundClockAngle = 0;
        handsAngle = 0;

        clockBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [clockBackground setImage:[UIImage imageNamed:@"merge-clock-background"]];
        [self addSubview:clockBackground];
        
        clockHands = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [clockHands setImage:[UIImage imageNamed:@"merge-clock-hands"]];
        [self addSubview:clockHands];
        
        
        
        // Initialization code
    }
    return self;
}

- (void)scrollViewDidScrollDown
{
    if (loading)
        return;
    
    backgroundClockAngle += 0.1;
    clockBackground.transform = CGAffineTransformRotate(CGAffineTransformIdentity, backgroundClockAngle);
    
    handsAngle -= 0.1;
    clockHands.transform = CGAffineTransformRotate(CGAffineTransformIdentity, handsAngle);
}

- (void)scrollViewDidScrollUp
{
    if (loading)
        return;
    
    backgroundClockAngle -= 0.1;
    clockBackground.transform = CGAffineTransformRotate(CGAffineTransformIdentity, backgroundClockAngle);
    
    handsAngle += 0.1;
    clockHands.transform = CGAffineTransformRotate(CGAffineTransformIdentity, handsAngle);
}

- (void)startAnimatingClockHands
{
    [self reset];
    loading = YES;
    
    timeIntervalSpinningClockHands = 0.0001;
    
    [self moveClockHands];
}

- (void)stopAnimatingClockHands
{
    [clockHands.layer removeAnimationForKey:@"rotationAnimation"];
    [self reset];
}

- (void)reset
{   
    loading = NO;
    backgroundClockAngle = 0.;
    clockBackground.transform = CGAffineTransformRotate(CGAffineTransformIdentity, backgroundClockAngle);
    
    handsAngle = 0.;
    clockHands.transform = CGAffineTransformRotate(CGAffineTransformIdentity, handsAngle);
}

- (void)moveClockHands
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * 3 * 0.7 ];
    rotationAnimation.duration = 1.;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 7;
    
    [clockHands.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
//    if (!loading)
//        return;
//    
//    [UIView animateWithDuration:0.7 animations:^{
//        clockHands.transform = CGAffineTransformMakeRotation(90 * M_PI / 180.0);
//    } completion:^(BOOL finished) {
//        [self moveClockHands];
//    }];
    
//    handsAngle += 0.1;
//    clockHands.transform = CGAffineTransformRotate(CGAffineTransformIdentity, handsAngle);
//    
//    
////    return;
//    
////    timeIntervalSpinningClockHands += 0.0001;
//    
//    [timerForSpinningClockHands invalidate];
//    timerForSpinningClockHands = nil;
//    
//    timerForSpinningClockHands = [NSTimer scheduledTimerWithTimeInterval:timeIntervalSpinningClockHands
//                                                                  target:self
//                                                                selector:@selector(moveClockHands)
//                                                                userInfo:nil
//                                                                 repeats:NO];
//    return;
    
//    double delayInSeconds = timeIntervalSpinningClockHands;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self moveClockHands];
//    });
}

@end
