//
//  AZUser.h
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "MUJSONResponseSerializer.h"
#import "MUJSONResponseSerializer+AZURLParsing.h"

@interface AZUser : MUJSONResponseObject

@property (nonatomic) NSString * name;
@property (nonatomic) NSURL * profileImageUrl;
@property (nonatomic) NSString * screenName;
@property (nonatomic) NSNumber * twitterID;

@end
