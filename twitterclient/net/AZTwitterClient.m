//
//  AZTwitterClient.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZTwitterClient.h"
#import "AZAppUtil.h"
#import "AZInfoUtil.h"
#import "AZErrorUtil.h"

NSString * const AZTwitterClientEventError        = @"AZTwitterClientEventError";
NSString * const AZTwitterClientEventRequested    = @"AZTwitterClientEventRequested";
NSString * const AZTwitterClientEventAuthorized   = @"AZTwitterClientEventAuthorized";
NSString * const AZTwitterClientEventDeauthorized = @"AZTwitterClientEventDeauthorized";

static NSString * const API_BASE_URL = @"https://api.twitter.com/1.1";
static NSString * const API_KEY      = @"D1WYrRIgUpuRYvlEoDX8pg";
static NSString * const API_SECRET   = @"TeQEzASax5JQS0Y9W35ZJMSZmTKJW5iK6vHtZS2g";
static NSString * const API_AUTH_URL = @"https://api.twitter.com/oauth/authorize?oauth_token=%@";
static NSString * const API_CALLBACK = @"oob";

@implementation AZTwitterClient

-(instancetype)init
{
    NSURL *baseURL = [NSURL URLWithString:API_BASE_URL];
    return [self initWithBaseURL:baseURL consumerKey:API_KEY consumerSecret:API_SECRET];
}

+(instancetype)client
{
    static id _client = nil;
    static dispatch_once_t _predicate;
    dispatch_once(&_predicate, ^{ _client = [[self alloc] init]; });
    return _client;
}

-(BOOL)fetchRequestToken
{
    NSString *callbackScheme = [[AZInfoUtil util] urlScheme];
    NSString *callbackURLString = [NSString stringWithFormat:@"%@://%@", callbackScheme, API_CALLBACK];
    NSURL *callbackURL = [NSURL URLWithString:callbackURLString];
    [self fetchRequestTokenWithPath:@"/oauth/request_token"
                             method:@"POST"
                        callbackURL:callbackURL
                              scope:nil
                            success:^(BDBOAuthToken *requestToken) {
                                NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:API_AUTH_URL, requestToken.token]];
                                [AZAppUtil triggerEventWithName:AZTwitterClientEventRequested data:authURL];
                            }
                            failure:^(NSError *error) {
                                [AZAppUtil triggerEventWithName:AZTwitterClientEventError data:error];
                            }];
    return YES;
}

-(BOOL)fetchAccessTokenWithURL:(NSURL *)url
{
    
    if (![url.scheme isEqualToString:[AZInfoUtil util].urlScheme])
        return NO;
    
    if (![url.host isEqualToString:API_CALLBACK])
        return NO;
    
    BDBOAuthToken *requestToken = [BDBOAuthToken tokenWithQueryString:url.query];
    if (requestToken == nil || requestToken.token == nil || requestToken.verifier == nil)
        return NO;
    
    [self fetchAccessTokenWithPath:@"/oauth/access_token"
                            method:@"POST"
                      requestToken:requestToken
                           success:^(BDBOAuthToken *accessToken) {
                               [AZAppUtil triggerEventWithName:AZTwitterClientEventAuthorized data:self];
                           }
                           failure:^(NSError *error) {
                               [AZAppUtil triggerEventWithName:AZTwitterClientEventError data:error];
                           }];
    return YES;
}

-(BOOL)deauthorize
{
    BOOL deauthed = [self deauthorize];
    if (deauthed) {
        [AZAppUtil triggerEventWithName:AZTwitterClientEventDeauthorized data:self];
    }
    return deauthed;
}

@end
