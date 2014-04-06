//
//  AZUserPageController.m
//  twitterclient
//
//  Created by Jonathan Azoff on 4/4/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZUserPageController.h"
#import "AZUserImageSubPageController.h"
#import "AZUserDescSubPageController.h"

@interface AZUserPageController ()

@property (nonatomic) NSArray* controllerClasses;

@end

@implementation AZUserPageController

- (id)initWithUser:(AZUser *)user
{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:nil];
    if (self) {
        self.user = user;
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.controllerClasses = @[[AZUserImageSubPageController class], [AZUserDescSubPageController class]];
        [self setViewControllers:@[[self viewControllerAtIndex:0]]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:nil];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfViewController:viewController] + 1;
    return index < self.controllerClasses.count ? [self viewControllerAtIndex:index] : nil;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfViewController:viewController] - 1;
    return index > 0 ? [self viewControllerAtIndex:index] : nil;
}

-(UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    return [[self.controllerClasses objectAtIndex:index] controllerWithUser:self.user];
}

-(NSInteger)indexOfViewController:(UIViewController *)pageViewController
{
    return [self.controllerClasses indexOfObject:[pageViewController class]];
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.controllerClasses.count;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    UIColor *color = ([pendingViewControllers[0] class] == [AZUserDescSubPageController class]) ?
        [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] :
        [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = color;
    }];
    
}

+(id)controllerWithUser:(AZUser *)user
{
    AZUserPageController *i = [self alloc];
    return [i initWithUser:user];
}

@end
