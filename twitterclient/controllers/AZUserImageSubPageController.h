//
//  AZUserImageSubPageController.h
//  twitterclient
//
//  Created by Jonathan Azoff on 4/5/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZUser.h"

@interface AZUserImageSubPageController : UIViewController

+(id)controllerWithUser:(AZUser *)user;
-(id)initWithUser:(AZUser *)user;

@property (nonatomic) AZUser* user;

@end
