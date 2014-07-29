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

- (IBAction)newReminderTouched:(id)sender;

@end
