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

@implementation AZTweetTableView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
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
    return 200; // TODO: base on cell size
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
