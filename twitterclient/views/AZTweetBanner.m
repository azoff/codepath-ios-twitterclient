//
//  AZTweetBanner.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZTweetBanner.h"
#import "AZErrorUtil.h"
#import "AZTwitterClient.h"
#import "AZNotificationUtil.h"
#import "AZComposeTweetController.h"
#import "AZNavigationController.h"

@interface AZTweetBanner ()

@property (weak, nonatomic) IBOutlet UIImageView *replyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;

@end

@implementation AZTweetBanner

- (void)setTweet:(AZTweet *)tweet
{
    _tweet = tweet;
    [self renderImages];
}


-(void)awakeFromNib
{
    for (id imageView in @[self.favoriteImageView, self.replyImageView, self.retweetImageView]) {
        id tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap:)];
        [imageView setUserInteractionEnabled:YES];
        [imageView addGestureRecognizer:tap];
    }
}

-(IBAction)imageViewDidTap:(UIGestureRecognizer *)sender
{
    if ([sender.view isEqual:self.favoriteImageView]) {
        [self toggleFavorite];
    } else if ([sender.view isEqual:self.retweetImageView]) {
        [self toggleRetweet];
    } else {
        [self pushReplyTo];
    }
}

-(void)pushReplyTo
{
    id controller = [[AZComposeTweetController alloc] initWithTweet:self.tweet];
    [[AZNavigationController controller] pushViewController:controller animated:YES];
}

-(void)toggleFavorite
{
    id oldImage = self.favoriteImageView.image;
    self.favoriteImageView.image = [UIImage imageNamed:@"favorite"];
    
    id success = ^(AZTweet *tweet) {
        self.tweet.favorited = !self.tweet.favorited;
        [self renderImages];
    };
    
    id failure = ^(NSError *error) {
        [AZErrorUtil showError:error view:self.superview];
        self.favoriteImageView.image = oldImage;
    };
    
    if (self.tweet.favorited) {
        [[AZTwitterClient client] destroyFavoriteTweet:self.tweet success:success failure:failure];
    } else {
        [[AZTwitterClient client] createFavoriteTweet:self.tweet success:success failure:failure];
    }
    
}

-(void)toggleRetweet
{
    if (self.tweet.retweeted && !self.tweet.retweetID)
        return;
    
    id oldImage = self.retweetImageView.image;
    self.retweetImageView.image = [UIImage imageNamed:@"retweet"];
    
    id success = ^(AZTweet *tweet) {
        self.tweet.retweeted = !self.tweet.retweeted;
        self.tweet.retweetID = tweet.twitterID;
        [self renderImages];
    };
    
    id failure = ^(NSError *error) {
        [AZErrorUtil showError:error view:self.superview];
        self.retweetImageView.image = oldImage;
    };
    
    if (self.tweet.retweeted) {
        [[AZTwitterClient client] destroyRetweet:self.tweet success:success failure:failure];
    } else {
        [[AZTwitterClient client] createRetweet:self.tweet success:success failure:failure];
    }
    
}

- (void)renderImages
{
    self.favoriteImageView.image = [UIImage imageNamed:(self.tweet.favorited ? @"favorite_on" : @"favorite_hover")];
    self.retweetImageView.image = [UIImage imageNamed:(self.tweet.retweeted ? @"retweet_on" : @"retweet_hover")];
}

@end
