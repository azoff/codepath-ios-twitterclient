//
//  AZUserBanner.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZUserBanner.h"
#import "UIImageView+AFNetworking.h"

@interface AZUserBanner ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAliasLabel;
@property (weak, nonatomic) IBOutlet UIView *view;

@end

@implementation AZUserBanner


-(void)setUser:(AZUser *)user
{
    _user = user;
    if (user == nil) return;
    
    [self.userImageView setImageWithURLRequest:self.user.profileImageRequest
                              placeholderImage:nil success:nil failure:nil];
    self.userNameLabel.text = self.user.name;
    self.userAliasLabel.text = self.user.screenName;
}

@end
