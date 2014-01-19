//
//  GGPullToRefreshClock.m
//  Clock-Pull-To-Refresh
//
//  Created by Josh Sklar on 6/25/13.
//  Copyright (c) 2013 Josh Sklar. All rights reserved.
//

#import "JSPullToRefreshClock.h"
#import <QuartzCore/QuartzCore.h>

#define kTimeIntervalSpinningClockHandsIntervalIncrementAmount 0.00001

static NSString *kMinuteHandRotationAminationKey = @"minuteHandRotation";
static NSString *kHourHandRotationAnimationKey = @"hourHandRotation";

@interface JSPullToRefreshClock ()
{
    CGFloat backgroundClockAngle;
    CGFloat minuteHandAngle, hourHandAngle;
    
    UIImageView *clockBackground;
    UIImageView *minuteHand, *hourHand;
    
    /* flag for if the content is loading, then ignore dragging */
    BOOL loading;
    
    NSTimer *timerForSpinningClockHands;
    
    NSTimeInterval timeIntervalSpinningClockHands;
}

- (void)moveClockHands;
- (void)printAngles;

@end

@implementation JSPullToRefreshClock

#pragma mark - External methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        backgroundClockAngle = 0;
        minuteHandAngle = hourHandAngle = 0;
        
        clockBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [clockBackground setImage:[UIImage imageNamed:@"clock-background"]];
        [self addSubview:clockBackground];
        
        minuteHand = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [minuteHand setImage:[UIImage imageNamed:@"minute-hand"]];
        [self addSubview:minuteHand];
        
        hourHand = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [hourHand setImage:[UIImage imageNamed:@"hour-hand"]];
        [self addSubview:hourHand];
    }
    return self;
}

- (void)scrollViewDidScrollDown:(CGFloat)amount
{
    if (loading)
        return;
    
    CGFloat moveAmount = amount / 5.;
    
    backgroundClockAngle += 0.1;
    
    hourHandAngle -= moveAmount/4.;
    minuteHandAngle += moveAmount/4.;
    if (minuteHandAngle >= 3.14 && hourHandAngle <= -3.14) {
        minuteHandAngle = M_PI;
        hourHandAngle = -M_PI;
    }
    
    hourHand.transform = CGAffineTransformRotate(CGAffineTransformIdentity, hourHandAngle);
    minuteHand.transform = CGAffineTransformRotate(CGAffineTransformIdentity, minuteHandAngle);
    
//    [self printAngles];
}

- (void)scrollViewDidScrollUp:(CGFloat)amount
{
    if (loading)
        return;
    
    CGFloat moveAmount = amount / 5.;
    
    backgroundClockAngle -= 0.1;
    
    hourHandAngle += moveAmount/4.;
    minuteHandAngle -= moveAmount/4.;
    if (minuteHandAngle <= 0. && hourHandAngle >= 0.) {
        hourHandAngle = minuteHandAngle = 0.;
    }
    
    hourHand.transform = CGAffineTransformRotate(CGAffineTransformIdentity, hourHandAngle);
    minuteHand.transform = CGAffineTransformRotate(CGAffineTransformIdentity, minuteHandAngle);
    
//    [self printAngles];
}

- (void)startAnimatingClockHands
{
    loading = YES;
    
    timeIntervalSpinningClockHands = 0.0001;
    
    [self moveClockHands];
}

- (void)stopAnimatingClockHands
{
    if (loading) {
        [hourHand.layer removeAnimationForKey:kHourHandRotationAnimationKey];
        [minuteHand.layer removeAnimationForKey:kMinuteHandRotationAminationKey];
        
        [self reset];
    }
}

- (void)reset
{
    loading = NO;
    backgroundClockAngle = 0.;
    clockBackground.transform = CGAffineTransformRotate(CGAffineTransformIdentity, backgroundClockAngle);
    
    hourHandAngle = minuteHandAngle = 0.;
    hourHand.transform = CGAffineTransformRotate(CGAffineTransformIdentity, hourHandAngle);
    minuteHand.transform = CGAffineTransformRotate(CGAffineTransformIdentity, minuteHandAngle);
}

#pragma mark - Internal methods

- (void)moveClockHands
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(hourHandAngle);
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 + hourHandAngle];
    rotationAnimation.duration = 1.;
    rotationAnimation.repeatCount = 100;
    
    [hourHand.layer addAnimation:rotationAnimation forKey:kHourHandRotationAnimationKey];
    
    CABasicAnimation *minuteHandRotationAnimation;
    minuteHandRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    minuteHandRotationAnimation.fromValue = @(minuteHandAngle);
    minuteHandRotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 + minuteHandAngle];
    minuteHandRotationAnimation.duration = .6;
    minuteHandRotationAnimation.repeatCount = 100;
    
    [minuteHand.layer addAnimation:minuteHandRotationAnimation forKey:kMinuteHandRotationAminationKey];
}

- (void)printAngles
{
    printf("minuteHandAngle: %f\n", minuteHandAngle);
    printf("hourHandAngle: %f\n\n", hourHandAngle);
}

@end
