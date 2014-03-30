//
//  AZViewTweetController.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZTweetDetailsController.h"
#import "AZUserBanner.h"
#import "AZTweetBanner.h"

@interface AZTweetDetailsController ()

@property (weak, nonatomic) IBOutlet AZUserBanner *userBanner;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet AZTweetBanner *tweetBanner;

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
    self.tweetTextLabel.text = self.tweet.text;
    self.tweetBanner.tweet = self.tweet;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
