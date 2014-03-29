//
//  AZTimelineController.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZHomeTimelineController.h"
#import "AZTwitterClient.h"
#import "AZErrorUtil.h"
#import "MBProgressHUD.h"

static NSInteger const MAX_ALLOWED_TWEETS = 800;
static NSInteger const SCROLL_THRESHOLD   = 5;

@interface AZHomeTimelineController ()

@property (nonatomic) NSMutableArray *tweets;
@property (nonatomic) NSInteger tweetCount;
@property (nonatomic) MBProgressHUD *progressHUD;
@property (weak, nonatomic) IBOutlet AZTweetTableView *tweetTableView;

@end

@implementation AZHomeTimelineController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Home";
        self.tweets = [NSMutableArray array];
        self.tweetCount = 0;
        self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        self.progressHUD.mode = MBProgressHUDModeAnnularDeterminate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tweetTableView.delegate   = self;
    self.tweetTableView.dataSource = self;
    [self.tweetTableView addRefreshTarget:self action:@selector(refreshTweets)];
    [self fetchTweetsWithAnimation:YES];
}

- (void)fetchTweetsWithAnimation:(BOOL)animated
{
    
    if (animated) {
        self.progressHUD.progress = 0;
        [self.progressHUD show:YES];
    }
    
    AZTwitterClient *client = [AZTwitterClient client];
    id params = [NSMutableDictionary dictionary];
    if (self.tweets.count > 0)
        params[@"max_id"] = [self.tweets.lastObject twitterID];
    
    [client homeTimelineWithParameters:params success:^(NSArray *tweets) {
        [self.tweets addObjectsFromArray:tweets];
        [self.tweetTableView reloadData];
        [self.tweetTableView.refreshControl endRefreshing];
        if (animated)
            [self.progressHUD hide:YES];
    } failure:^(NSError *error) {
        [AZErrorUtil showError:error view:self.view];
    }];
    
    if (animated) {
        [client.operationQueue.operations.lastObject setDownloadProgressBlock:^(NSUInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
            self.progressHUD.progress = ((float)totalBytesRead) / totalBytesExpectedToRead;
        }];
    }
}

- (AZTweet *)tweetForRowAtIndexPath:(NSIndexPath *)path
{
    return self.tweetCount > path.row ? self.tweets[path.row] : nil;
}


- (NSInteger)tweetCount
{
    return self.tweets.count;
}

- (void)refreshTweets
{
    [self.tweets removeAllObjects];
    [self fetchTweetsWithAnimation:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [self.tweetTableView heightForTweet:[self tweetForRowAtIndexPath:indexPath]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweetCount == 0 ? 0 : MAX_ALLOWED_TWEETS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tweetCount > 0 && indexPath.row >= (self.tweetCount - SCROLL_THRESHOLD))
        [self fetchTweetsWithAnimation:NO];
    return [self.tweetTableView cellForRowAtIndexPath:indexPath withTweet:[self tweetForRowAtIndexPath:indexPath]];
}

@end
