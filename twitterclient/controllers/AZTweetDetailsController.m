//
//  AZViewTweetController.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZTweetDetailsController.h"
#import "AZUserBanner.h"

@interface AZTweetDetailsController ()

@property (weak, nonatomic) IBOutlet AZUserBanner *userBanner;

@end

@implementation AZTweetDetailsController

- (id)initWithTweet:(AZTweet *)tweet
{
    self = [self init];
    if (self) {
        _tweet = tweet;
        self.title = @"Tweet";
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userBanner.user = self.tweet.user;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
