//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"
#import "JSPullToRefreshClock.h"

#define kPullLength 64.0f

@interface EGORefreshTableHeaderView ()

- (void)setState:(EGOPullRefreshState)aState;

@end

@implementation EGORefreshTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self setBackgroundColor:[UIColor blackColor]];
        
        
        clock = [[JSPullToRefreshClock alloc]initWithFrame:CGRectMake((frame.size.width - 50.0f) / 2.0f, (kPullLength - 50)/2 + frame.size.height - kPullLength, 50.0f, 50.0f)];
        [self addSubview:clock];
		
		[self setState:EGOOPullRefreshNormal];
        
        scrollViewPreviousContentOffset = 0;
		
    }
    return self;
}


#pragma mark - Setters

- (void)setState:(EGOPullRefreshState)aState
{	
	switch (aState) {
		case EGOOPullRefreshPulling:
			break;
		case EGOOPullRefreshNormal:
			[clock stopAnimatingClockHands];
			break;
		case EGOOPullRefreshLoading:
            [clock startAnimatingClockHands];
			break;
		default:
			break;
	}
	_state = aState;
}


#pragma mark - ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat val = scrollView.contentOffset.y - scrollViewPreviousContentOffset;
    if (val <= 0.) val *= -1.;
    
    if (scrollView.contentOffset.y < scrollViewPreviousContentOffset) {
        [clock scrollViewDidScrollDown:val];
    }
    else {
        [clock scrollViewDidScrollUp:val];
    }
    
    scrollViewPreviousContentOffset = scrollView.contentOffset.y;
    
	if (_state == EGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, kPullLength);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -kPullLength && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -kPullLength && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - kPullLength && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(kPullLength, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];
    
}


#pragma mark - Dealloc

- (void)dealloc {
	
	_delegate=nil;
    
    [super dealloc];
}

@end