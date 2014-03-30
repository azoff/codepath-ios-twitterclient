//
//  AZCurrentUser.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZCurrentUser.h"
#import "AZTwitterClient.h"
#import "AZErrorUtil.h"
#import "AZNotificationUtil.h"

NSString *AZCurrentUserEventLoaded = @"AZCurrentUserEventLoaded";

static id _currentUser;

@implementation AZCurrentUser

+(instancetype)currentUser
{
    static dispatch_once_t _predicate;
    dispatch_once(&_predicate, ^{ [self fetchCurrentUser]; });
    return _currentUser;
}

+(void)fetchCurrentUser
{
    [[AZTwitterClient client] verifyCredentialsWithSuccess:^(AZUser *user) {
        _currentUser = user;
        [AZNotificationUtil triggerEventWithName:AZCurrentUserEventLoaded data:user];
    } failure:^(NSError *error) {
        [AZErrorUtil showError:error view:nil];
    }];
}

@end
