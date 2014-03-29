//
//  AZUser.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZUser.h"

@interface MUJSONResponseObject (AZUser)

- (void)setObjectValue:(id)object forPropertyName:(NSString *)propertyName withClassName:(NSString *)className;

@end

@implementation AZUser

- (instancetype)init
{
    if(self = [super init]) {
        self.propertyMap = @{
            @"id": @"twitterID",
            @"profile_image_url": @"profileImageUrl",
            @"screen_name": @"screenName"
        };
    }
    return self;
}

-(NSString *)screenName
{
    return [NSString stringWithFormat:@"@%@", _screenName];
}

-(NSURLRequest *)profileImageRequest
{
    return [NSURLRequest requestWithURL:self.profileImageUrl];
}

- (void)setObjectValue:(id)object forPropertyName:(NSString *)propertyName withClassName:(NSString *)className
{
    Class propertyClass = NSClassFromString(className);
    
    // NSURL
    if([propertyClass isSubclassOfClass:[NSURL class]])
        if([object isKindOfClass:[NSString class]])
            return [self setValue:[NSURL URLWithString:object] forKey:propertyName];
    
    [super setObjectValue:object forPropertyName:propertyName withClassName:className];
    
}

@end
