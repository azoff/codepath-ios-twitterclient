//
//  AZErrorUtil.h
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZErrorUtil : NSObject

+(NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description;
+(void)showError:(NSError*)error view:(UIView *)view;

@end
