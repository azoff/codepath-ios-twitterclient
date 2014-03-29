//
//  AZTweetTableView.h
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZTweet.h"
#import "AZTweetTableViewCell.h"


@interface AZTweetTableView : UITableView

- (AZTweetTableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath withTweet:(AZTweet *)tweet;
- (CGFloat)heightForTweet:(AZTweet *)tweetOrNil;

@property (nonatomic, weak, readonly) UIRefreshControl *refreshControl;

- (void)addRefreshTarget:(id)target action:(SEL)action;

@end
