//
//  AZUserPageController.m
//  twitterclient
//
//  Created by Jonathan Azoff on 4/4/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZUserPageController.h"
#import "AZUserImageSubPageController.h"

@interface AZUserPageController ()

@end

@implementation AZUserPageController

- (id)initWithUser:(AZUser *)user
{
    self = [super init];
    if (self) {
        self.user = user;
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [self setViewControllers:@[[AZUserImageSubPageController controllerWithUser:user]]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:nil];
    }
    return self;
}

+(id)controllerWithUser:(AZUser *)user
{
    AZUserPageController *i = [self alloc];
    return [i initWithUser:user];
}

@end
