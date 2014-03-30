//
//  AZNavigationController.h
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZNavigationController : UINavigationController

+(instancetype)controller;

- (void)enableComposeBarItemWithTarget:(id)target action:(SEL)action;

@end
