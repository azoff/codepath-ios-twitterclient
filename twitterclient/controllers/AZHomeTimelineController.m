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
#import "AZNavigationController.h"
#import "AZComposeTweetController.h"
#import "AZTweetDetailsController.h"
#import "AZRootController.h"

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
    }
    return self;
}

- (MBProgressHUD *)progressHUD
{
    if (_progressHUD != nil)
        return _progressHUD;
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.mode = MBProgressHUDModeAnnularDeterminate;
    [self.view addSubview:_progressHUD];
    return _progressHUD;
}

- (NSMutableArray *)tweets
{
    if (_tweets != nil) return _tweets;
    return _tweets = [NSMutableArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tweetTableView.delegate   = self;
    self.tweetTableView.dataSource = self;
    [self.tweetTableView addRefreshTarget:self action:@selector(refreshTweets)];
    [self fetchTweetsWithAnimation:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
	NSIndexPath* selection = [self.tweetTableView indexPathForSelectedRow];
	if (selection)
		[self.tweetTableView deselectRowAtIndexPath:selection animated:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:[AZRootController controller] action:@selector(toggleMenuView)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStylePlain target:self action:@selector(compose)];
}

-(void)compose
{
    id controller = [[AZComposeTweetController alloc] initWithTweet:nil];
    [self.navigationController pushViewController:controller animated:YES];
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
            if (totalBytesExpectedToRead < 0)
                totalBytesExpectedToRead = totalBytesRead;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id controller = [[AZTweetDetailsController alloc] initWithTweet:[self tweetForRowAtIndexPath:indexPath]];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
