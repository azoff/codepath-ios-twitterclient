//
//  AZRuntimeUtil.h
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZRuntimeUtil : NSObject

+(void)swizzleWithToken:(dispatch_once_t)onceToken class:(Class)class originalSelector:(SEL)originalSelector withNewSelector:(SEL)swizzledSelector;

@end
