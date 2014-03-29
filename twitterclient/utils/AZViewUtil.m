//
//  AZViewUtil.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZViewUtil.h"
#import "MBProgressHUD.h"

@implementation AZViewUtil

+(void)showSpinnerInView:(UIView *)view
{
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+(void)hideSpinnerInView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
