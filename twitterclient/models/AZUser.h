//
//  AZUser.h
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "MUJSONResponseSerializer.h"

@interface AZUser : MUJSONResponseObject

@property (nonatomic) NSString * name;
@property (nonatomic, readonly) NSURL * profileImageUrl;
@property (nonatomic, readonly) NSURL * profileBannerImageUrl;
@property (nonatomic) NSString * profileImageUrlString;
@property (nonatomic) NSString * profileBannerImageUrlString;
@property (nonatomic) NSString * screenName;
@property (nonatomic) NSNumber * twitterID;

-(NSURLRequest *)profileImageRequest;
-(NSURLRequest *)profileBannerImageRequest;
-(NSString *)atName;

@end
