//
//  AZUser.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZUser.h"

@implementation AZUser

- (instancetype)init
{
    if(self = [super init]) {
        self.propertyMap = @{
            @"id": @"twitterID",
            @"profile_image_url": @"profileImageUrlString",
            @"profile_banner_url": @"profileBannerImageUrlString",
            @"screen_name": @"screenName",
            @"statuses_count": @"tweetCount",
            @"friends_count": @"followingCount",
            @"followers_count": @"followersCount",
            @"url": @"urlString"
        };
    }
    return self;
}

-(void)setProfileImageUrlString:(NSString *)profileImageUrlString
{
    _profileImageUrlString = [profileImageUrlString stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    _profileImageUrl = [NSURL URLWithString:self.profileImageUrlString];
}

-(void)setProfileBannerImageUrlString:(NSString *)profileBannerImageUrlString
{
    _profileBannerImageUrlString = [profileBannerImageUrlString stringByAppendingString:@"/mobile_retina"];
    _profileBannerImageUrl = [NSURL URLWithString:self.profileBannerImageUrlString];
}

-(NSString *)atName
{
    return [NSString stringWithFormat:@"@%@", self.screenName];
}

-(NSURLRequest *)profileBannerImageRequest
{
    return [NSURLRequest requestWithURL:self.profileBannerImageUrl];
}

-(NSURLRequest *)profileImageRequest
{
    return [NSURLRequest requestWithURL:self.profileImageUrl];
}

@end
