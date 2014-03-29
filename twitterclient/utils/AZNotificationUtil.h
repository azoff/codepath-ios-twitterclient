//
//  AZAppUtil.h
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZNotificationUtil : NSObject

+(void)triggerEventWithName:(NSString *)name data:(id)data;
+(void)onEventWithName:(NSString *)name usingBlock:(void (^)(NSNotification *note))block;
+(void)onEventWithName:(NSString *)name observer:(id)observer selector:(SEL)selector;

@end
