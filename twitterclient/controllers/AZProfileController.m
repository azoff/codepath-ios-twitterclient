//
//  AZProfileController.m
//  twitterclient
//
//  Created by Jonathan Azoff on 4/4/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZProfileController.h"
#import "AZCurrentUser.h"
#import "AZNotificationUtil.h"
#import "AZRootController.h"
#import "AZUserPageController.h"
#import "AZUserTweetsController.h"
#import "AZComposeTweetController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface AZProfileController ()

@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UIView *timelineView;

@property (nonatomic) UIPageViewController *headerController;
@property (nonatomic) UIViewController *timelineController;
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (nonatomic) BOOL loaded;

@end

@implementation AZProfileController

- (id)init
{
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (id)initWithUser:(AZUser *)user
{
    self = [self init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (BOOL)useCurrentUser
{
    if (!AZCurrentUser.currentUser) return NO;
    self.user = AZCurrentUser.currentUser;
    [self viewDidLoad];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStylePlain target:self action:@selector(compose)];
}

-(void)compose
{
    id controller = [[AZComposeTweetController alloc] initWithTweet:nil];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.user == nil) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:[AZRootController controller] action:@selector(toggleMenuView)];   
        if (![self useCurrentUser])
            [AZNotificationUtil onEventWithName:AZCurrentUserEventLoaded observer:self selector:@selector(useCurrentUser)];

    }
    
    if (self.user == nil || self.loaded) return;

    self.title = self.user.screenName;
    self.timelineController = [AZUserTweetsController controllerWithUser:self.user];
    self.headerController = [AZUserPageController controllerWithUser:self.user];
    [self.headerView setImageWithURLRequest:self.user.profileBannerImageRequest
                           placeholderImage:nil success:nil failure:nil];
    self.followersLabel.text = [self.user.followersCount stringValue];
    self.followingLabel.text = [self.user.followingCount stringValue];
    self.tweetsLabel.text = [self.user.tweetCount stringValue];
    [self addChildViewController:self.headerController];
    [self addChildViewController:self.timelineController];

    
    self.headerController.view.frame = self.headerView.bounds;
    [self.headerView addSubview:self.headerController.view];
    [self.headerController didMoveToParentViewController:self];
    
    self.timelineController.view.frame = self.timelineView.bounds;
    [self.timelineView addSubview:self.timelineController.view];
    [self.timelineController didMoveToParentViewController:self];
    
    self.loaded = true;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
