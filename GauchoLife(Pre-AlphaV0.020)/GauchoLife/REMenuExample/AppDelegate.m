//
//  AppDelegate.m
//  REMenuExample
//
//  Created by Roman Efimov on 2/20/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
//#import "TabBarViewController.h"
#import "DiningViewController.h"
//#import "FavoriteViewController.h"
//#import "MapViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //NavigationViewController *Nav1 = [[NavigationViewController alloc] initWithRootViewController:DC];
    //NavigationViewController *Nav2 = [[NavigationViewController alloc] initWithRootViewController:FC];
    //TabBarViewController *tbc = [[TabBarViewController alloc] init];
    //[self copyPlist];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[NavigationViewController alloc] initWithRootViewController:[[DiningViewController alloc] init]];
    self.window.backgroundColor = [UIColor whiteColor];
    application.applicationIconBadgeNumber = 0;
    //self.window.rootViewController = tbc;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    /*int j = 0;
    int i = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Score"] intValue];
    NSLog (@"I am entering background and I have %d notifications that needs to be sent!",i);
    if (i > 0)
    {
        //retrieve notification data information
        if (!self.tableData)
            self.tableData = [[NSMutableArray alloc]init];
        for (FavoriteList *favoriteDish in [FavoriteList allFavoriteResults])
        {
            TPDataModel *item = [[TPDataModel alloc]init];
            item.title = favoriteDish.DishTitle;
            item.detail = favoriteDish.Description;
            item.dishDate = favoriteDish.dishDate;
            item.isExpand = NO;
            [self.tableData addObject:item];
        }
        while (j < i)
        {
            TPDataModel *item = [[TPDataModel alloc]init];
            item = [self.tableData objectAtIndex:j];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
            NSString *dateString = [formatter stringFromDate:item.dishDate];
            NSLog(@"%@",dateString);
            NSString *bodyString = [item.title stringByAppendingString:item.detail];
            UILocalNotification *dishNotice = [[UILocalNotification alloc] init];
            if (dishNotice)
                {
                    dishNotice.fireDate = item.dishDate;
                    dishNotice.timeZone = [NSTimeZone defaultTimeZone];
                    dishNotice.repeatInterval = 0;
                    dishNotice.alertBody = bodyString;
                    dishNotice.applicationIconBadgeNumber = 1;
                    [[UIApplication sharedApplication] scheduleLocalNotification:dishNotice];
                }
            j++;
        }
        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"Score"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }*/
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void) copyPlist {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =  [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"favoritePlist.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ( ![fileManager fileExistsAtPath:path] ) {
        NSLog(@"copying database to users documents");
        NSString *pathToSettingsInBundle = [[NSBundle mainBundle] pathForResource:@"favoritePlist" ofType:@"plist"];
        [fileManager copyItemAtPath:pathToSettingsInBundle toPath:path error:&error];
    }
    else {
        NSLog(@"users database already configured");
    }
}


@end
