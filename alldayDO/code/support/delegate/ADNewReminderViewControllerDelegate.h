//
//  ADNewReminderViewControllerDelegate.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 10/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADNewReminderViewController;
@class ADLembrete;

@protocol ADNewReminderViewControllerDelegate <NSObject>

- (void)newReminderViewController:(ADNewReminderViewController *)newReminderViewController
                  didSaveReminder:(ADLembrete *)reminder;

@end
