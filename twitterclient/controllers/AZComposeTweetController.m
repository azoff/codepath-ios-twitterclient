//
//  AZComposeTweetController.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZComposeTweetController.h"
#import "AZUserBanner.h"
#import "AZCurrentUser.h"
#import "AZNotificationUtil.h"

@interface AZComposeTweetController ()

@property (weak, nonatomic) IBOutlet AZUserBanner *userBanner;

@end

@implementation AZComposeTweetController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Compose";
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (id)initWithTweet:(AZTweet *)tweet
{
    self = [self init];
    if (self) {
        _tweet = tweet;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.tweet) self.userBanner.user = self.tweet.user;
    else if (![self useCurrentUser])
        [AZNotificationUtil onEventWithName:AZCurrentUserEventLoaded observer:self selector:@selector(useCurrentUser)];
}

- (BOOL)useCurrentUser
{
    if (!AZCurrentUser.currentUser) return NO;
    self.userBanner.user = AZCurrentUser.currentUser;
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
