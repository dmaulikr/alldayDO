//
//  ADRemindersCollectionViewController.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 05/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADRemindersViewModel.h"

@interface ADRemindersTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *hexaconAllButton;
@property (weak, nonatomic) IBOutlet UIButton *hexaconDoneButton;
@property (weak, nonatomic) IBOutlet UIButton *hexaconUndoneButton;


@property (weak, nonatomic) IBOutlet UILabel *totalRemindersLabel;
@property (weak, nonatomic) IBOutlet UILabel *doneRemindersLabel;
@property (weak, nonatomic) IBOutlet UILabel *undoneRemindersLabel;

- (IBAction)newReminderTouched:(id)sender;

- (IBAction)hexaconAllTouched:(id)sender;
- (IBAction)hexaconDoneTouched:(id)sender;
- (IBAction)hexaconUndoneTouched:(id)sender;


@end
