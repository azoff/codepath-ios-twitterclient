//
//  AZAppDelegate.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZAppDelegate.h"
#import "AZTwitterClient.h"
#import "AZNotificationUtil.h"
#import "AZErrorUtil.h"
#import "AZRootController.h"

@implementation AZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [AZNotificationUtil onEventWithName:AZTwitterClientEventRequested observer:self selector:@selector(didReceiveAuthURL:)];
    [AZNotificationUtil onEventWithName:AZTwitterClientEventError observer:self selector:@selector(didReceiveError:)];
    self.window.rootViewController = [AZRootController controller];
    return YES;
}

- (void)didReceiveError:(NSNotification *)notification
{
    [AZErrorUtil showError:notification.object view:self.window];
}

- (void)didReceiveAuthURL:(NSNotification *)notification
{
    [[UIApplication sharedApplication] openURL:notification.object];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[AZTwitterClient client] fetchAccessTokenWithURL:url];
}

@end
