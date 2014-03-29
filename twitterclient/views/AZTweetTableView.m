//
//  AZTweetTableView.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZTweetTableView.h"

static NSString *const CELL_NIB_NAME = @"AZTweetTableViewCell";

@interface AZTweetTableView ()

@property (nonatomic) AZTweetTableViewCell *dummyCell;

@end

@implementation AZTweetTableView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorInset = UIEdgeInsetsZero;
        id nib = [UINib nibWithNibName:CELL_NIB_NAME bundle:[NSBundle mainBundle]];
        [self registerNib:nib forCellReuseIdentifier:CELL_NIB_NAME];

        //NOTE: using a temp table view controller makes the behavior less janky
        UITableViewController *temp = [[UITableViewController alloc] init];
        temp.tableView = self;
        temp.refreshControl = [[UIRefreshControl alloc] init];
        [self addSubview: temp.refreshControl];
        _refreshControl = temp.refreshControl;
    }
    return self;
}

- (AZTweetTableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath withTweet:(AZTweet *)tweet
{
    AZTweetTableViewCell *cell = [self dequeueReusableCellWithIdentifier:CELL_NIB_NAME forIndexPath:indexPath];
    cell.tweet = tweet;
    return cell;
}

- (void)addRefreshTarget:(id)target action:(SEL)action
{
    [self.refreshControl addTarget:target action:action forControlEvents:UIControlEventValueChanged];
}

- (CGFloat)heightForTweet:(AZTweet *)tweetOrNil
{
    if (self.dummyCell == nil)
        self.dummyCell = [self dequeueReusableCellWithIdentifier:CELL_NIB_NAME];
    return [self.dummyCell heightForTweet:tweetOrNil];
}

@end
