//
//  AZMenuController.m
//  twitterclient
//
//  Created by Jonathan Azoff on 4/4/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZRootController.h"
#import "AZNavigationController.h"
#import "AZMenuController.h"
#import "AZNotificationUtil.h"

@interface AZRootController ()

@property (nonatomic) CGPoint lastPan;
@property (nonatomic) CGFloat maxPanX;
@property (nonatomic) UINavigationController *contentController;
@property (nonatomic) UIViewController *menuController;

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;

- (IBAction)onDrag:(UIPanGestureRecognizer *)sender;

@end

@implementation AZRootController

- (id)init
{
    self = [super init];
    if (self) {
        self.contentController = [AZNavigationController controller];
        self.menuController    = [AZMenuController controller];
        [self addChildViewController:self.contentController];
        [self addChildViewController:self.menuController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up content view
    self.contentController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:self.contentController.view];
    [self.contentController didMoveToParentViewController:self];
    
    // set up menu view
    self.menuController.view.frame = self.menuView.bounds;
    [self.menuView addSubview:self.menuController.view];
    [self.menuController didMoveToParentViewController:self];
    
    self.maxPanX = self.menuView.frame.size.width;
    [AZNotificationUtil onEventWithName:AZMenuControllerSelectionEvent observer:self selector:@selector(toggleMenuView)];
    
}


+ (instancetype)controller
{
    static id _controller = nil;
    static dispatch_once_t _predicate;
    dispatch_once(&_predicate, ^{ _controller = [[self alloc] init]; });
    return _controller;
}

- (void)panContentView:(CGFloat)delta
{
    self.leadingConstraint.constant  = MAX(0, MIN(self.maxPanX, self.leadingConstraint.constant + delta));
    self.trailingConstraint.constant = -self.leadingConstraint.constant;
    [self.contentView layoutIfNeeded];
}

-(void)animateMenuView:(BOOL)open withDuration:(CGFloat)duration
{
    CGFloat delta = open ? self.maxPanX : -self.maxPanX;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                     animations:^{ [self panContentView:delta]; }
                     completion:nil];
}

- (void)toggleMenuView
{
    BOOL open = self.leadingConstraint.constant <= 0;
    [self animateMenuView:open withDuration:0.3];
}

- (IBAction)onDrag:(UIPanGestureRecognizer *)sender
{
    CGPoint p;
    
    switch (sender.state) {
        default: break;
        case UIGestureRecognizerStateChanged:
            p = [sender translationInView:self.contentView];
            [self panContentView:p.x - self.lastPan.x];
            break;
        case UIGestureRecognizerStateEnded:
            p = [sender velocityInView:self.contentView];
            [self animateMenuView:p.x > 0 withDuration:self.maxPanX / p.x];
            break;
    }
    
    self.lastPan = p;
    
}

@end
