//
//  AZProfileController.h
//  twitterclient
//
//  Created by Jonathan Azoff on 4/4/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZUser.h"

@interface AZProfileController : UIViewController

@property (nonatomic) AZUser *user;
- (id)initWithUser:(AZUser *)user;

@end
