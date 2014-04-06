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
#import "AZHomeTimelineController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface AZProfileController ()

@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UIView *timelineView;

@property (nonatomic) UIPageViewController *headerController;
@property (nonatomic) UIViewController *timelineController;
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;

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
    return YES;
}

-(void)setUser:(AZUser *)user
{
    _user = user;
    if (user == nil) return;    
    self.title = user.screenName;
    self.timelineController = [[AZHomeTimelineController alloc] init];
    self.headerController = [AZUserPageController controllerWithUser:user];
    [self.headerView setImageWithURLRequest:user.profileBannerImageRequest placeholderImage:nil success:nil failure:nil];
    self.followersLabel.text = [self.user.followersCount stringValue];
    self.followingLabel.text = [self.user.followingCount stringValue];
    self.tweetsLabel.text = [self.user.tweetCount stringValue];
    [self addChildViewController:self.headerController];
    [self addChildViewController:self.timelineController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:[AZRootController controller] action:@selector(toggleMenuView)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.user == nil) {
        if (![self useCurrentUser])
            [AZNotificationUtil onEventWithName:AZCurrentUserEventLoaded observer:self selector:@selector(useCurrentUser)];

    }
    self.headerController.view.frame = self.headerView.bounds;
    [self.headerView addSubview:self.headerController.view];
    [self.headerController didMoveToParentViewController:self];
    
    self.timelineController.view.frame = self.timelineView.bounds;
    [self.timelineView addSubview:self.timelineController.view];
    [self.timelineController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
