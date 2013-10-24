//
//  DiningViewController.m
//  REMenuExample
//
//  Created by Liu Zhe on 10/17/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DiningViewController.h"
#import "TPGestureTableViewCell.h"
#import "TPDataModel.h"
#import "SWTableViewCell.h"
//#import "SIAlertView.h"
#import "UIScrollView+BluredBackground.h"
#import "JFBluredScrollSubview.h"
#import "UIImage+ImageEffects.h"
#import <QuartzCore/QuartzCore.h>
#import "CXAlertView.h"
#import "CSNotificationView.h"
#import "UIColor+RGBA.h"
#import "FavoriteViewController.h"
#import "FavoriteList.h"
//#import "NRSimplePlist.h"
//#import "TabBarViewController.h"
//#import "PXAlertView.h"

#define TEST_UIAPPEARANCE 0
//#define LOGS_ENABLED NO
//#import "DTAlertView.h"
//#import "UIViewController+CWPopup.h"
//#import "PopUpViewController.h"

@interface DiningViewController () <MZDayPickerDelegate, MZDayPickerDataSource, UITableViewDataSource, UITableViewDelegate,TPGestureTableViewCellDelegate, SWTableViewCellDelegate>//, DTAlertViewDelegate>
@property (nonatomic,strong) NSMutableArray *tableData;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,retain) TPGestureTableViewCell *currentCell;
@property (readwrite,nonatomic) int badgeCount;
@property  (strong, nonatomic)FavoriteViewController *favorite;
@property (strong, nonatomic) FavoriteList *dishFavoriteList;
@end

@implementation DiningViewController


- (FavoriteList *)dishFavoriteList
{
    if (!_dishFavoriteList)
        _dishFavoriteList = [[FavoriteList alloc] init];
    return _dishFavoriteList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopup)];
    //tapRecognizer.numberOfTapsRequired = 1;
    //tapRecognizer.delegate = self;
    //[self.view addGestureRecognizer:tapRecognizer];
//    self.useBlurForPopup = YES;
        //
    self.title = @"Dining";
    self.badgeCount = 0;
    //[NRSimplePlist editNumberPlist:@"badgePlist" withKey:@"badgeNumber" andNumber:@(self.badgeCount)];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"TableViewData" ofType:@"plist"];
    self.tableData = [[NSMutableArray alloc]init];
    NSArray *sourceArray = [[NSArray alloc] initWithContentsOfFile:path];
    //self.favorite.badge = self.badgeCount;
    for(int i=0;i<[sourceArray count];i++){
        NSDictionary *dict = [sourceArray objectAtIndex:i];
        TPDataModel *item = [[TPDataModel alloc]init];
        item.title = [dict objectForKey:@"Title"];
        item.detail = [dict objectForKey:@"Detail"];
        item.isExpand=NO;
        [self.tableData addObject:item];
    }
    
    //self.tableData = [@[] mutableCopy];
    self.dayPicker.delegate = self;
    self.dayPicker.dataSource = self;
    self.dayPicker.dayNameLabelFontSize = 12.0f;
    self.dayPicker.dayLabelFontSize = 18.0f;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"EE"];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    NSInteger Day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    /*
     *  You can set month, year using:
     *  self.dayPicker.month = 9;
     *  self.dayPicker.year = 2013;
     *  [self.dayPicker setActiveDaysFrom:1 toDay:30];
     *  [self.dayPicker setCurrentDay:15 animated:NO];
     *
     *  or set up date range:
     */
    
    [self.dayPicker setStartDate:[NSDate dateFromDay:01 month:month year:year] endDate:[NSDate dateFromDay:30 month:month year:year]];
    
    [self.dayPicker setCurrentDate:[NSDate dateFromDay:Day month:month year:year] animated:NO];
    
    //Table View
    UIImage *backgroundImage = [[UIImage imageNamed:@"cupcakes1"] applyDarkEffect];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    UIImage *lightBackground = [[UIImage imageNamed:@"cupcakes1"] applyLightEffect];
    self.tableView.frame = CGRectMake(0, self.dayPicker.frame.origin.y + self.dayPicker.frame.size.height, self.tableView.frame.size.width, self.view.bounds.size.height-self.dayPicker.frame.size.height);
    self.tableView.rowHeight = 90;
    self.tableView.allowsSelection = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundView = backgroundView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor clearColor/*white*/];
    [self.tableView setDarkBluredBackground:backgroundImage];//backgroundImage
    [self.tableView setLightBluredBackground:lightBackground];
    [self.view addSubview:self.tableView];
    
    //Tab Bar
    
    //AlertView
#if TEST_UIAPPEARANCE
    [[SIAlertView appearance] setMessageFont:[UIFont systemFontOfSize:13]];
    [[SIAlertView appearance] setTitleColor:[UIColor greenColor]];
    [[SIAlertView appearance] setMessageColor:[UIColor purpleColor]];
    [[SIAlertView appearance] setCornerRadius:12];
    [[SIAlertView appearance] setShadowRadius:20];
    [[SIAlertView appearance] setViewBackgroundColor:[UIColor colorWithRed:0.891 green:0.936 blue:0.978 alpha:1.000]];
