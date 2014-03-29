//
//  AZRuntimeUtil.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZRuntimeUtil.h"
#import <objc/runtime.h>

@implementation AZRuntimeUtil

+(void)swizzleWithToken:(dispatch_once_t)onceToken class:(Class)class originalSelector:(SEL)originalSelector withNewSelector:(SEL)swizzledSelector
{
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

@end
