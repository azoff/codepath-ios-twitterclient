//
//  AZTweetTableViewCell.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZTweetTableViewCell.h"

@implementation AZTweetTableViewCell

- (void)setTweet:(AZTweet *)tweet
{
    NSLog(@"%@", tweet.text);
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
