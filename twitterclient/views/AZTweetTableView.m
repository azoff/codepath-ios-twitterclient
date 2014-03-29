//
//  AZTweetTableView.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZTweetTableView.h"
#import "AZTweetTableViewCell.h"

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
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:CELL_NIB_NAME bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CELL_NIB_NAME];  
    }
    return self;
}

- (void)setTweetDataSource:(id<AZTweetDataSource>)tweetDataSource
{
    _tweetDataSource = tweetDataSource;
    [self reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    id tweet;
    NSInteger count = self.tweetDataSource.countTweetCurrent;
    NSInteger row   = indexPath.row;
    if (count > row)
        tweet = [self.tweetDataSource tweetForRow:row];
    if (self.dummyCell == nil)
        self.dummyCell = [self dequeueReusableCellWithIdentifier:CELL_NIB_NAME];
    return [self.dummyCell heightForTweet:tweet];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweetDataSource.countTweetTotal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AZTweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_NIB_NAME forIndexPath:indexPath];
    cell.tweet = [self.tweetDataSource tweetForRow:indexPath.row];
    return cell;
}

@end
