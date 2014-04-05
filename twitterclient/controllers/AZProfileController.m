//
//  AZProfileController.m
//  twitterclient
//
//  Created by Jonathan Azoff on 4/4/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "AZProfileController.h"
#import "AZRootController.h"
#import "AZUserPageController.h"

@interface AZProfileController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic) UIPageViewController *headerController;

@end

@implementation AZProfileController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Me";
        self.headerController = [[AZUserPageController alloc] init];
        [self addChildViewController:self.headerController];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:[AZRootController controller] action:@selector(toggleMenuView)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.headerController.view.frame = self.headerView.bounds;
    [self.headerView addSubview:self.headerController.view];
    [self.headerController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
