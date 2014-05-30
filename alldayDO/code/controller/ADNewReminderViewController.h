//
//  ADNewReminderViewController.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADNewReminderViewController : UIViewController <UIGestureRecognizerDelegate, UITextFieldDelegate>

- (IBAction)cancelarTouched:(id)sender;
- (IBAction)horaChangedTouched:(id)sender;
- (IBAction)addReminderTouched:(id)sender;

@end
