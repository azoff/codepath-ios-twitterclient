//
//  AZCurrentUser.h
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZUser.h"

extern NSString* AZCurrentUserEventLoaded;

@interface AZCurrentUser : AZUser

+(instancetype)currentUser;

@end
