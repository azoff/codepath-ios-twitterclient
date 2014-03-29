//
//  AZTweet.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZTweet.h"
#import "MHPrettyDate.h"

@implementation AZTweet

- (instancetype)init
{
    if(self = [super init]) {
        self.propertyMap = @{@"id": @"twitterID",
                             @"created_at": @"createdDate"};
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
        self.dateFormatter = dateFormatter;
    }
    return self;
}

-(NSString *)createdDatePretty
{
    return [MHPrettyDate prettyDateFromDate:self.createdDate
                                 withFormat:MHPrettyDateShortRelativeTime];
}

@end
