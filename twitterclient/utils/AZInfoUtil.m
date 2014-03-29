//
//  AZInfoUtil.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZInfoUtil.h"

static NSString * const RESOURCE_NAME = @"twitterclient-Info";

@interface AZInfoUtil ()

@property (nonatomic, weak) NSDictionary *info;

@end

@implementation AZInfoUtil

-(NSDictionary *)info
{
    if (_info != nil) return _info;
    return _info = [[NSBundle mainBundle] infoDictionary];
}

-(NSString *)urlScheme
{
    if (_urlScheme != nil) return _urlScheme;
    return _urlScheme = self.info[@"CFBundleURLTypes"][0][@"CFBundleURLSchemes"][0];
}

+(instancetype)util
{
    static id _util = nil;
    static dispatch_once_t _predicate;
    dispatch_once(&_predicate, ^{ _util = [[self alloc] init]; });
    return _util;
}

@end
