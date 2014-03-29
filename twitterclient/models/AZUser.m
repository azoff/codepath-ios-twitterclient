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
            @"profile_img_url": @"profileImageUrl",
            @"screen_name": @"screenName",
            @"created_at": @"createdDate"
        };
    }
    return self;
}

@end
