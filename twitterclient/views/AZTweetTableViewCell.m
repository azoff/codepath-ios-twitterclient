//
//  AZTweetTableViewCell.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZTweetTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface AZTweetTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userFullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;

@end

@implementation AZTweetTableViewCell

- (void)setTweet:(AZTweet *)tweet
{
    self.tweetTextLabel.text = tweet.text;
    self.userFullNameLabel.text = tweet.user.name;
    self.userScreenNameLabel.text = tweet.user.screenName;
    self.tweetDateLabel.text = tweet.createdDatePretty;
    [self.userImageView setImageWithURLRequest:tweet.user.profileImageRequest
                              placeholderImage:nil success:nil failure:nil];
}

-(CGFloat)heightForTweet:(AZTweet *)tweet
{
    id text = tweet == nil ? @"" : tweet.text;
    CGSize bounds = CGSizeMake(self.tweetTextLabel.frame.size.width, 1000);
    CGRect rect = [text boundingRectWithSize:bounds
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: self.tweetTextLabel.font}
                                     context:nil];
    return MAX(rect.size.height + 33, 68);
}

@end
