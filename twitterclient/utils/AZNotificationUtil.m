//
//  AZAppUtil.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZNotificationUtil.h"

@implementation AZNotificationUtil

+(void)triggerEventWithName:(NSString *)name data:(id)data
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:data];
}

+(void)onEventWithName:(NSString *)name usingBlock:(void (^)(NSNotification *note))block
{
    [[NSNotificationCenter defaultCenter] addObserverForName:name object:nil queue:nil usingBlock:block];
}

+(void)onEventWithName:(NSString *)name observer:(id)observer selector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:nil];
}


@end
