//
//  AZTweet.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZTweet.h"

@implementation AZTweet

- (instancetype)init
{
    if(self = [super init]) {
        self.propertyMap = @{@"id": @"twitterID"};
    }
    return self;
}


@end
