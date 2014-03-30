//
//  AZComposeTweetController.m
//  twitterclient
//
//  Created by Jonathan Azoff on 3/29/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZComposeTweetController.h"
#import "AZUserBanner.h"
#import "AZCurrentUser.h"
#import "AZNotificationUtil.h"
#import "AZNavigationController.h"
#import "MBProgressHUD.h"
#import "AZTwitterClient.h"
#import "AZErrorUtil.h"
#import "AZDispatchUtil.h"

@interface AZComposeTweetController ()

@property (weak, nonatomic) IBOutlet AZUserBanner *userBanner;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (nonatomic) MBProgressHUD *progressHUD;

@end

@implementation AZComposeTweetController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Compose";
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (id)initWithTweet:(AZTweet *)tweet
{
    self = [self init];
    if (self) {
        _tweet = tweet;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![self useCurrentUser])
        [AZNotificationUtil onEventWithName:AZCurrentUserEventLoaded observer:self selector:@selector(useCurrentUser)];
    if (self.tweet)
        self.tweetTextView.text = [NSString stringWithFormat:@"%@ ", self.tweet.user.screenName];
    self.tweetTextView.delegate = self;
    [self.tweetTextView becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(sendTweet)];
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [self finishEditing];
        return NO;
    }
    return YES;
}

-(void)finishEditing
{
    [self.tweetTextView resignFirstResponder];
    [self.tweetTextView endEditing:YES];
}

- (MBProgressHUD *)progressHUD
{
    if (_progressHUD != nil)
        return _progressHUD;
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.mode = MBProgressHUDModeAnnularDeterminate;
    id checkmark = [UIImage imageNamed:@"37x-Checkmark"];
    _progressHUD.customView = [[UIImageView alloc] initWithImage:checkmark];
    [self.view addSubview:_progressHUD];
    return _progressHUD;
}

- (void)sendTweet
{
 
    self.progressHUD.progress = 0;
    self.progressHUD.labelText = @"Sending Tweet";
    [self.progressHUD show:YES];
    [self finishEditing];
    
    AZTwitterClient *client = [AZTwitterClient client];
    [client updateStatusWithText:self.tweetTextView.text success:^(AZTweet *tweet) {
        //TODO: add tweet to the global list
        self.progressHUD.mode = MBProgressHUDModeCustomView;
        self.progressHUD.labelText = @"Tweet Sent!";
        [self.progressHUD hide:YES afterDelay:1];
        [AZDispatchUtil setTimeout:1 forBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSError *error) {
        [AZErrorUtil showError:error view:self.view];
    }];
    
    [client.operationQueue.operations.lastObject setDownloadProgressBlock:^(NSUInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
        if (totalBytesExpectedToRead < 0)
            totalBytesExpectedToRead = totalBytesRead;
        self.progressHUD.progress = ((float)totalBytesRead) / totalBytesExpectedToRead;
    }];
    
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

@end
