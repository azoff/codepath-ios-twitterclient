//
//  AZComposeTweetController.h
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZTweet.h"

@interface AZComposeTweetController : UIViewController

- (id)initWithTweet:(AZTweet *)tweet;

@property (nonatomic, readonly) AZTweet *tweet;

@end
