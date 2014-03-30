//
//  AZDispatchUtil.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZDispatchUtil.h"

@implementation AZDispatchUtil

+(void)setTimeout:(NSInteger)seconds forBlock:(dispatch_block_t)block;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), block);
}

@end
