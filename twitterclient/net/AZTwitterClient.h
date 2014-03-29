//
//  AZTwitterClient.h
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

extern NSString * const AZTwitterClientEventError;
extern NSString * const AZTwitterClientEventRequested;
extern NSString * const AZTwitterClientEventAuthorized;
extern NSString * const AZTwitterClientEventDeauthorized;

@interface AZTwitterClient : BDBOAuth1RequestOperationManager

+(instancetype)client;
-(BOOL)fetchRequestToken;
-(BOOL)fetchAccessTokenWithURL:(NSURL *)url;
-(void)homeTimelineWithParameters:(NSDictionary *)parameters
                          success:(void (^)(NSArray *tweets))success
                          failure:(void (^)(NSError *error))failure;

@end
