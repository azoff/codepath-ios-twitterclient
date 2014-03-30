//
//  AZNavigationController.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZNavigationController.h"
#import "AZLoginController.h"
#import "AZHomeTimelineController.h"
#import "AZTwitterClient.h"
#import "AZNotificationUtil.h"

@interface AZNavigationController ()

@end

@implementation AZNavigationController

- (id)init
{
    self = [self initWithRootViewController:[self newStateController]];
    if (self) {
        [AZNotificationUtil onEventWithName:AZTwitterClientEventAuthorized observer:self selector:@selector(didChangeState:)];
        [AZNotificationUtil onEventWithName:AZTwitterClientEventDeauthorized observer:self selector:@selector(didChangeState:)];
    }
    return self;
}

- (Class)stateControllerClass
{
    if ([[AZTwitterClient client] isAuthorized])
        return [AZHomeTimelineController class];
    else
        return [AZLoginController class];
}

- (UIViewController *)newStateController
{
    return [[[self stateControllerClass] alloc] init];
}

- (void)enableComposeBarItemWithTarget:(id)target action:(SEL)action
{
    self.navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                     initWithTitle:@"Compose"
                                                     style:UIBarButtonItemStylePlain
                                                     target:target action:action];
}

- (void)didChangeState:(NSNotification *)notification
{
    [self updateState];
}

- (void)updateState
{
    if ([self stateControllerClass] != [self.viewControllers[0] class])
        [self setViewControllers:@[[self newStateController]] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)controller
{
    static id _controller = nil;
    static dispatch_once_t _predicate;
    dispatch_once(&_predicate, ^{ _controller = [[self alloc] init]; });
    return _controller;
}

@end
