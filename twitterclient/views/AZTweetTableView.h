//
//  AZTweetTableView.h
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZTweet.h"

@protocol AZTweetDataSource <NSObject>

@required
-(AZTweet *)tweetForRow:(NSInteger)row;
-(NSInteger)countTweetTotal;

@end

@interface AZTweetTableView : UITableView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<AZTweetDataSource> tweetDataSource;

@end
