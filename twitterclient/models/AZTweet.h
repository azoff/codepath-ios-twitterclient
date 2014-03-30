//
//  AZTweet.h
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUJSONResponseSerializer.h"
#import "AZUser.h"

@interface AZTweet : MUJSONResponseObject

@property (nonatomic) NSNumber * twitterID;
@property (nonatomic) NSString * text;
@property (nonatomic) NSDate * createdDate;
@property (nonatomic) AZUser * user;
@property (nonatomic) BOOL retweeted;
@property (nonatomic) BOOL favorited;

-(NSString *)createdDatePretty;

@end
