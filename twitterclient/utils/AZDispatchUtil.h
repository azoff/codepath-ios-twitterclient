//
//  AZDispatchUtil.h
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZDispatchUtil : NSObject

+(void)setTimeout:(NSInteger)seconds forBlock:(dispatch_block_t)block;

@end
