//
//  AZMenuontroller.h
//  twitterclient
//
//  Created by Jonathan Azoff on 4/4/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* AZMenuControllerSelectionEvent;

typedef NS_OPTIONS(NSUInteger, AZMenuControllerSelection) {
    AZMenuControllerSelectionTimeline,
    AZMenuControllerSelectionMentions,
    AZMenuControllerSelectionProfile
};

@interface AZMenuController : UIViewController

+ (instancetype)controller;

@end
