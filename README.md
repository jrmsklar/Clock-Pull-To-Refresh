Clock-Pull-To-Refresh
=====================

**Pull to refresh class of a clock animating in all different types of ways.**

This utilizes a third party pull to refresh API (`EGORefreshTableHeaderView`), in addition to a newly created class (`JSPullToRefreshClock`),
to present a cool and fun pull to refresh animation.

When the `UITableView` in which the `JSPullToRefreshClock` is added to is pulled downwards, the minute and hour hands of the clock animate towards the noon position of the clock, and when pulled up, the minute and hour hands of the clock animate towards the 6 o'clock position of the clock.

When released, the clock hands both rotate clockwise at different rates, indicating that the data is loading.

## Usage

Simply add the following code to whichever file the `UITableView` is in which you wish to add the `JSPullToRefreshClock` to is implemented.

Add the following directly after the instantiation of the `UITableView`:
``` objective-c
if (_refreshHeaderView == nil) {
	EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
	view.delegate = self;
	[self.tableView addSubview:view];
	_refreshHeaderView = view;
}
```

Also add these delegate methods:
``` objective-c
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
    /* call method here to reload table data */
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        /* call doneLoadingTableViewData after data is fetched */
        [self doneLoadingTableViewData];
    });
    
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
}

- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading
}
```

First, create an ivar for the `_refreshHeaderView` of type `EGORefreshTableHeaderView`. Then add the above code in where specified.

## Demo

Build and run the `Clock-Pull-To-Refresh-Demo` project in Xcode to see a full demo of the `JSClockPullToRefresh`.

# Requirements

The `QuartzCore` framework is required.

## Screenshots

![screenshot1](/screenshot1.png)
![screenshot2](/screenshot2.png)
![screenshot3](/screenshot3.png)
