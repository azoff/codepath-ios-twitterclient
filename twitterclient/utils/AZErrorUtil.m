//
//  AZErrorUtil.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZErrorUtil.h"

@implementation AZErrorUtil

+(void)showError:(NSError*)error delegate:(id<UIApplicationDelegate>)delegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:error.localizedDescription
                                   delegate:delegate
                          cancelButtonTitle:@"Dismiss"
                          otherButtonTitles:nil] show];
    });
}

+(NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description
{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: description};
    return [NSError errorWithDomain:domain code:code userInfo:userInfo];
}

@end
