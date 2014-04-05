//
//  AZMenuontroller.m
//  twitterclient
//
//  Created by Jonathan Azoff on 4/4/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZMenuController.h"
#import "AZUserBanner.h"
#import "AZUser.h"
#import "AZNotificationUtil.h"
#import "AZCurrentUser.h"

NSString* AZMenuControllerSelectionEvent = @"AZMenuControllerSelectionEvent";

@interface AZMenuController ()

@property (weak, nonatomic) IBOutlet AZUserBanner *userBanner;
@property (weak, nonatomic) IBOutlet UIButton *timelineButton;
@property (weak, nonatomic) IBOutlet UIButton *mentionsButton;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;

- (IBAction)onButton:(id)sender;

@end

@implementation AZMenuController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![self useCurrentUser])
        [AZNotificationUtil onEventWithName:AZCurrentUserEventLoaded observer:self selector:@selector(useCurrentUser)];
}

- (BOOL)useCurrentUser
{
    if (!AZCurrentUser.currentUser) return NO;
    self.userBanner.user = AZCurrentUser.currentUser;
    return YES;
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

- (IBAction)onButton:(id)sender {
    [AZNotificationUtil triggerEventWithName:AZMenuControllerSelectionEvent data:[NSNumber numberWithInteger:[sender tag]]];
}

@end
