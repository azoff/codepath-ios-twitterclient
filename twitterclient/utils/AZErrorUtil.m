//
//  AZErrorUtil.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/28/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZErrorUtil.h"
#import "MBProgressHUD.h"

@implementation AZErrorUtil

+(void)showError:(NSError*)error view:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
    id hud = [[MBProgressHUD alloc] initWithView:view];
    [hud setMode:MBProgressHUDModeText];
    [hud setLabelText:error.localizedDescription];
    [hud show:YES];
    [hud hide:YES afterDelay:1000];
}

+(NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description
{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: description};
    return [NSError errorWithDomain:domain code:code userInfo:userInfo];
}

@end
