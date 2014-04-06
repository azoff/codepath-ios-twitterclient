//
//  AZUserTweetsController.h
//  twitterclient
//
//  Created by Jonathan Azoff on 4/6/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZUser.h"
#import "AZTweetTableView.h"

@interface AZUserTweetsController : UIViewController<UITableViewDataSource, AZTweetTableViewDelegate>

+(id)controllerWithUser:(AZUser *)user;
-(id)initWithUser:(AZUser *)user;

@property (nonatomic) AZUser* user;

@end
