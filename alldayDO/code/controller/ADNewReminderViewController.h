//
//  ADNewReminderViewController.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ADNewReminderViewModel.h"
#import "ADNewReminderViewControllerDelegate.h"

@interface ADNewReminderViewController : UIViewController 

@property (nonatomic, strong) id<ADNewReminderViewControllerDelegate> delegate;

@end
