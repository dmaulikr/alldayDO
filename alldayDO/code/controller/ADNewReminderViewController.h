//
//  ADNewReminderViewController.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADNewReminderViewController : UIViewController <UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *dataTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;

- (IBAction)cancelarTouched:(id)sender;
- (IBAction)horaChangedTouched:(id)sender;
- (IBAction)addReminderTouched:(id)sender;

@end
