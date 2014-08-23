//
//  ADEditReminderViewControllerDelegate.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 10/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADEditReminderViewController;
@class ADLembrete;

@protocol ADEditReminderViewControllerDelegate <NSObject>

@required

- (void)newReminderViewController:(ADEditReminderViewController *)newReminderViewController
                  didSaveReminder:(ADLembrete *)reminder;

- (void)newReminderViewControllerDidCancelReminder:(ADEditReminderViewController *)newReminderViewController;

@end
