//
//  AZUserDescSubPageController.m
//  twitterclient
//
//  Created by Jonathan Azoff on 4/5/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZUserDescSubPageController.h"

@interface AZUserDescSubPageController ()
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;

@end

@implementation AZUserDescSubPageController

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
    AZUserDescSubPageController *i = [self alloc];
    return [i initWithUser:user];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.user != nil) {
        self.descriptionLabel.text = self.user.description;
        self.linkLabel.text = self.user.urlString;
    }
    
    
    // Center Vertically
    NSLayoutConstraint *centerYConstraint =
    [NSLayoutConstraint constraintWithItem:self.descriptionLabel
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0];
    [self.view addConstraint:centerYConstraint];
    
    [self.view layoutIfNeeded];
}

@end