#endif
}

//Daypicker
- (NSString *)dayPicker:(MZDayPicker *)dayPicker titleForCellDayNameLabelInDay:(MZDay *)day
{
    return [self.dateFormatter stringFromDate:day.date];
}


- (void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
{
    NSLog(@"Did select day %@",day.day);
    
    //[self.tableData addObject:day];
    //[self.tableView reloadData];
}

- (void)dayPicker:(MZDayPicker *)dayPicker willSelectDay:(MZDay *)day
{
    NSLog(@"Will select day %@",day.day);
}

//Table View
#pragma mark - UITableViewDataSource

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TPDataModel *item=(TPDataModel*)[self.tableData objectAtIndex:indexPath.row];
    if(item.isExpand==NO){
        return 60;
    }
    return 100;
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseIdentifier = @"Cell";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        /*NSMutableArray *leftUtilityButtons = [NSMutableArray new];
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        [rightUtilityButtons addUtilityButtonWithColor: [UIColor clearColor]
         //[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                 title:@"More"];
        [rightUtilityButtons addUtilityButtonWithColor: [UIColor clearColor]
         //[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                 title:@"Delete"];*/
        
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:reuseIdentifier
                                  containingTableView:_tableView // Used for row height and selection
                                   leftUtilityButtons:nil/*leftUtilityButtons*/
                                  rightUtilityButtons:nil/*rightUtilityButtons*/];
        cell.delegate = self;
    }
    /*TPDataModel *item = (TPDataModel *)[self.tableData objectAtIndex:indexPath.row];
    MZDay *day = self.tableData[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",day.day];
    cell.detailTextLabel.text = day.name;
    cell.itemData = item;*/
    //NSDate *dateObject = self.tableData[indexPath.row];
    TPDataModel *item = [[TPDataModel alloc]init];
    item = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.detail;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    return cell;
}

//This function is where all the magic happens
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set background color of cell here if you don't want white
    JFBluredScrollSubview *subView = [[JFBluredScrollSubview alloc] initWithFrame:cell.bounds];
    subView.scrollView = self.tableView;
    cell.selectedBackgroundView = subView;
    cell.backgroundColor = [UIColor clearColor];
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //!!!FIX for issue #1 Cell position wrong------------
    if(cell.layer.position.x != 0){
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }
    
    //4. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.40];//animationDuration:0.5
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

#pragma mark - SWTableViewDelegate

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*TPGestureTableViewCell *cell = (TPGestureTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if(cell.revealing==YES){
        cell.revealing=NO;
        return;
    }
    TPDataModel *item=(TPDataModel*)[self.tableData objectAtIndex:indexPath.row];
    item.isExpand=!item.isExpand;
    cell.itemData=item;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];*/
    
    //AlertView with count down
    
    /*SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Title1" andMessage:@"Count down"];
    [alertView addButtonWithTitle:@"Button1"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Button1 Clicked");
                          }];
    [alertView addButtonWithTitle:@"Button2"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Button2 Clicked");
                          }];
    [alertView addButtonWithTitle:@"Button3"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Button3 Clicked");
                          }];
    
    alertView.willShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willShowHandler", alertView);
    };
    alertView.didShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didShowHandler", alertView);
    };
    alertView.willDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willDismissHandler", alertView);
    };
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didDismissHandler", alertView);
    };
    
    //    alertView.cornerRadius = 4;
    //    alertView.buttonFont = [UIFont boldSystemFontOfSize:12];
    [alertView show];
    
    alertView.title = @"3";
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        alertView.title = @"2";
        alertView.titleColor = [UIColor yellowColor];
        alertView.titleFont = [UIFont boldSystemFontOfSize:30];
    });
    delayInSeconds = 2.0;
    popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        alertView.title = @"1";
        alertView.titleColor = [UIColor greenColor];
        alertView.titleFont = [UIFont boldSystemFontOfSize:40];
    });
    delayInSeconds = 3.0;
    popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"1=====");
        [alertView dismissAnimated:YES];
        NSLog(@"2=====");
    });
    [(SWTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] hideUtilityButtonsAnimated:YES];*/
    /*[PXAlertView showAlertWithTitle:@"The Matrix"
                            message:@"Pick the Red pill, or the blue pill"
                        cancelTitle:@"Blue"
                         otherTitle:@"Red"
                         completion:^(BOOL cancelled) {
                             if (cancelled) {
                                 NSLog(@"Cancel (Blue) button pressed");
                             } else {
                                 NSLog(@"Other (Red) button pressed");
                             }
                         }];*/
    NSString *alertString = [NSString stringWithFormat:@"Do you want to add %@\nto your favorite dish?",[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:alertString message:nil cancelButtonTitle:nil];
    [alertView addButtonWithTitle:@"Yes"
                             type:CXAlertViewButtonTypeCustom
                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                              alertView.showBlurBackground = YES;
                              [alertView dismiss];
                              self.badgeCount = indexPath.row;
                              self.dishFavoriteList.index = self.badgeCount;
                              //NSLog(@"added at index %d",self.badgeCount);
                              self.dishFavoriteList.DishTitle = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
                              self.dishFavoriteList.Description = [tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text;
                              //NSLog(@"NSNumber is %@",@(self.badgeCount));
                              //NSLog(@"edited number %@",[NRSimplePlist valuePlist:@"badgePlist" withKey:@"badgeNumber"]);
                              //self.favorite.badge = self.badgeCount;
                              //NSLog(@"badge count = %d",self.badgeCount);
                              [CSNotificationView showInViewController:self
                                                                 style:CSNotificationViewStyleSuccess
                                                               message:@"Added Successfully"];
                              //[NRSimplePlist editNumberPlist:@"favoritePlist" withKey:@"badgeNumber" andNumber:@(self.badgeCount)];
                             //NSLog(@"%d",[[NRSimplePlist valuePlist:@"favoritePlist" withKey:@"badgeNumber"] intValue]);
                          }];
    [alertView addButtonWithTitle:@"Cancel"
                             type:CXAlertViewButtonTypeCancel
                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                              [alertView dismiss];
                              [CSNotificationView showInViewController:self
                                                                 style:CSNotificationViewStyleError
                                                               message:@"Dish not saved."];
                          }];
    [alertView show];
    NSLog(@"cell selected at index path %d", indexPath.row);
