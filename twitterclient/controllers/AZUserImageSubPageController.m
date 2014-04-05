//
//  AZUserImageSubPageController.m
//  twitterclient
//
//  Created by Jonathan Azoff on 4/5/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZUserImageSubPageController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface AZUserImageSubPageController ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAliasLabel;

@end

@implementation AZUserImageSubPageController

- (id)initWithUser:(AZUser *)user
{
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

+(id)controllerWithUser:(AZUser *)user
{
    AZUserImageSubPageController *i = [self alloc];
    return [i initWithUser:user];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.user != nil) {
        [self.thumbImageView setImageWithURLRequest:self.user.profileImageRequest
                                   placeholderImage:nil success:nil failure:nil];
        self.userNameLabel.text = self.user.name;
        self.userAliasLabel.text = self.user.atName;
    }
    
    // Center Horizontally
    NSLayoutConstraint *centerXConstraint =
    [NSLayoutConstraint constraintWithItem:self.thumbImageView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0];
    [self.view addConstraint:centerXConstraint];
    
    // Center Vertically
    NSLayoutConstraint *centerYConstraint =
    [NSLayoutConstraint constraintWithItem:self.thumbImageView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0.0];
    [self.view addConstraint:centerYConstraint];
    
    
    
    [self.view layoutIfNeeded];
}

@end
