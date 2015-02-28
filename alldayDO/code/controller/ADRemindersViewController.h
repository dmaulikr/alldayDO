//
//  ADRemindersCollectionViewController.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 05/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADRemindersViewModel.h"

@interface ADRemindersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *hexaconAllButton;
@property (weak, nonatomic) IBOutlet UIButton *hexaconDoneButton;
@property (weak, nonatomic) IBOutlet UIButton *hexaconUndoneButton;

@property (weak, nonatomic) IBOutlet UILabel *totalRemindersLabel;
@property (weak, nonatomic) IBOutlet UILabel *doneReminders;
@property (weak, nonatomic) IBOutlet UILabel *undoneReminders;

@property (weak, nonatomic) IBOutlet UITabBarItem *addButton;
@property (weak, nonatomic) IBOutlet UITabBarItem *settingsButton;
@property (weak, nonatomic) IBOutlet UITabBarItem *aboutButton;

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

- (IBAction)hexaconAllTouched:(id)sender;
- (IBAction)hexaconDoneTouched:(id)sender;
- (IBAction)hexaconUndoneTouched:(id)sender;

@end