//
}

/*- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed"); //count down button
            DTAlertView *alertTest = [DTAlertView alertViewWithTitle:@"Demo" message:@"This is normal alert view." delegate:self cancelButtonTitle:@"Cancel" positiveButtonTitle:@"OK"];*/
            //[alertTest show];
            /*PopUpViewController *samplePopUpViewController = [[PopUpViewController alloc] initWithNibName:@"PopUpViewController" bundle:nil];
            [self presentPopupViewController:samplePopUpViewController animated:YES completion:^(void) {
                NSLog(@"popup view presented");
            }];
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Title1" andMessage:@"Count down"];
            [alertView addButtonWithTitle:@"Button1"
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alertView) {
                                      NSLog(@"Button1 Clicked");
                                  }];
            [alertView addButtonWithTitle:@"Button2"
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alertView) {
                                      NSLog(@"Button2 Clicked");
                                  }];
            [alertView addButtonWithTitle:@"Button3"
                                     type:SIAlertViewButtonTypeDestructive
                                  handler:^(SIAlertView *alertView) {
                                      NSLog(@"Button3 Clicked");
                                  }];
            
            alertView.willShowHandler = ^(SIAlertView *alertView) {
                NSLog(@"%@, willShowHandler", alertView);
            };
            alertView.didShowHandler = ^(SIAlertView *alertView) {
                NSLog(@"%@, didShowHandler", alertView);
            };
            alertView.willDismissHandler = ^(SIAlertView *alertView) {
                NSLog(@"%@, willDismissHandler", alertView);
            };
            alertView.didDismissHandler = ^(SIAlertView *alertView) {
                NSLog(@"%@, didDismissHandler", alertView);
            };
            
            //    alertView.cornerRadius = 4;
            //    alertView.buttonFont = [UIFont boldSystemFontOfSize:12];
            [alertView show];
            
            alertView.title = @"3";
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                alertView.title = @"2";
                alertView.titleColor = [UIColor yellowColor];
                alertView.titleFont = [UIFont boldSystemFontOfSize:30];
            });
            delayInSeconds = 2.0;
            popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                alertView.title = @"1";
                alertView.titleColor = [UIColor greenColor];
                alertView.titleFont = [UIFont boldSystemFontOfSize:40];
            });
            delayInSeconds = 3.0;
            popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSLog(@"1=====");
                [alertView dismissAnimated:YES];
                NSLog(@"2=====");
            });
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [self.tableData removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}*/

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)cellDidBeginPan:(TPGestureTableViewCell *)cell{
    
}

- (void)cellDidReveal:(TPGestureTableViewCell *)cell{
    if(self.currentCell!=cell){
        self.currentCell.revealing=NO;
        self.currentCell=cell;
    }
    
}

#pragma mark - Popup Functions

/*- (void)dismissPopup {
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^{
            NSLog(@"popup view dismissed");
        }];
    }
}*/

#pragma mark - DTAlertView Delegate Methods

/*- (void)alertView:(DTAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"You click button title : %@", alertView.clickedButtonTitle);
    
    if (alertView.textField != nil) {
        NSLog(@"Inputed Text : %@", alertView.textField.text);
    }
}*/


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return touch.view == self.view;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setDayPicker:nil];
    [super viewDidUnload];

}

- (NSUInteger)getBadge
{
    return self.badgeCount;
}


@end
