//
//  ADEditReminderViewController.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ADEditReminderViewModel.h"
#import "ADEditReminderViewControllerDelegate.h"

typedef enum {
    ADAddMode,
    ADEditMode
} ADActionMode;

@interface ADEditReminderViewController : UIViewController 

@property (nonatomic) ADActionMode actionMode;

@property (nonatomic, strong) ADEditReminderViewModel *viewModel;

@property (nonatomic, strong) id<ADEditReminderViewControllerDelegate> delegate;

@end
