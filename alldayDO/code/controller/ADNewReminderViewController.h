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

typedef enum {
    ADAddMode,
    ADEditMode
} ADActionMode;

@interface ADNewReminderViewController : UIViewController 

@property (nonatomic) ADActionMode actionMode;

@property (nonatomic, strong) ADNewReminderViewModel *viewModel;

@property (nonatomic, strong) id<ADNewReminderViewControllerDelegate> delegate;

@end
