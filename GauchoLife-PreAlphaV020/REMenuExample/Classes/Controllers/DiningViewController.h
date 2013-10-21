//
//  DiningViewController.h
//  REMenuExample
//
//  Created by Liu Zhe on 10/17/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RootViewController.h"
#import "MZDayPicker.h"
#import "TPGestureTableViewCell.h"


@interface DiningViewController : RootViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet MZDayPicker *dayPicker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
