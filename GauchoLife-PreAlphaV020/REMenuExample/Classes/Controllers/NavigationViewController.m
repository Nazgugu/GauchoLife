//
//  NavigationViewController.m
//  REMenuExample
//
//  Created by Roman Efimov on 4/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//
//  Sample icons from http://icons8.com/download-free-icons-for-ios-tab-bar
//

#import "NavigationViewController.h"
#import "DiningViewController.h"
#import "MapViewController.h"
#import "GoldViewController.h"
#import "EventsViewController.h"

@interface NavigationViewController ()

@property (strong, readwrite, nonatomic) REMenu *menu;

@end

@implementation NavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (REUIKitIsFlatMode()) {
        [self.navigationBar performSelector:@selector(setBarTintColor:) withObject:[UIColor colorWithRed:0/255.0 green:60/255.0 blue:255/255.0 alpha:1]];
        self.navigationBar.tintColor = [UIColor whiteColor];
    } else {
        self.navigationBar.tintColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
    }
    
    __typeof (self) __weak weakSelf = self;
    REMenuItem *diningItem = [[REMenuItem alloc] initWithTitle:@"Dining"
                                                    subtitle:@"Browse menu in dinning commons"
                                                       image:[UIImage imageNamed:@"coctail"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
                                                          DiningViewController *controller = [[DiningViewController alloc] init];
                                                          [weakSelf setViewControllers:@[controller] animated:YES];
                                                      }];
    
    REMenuItem *mapItem = [[REMenuItem alloc] initWithTitle:@"Map"
                                                       subtitle:@"Find where is your classroom"
                                                          image:[UIImage imageNamed:@"compass"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                             MapViewController *controller = [[MapViewController alloc] init];
                                                             [weakSelf setViewControllers:@[controller] animated:YES];
                                                         }];
    
    REMenuItem *goldItem = [[REMenuItem alloc] initWithTitle:@"GOLD"
                                                        subtitle:@"Always enroll in the right class"
                                                           image:[UIImage imageNamed:@"school"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                              GoldViewController *controller = [[GoldViewController alloc] init];
                                                              [weakSelf setViewControllers:@[controller] animated:YES];
                                                          }];
    
    //activityItem.badge = @"12";
    
    REMenuItem *eventsItem = [[REMenuItem alloc] initWithTitle:@"Events"
                                                       subtitle:@"What's happening on campus!"
                                                          image:[UIImage imageNamed:@"today"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                             EventsViewController *controller = [[EventsViewController alloc] init];
                                                             [weakSelf setViewControllers:@[controller] animated:YES];
                                                         }];
    
    // You can also assign a custom view for any particular item
    // Uncomment the code below and add `customViewItem` to `initWithItems` array, for example:
    // self.menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem, customViewItem]]
    //
    /*
    UIView *customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor blueColor];
    customView.alpha = 0.4;
    REMenuItem *customViewItem = [[REMenuItem alloc] initWithCustomView:customView action:^(REMenuItem *item) {
        NSLog(@"Tap on customView");
    }];
    */
    
    diningItem.tag = 0;
    mapItem.tag = 1;
    goldItem.tag = 2;
    eventsItem.tag = 3;
    
    self.menu = [[REMenu alloc] initWithItems:@[diningItem, mapItem, goldItem, eventsItem]];
    
    // Background view
    //
    //self.menu.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    //self.menu.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //self.menu.backgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.600];

    //self.menu.imageAlignment = REMenuImageAlignmentRight;
    //self.menu.closeOnSelection = NO;
    //self.menu.appearsBehindNavigationBar = NO; // Affects only iOS 7
    if (!REUIKitIsFlatMode()) {
        self.menu.cornerRadius = 4;
        self.menu.shadowRadius = 4;
        self.menu.shadowColor = [UIColor blackColor];
        self.menu.shadowOffset = CGSizeMake(0, 1);
        self.menu.shadowOpacity = 1;
    }
    if (REUIKitIsFlatMode()) {
        self.menu.liveBlur = YES;
        self.menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleDark;
        //self.menu.liveBlurTintColor = [UIColor redColor];
    }

    self.menu.imageOffset = CGSizeMake(5, -1);
    self.menu.waitUntilAnimationIsComplete = NO;
    self.menu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        badgeLabel.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
        badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.00].CGColor;
    };
}

- (void)toggleMenu
{
    if (self.menu.isOpen)
        return [self.menu close];
    
    [self.menu showFromNavigationController:self];
}

@end
