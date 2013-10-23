//
//  TabBarViewController.m
//  REMenuExample
//
//  Created by Liu Zhe on 10/21/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "TabBarViewController.h"
#import "FavoriteViewController.h"
#import "DiningViewController.h"
@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITabBarController *tbc = [[UITabBarController alloc] init];
    DiningViewController *DC = [[DiningViewController alloc] init];
    FavoriteViewController *FC = [[FavoriteViewController alloc] init];
    DC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Menu" image:[UIImage imageNamed:@"dish"] tag:1];
    FC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Favorites" image:[UIImage imageNamed:@"star"] tag:2];
    [tbc setViewControllers:@[DC,FC]];
    NSLog(@"Can You See me?");
    tbc.tabBar.translucent = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
