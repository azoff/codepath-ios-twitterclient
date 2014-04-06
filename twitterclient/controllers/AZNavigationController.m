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
#import "AZMenuController.h"
#import "AZErrorUtil.h"
#import "AZProfileController.h"

@interface AZNavigationController ()

@end

@implementation AZNavigationController

- (id)init
{
    self = [self initWithRootViewController:[[[self stateControllerClass] alloc] init]];
    if (self) {
        [AZNotificationUtil onEventWithName:AZTwitterClientEventAuthorized observer:self selector:@selector(didChangeState:)];
        [AZNotificationUtil onEventWithName:AZTwitterClientEventDeauthorized observer:self selector:@selector(didChangeState:)];
        [AZNotificationUtil onEventWithName:AZMenuControllerSelectionEvent observer:self selector:@selector(didMenuChange:)];
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

- (void)didChangeState:(NSNotification *)notification
{
    [self updateState];
}

- (void)didMenuChange:(NSNotification *)notification
{
    Class controllerClass;
    AZMenuControllerSelection code = [notification.object integerValue];
    switch(code) {
        case AZMenuControllerSelectionTimeline:
            controllerClass = [AZHomeTimelineController class];
            break;
        case AZMenuControllerSelectionMentions:
            // TODO
            break;
        case AZMenuControllerSelectionProfile:
            controllerClass = [AZProfileController class];
            break;
    }
    
    if (controllerClass == nil) {
        [AZErrorUtil showError:[AZErrorUtil errorWithDomain:@"menu" code:code description:@"Not A Required User Story :)"] view:self.view];
    } else {
        [self changeRootViewController:controllerClass];
    }
    
}

- (void)changeRootViewController:(Class)controllerClass
{
    if (controllerClass != [self.viewControllers[0] class]) {
        [self setViewControllers:@[[[controllerClass alloc] init]] animated:YES];
    }
}

- (void)updateState
{
    [self changeRootViewController:[self stateControllerClass]];
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
   return [[self alloc] init];
}

@end
