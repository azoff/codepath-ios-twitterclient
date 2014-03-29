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

static NSInteger const SCROLL_THRESHOLD = 5;

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
        [self.view addSubview:self.tweetTableView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tweetTableView.tweetDataSource = self;
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

- (AZTweet *)tweetForRow:(NSInteger)row
{
    if (self.countTweetCurrent < self.countTweetTotal && row >= (self.countTweetTotal - SCROLL_THRESHOLD))
        [self fetchTweetsWithAnimation:NO];
    return self.tweets[row];
}

- (NSInteger)countTweetTotal
{
    return self.countTweetCurrent == 0 ? 0 : 800; // max tweets for home timeline
}

- (NSInteger)countTweetCurrent
{
    return self.tweets.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
