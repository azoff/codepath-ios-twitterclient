//
//  MUJSONResponseSerializer+AZURLParsing.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "MUJSONResponseSerializer+AZURLParsing.h"
#import "AZRuntimeUtil.h"
#import <objc/runtime.h>

@implementation MUJSONResponseSerializer (AZURLParsing)

// swizzle the old parser so that it can recognize URL classes
+(void)load {
    static dispatch_once_t onceToken;
    [AZRuntimeUtil swizzleWithToken:onceToken
                              class:[self class]
                   originalSelector:@selector(validateObject:forPropertyName:withClass:)
                    withNewSelector:@selector(AZURLParsing__validateObject:forPropertyName:withClass:)];
}

- (id)AZURLParsing__validateObject:(id)object forPropertyName:(NSString *)propertyName withClass:(Class)propertyClass
{
    // NSURL
    if([propertyClass isSubclassOfClass:[NSURL class]]) {
        if([object isKindOfClass:[NSString class]])
            object = [NSURL URLWithString:object];
    } else {
        object = [self AZURLParsing__validateObject:object forPropertyName:propertyName withClass:propertyClass];
    }
    
    return object;

}

@end
