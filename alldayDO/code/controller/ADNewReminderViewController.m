//
//  ADNewReminderViewController.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADNewReminderViewController.h"
#import "ADLembrete.h"
#import "ADModel.h"
#import "ADNotification.h"

#import "NSEntityDescription+ADToolkitAdditions.h"
#import "UILocalNotification+ADToolkitAdditions.h"


@interface ADNewReminderViewController ()

- (void)_dismissKeyboard;
- (void)_refreshTimeLabel:(UIDatePicker*)datePicker;

@end

@implementation ADNewReminderViewController


#pragma mark - UIViewController Methods -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.descriptionText becomeFirstResponder];
    self.descriptionText.delegate = self;
    
    [self _refreshTimeLabel:self.timePicker];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismissKeyboard)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self _dismissKeyboard];
}

#pragma mark - Private Methods -

- (void)_dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)_refreshTimeLabel:(UIDatePicker*)datePicker {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh"];
    self.horaLabel.text = [NSString stringWithFormat:@"%@",[outputFormatter stringFromDate:datePicker.date]];
    
    [outputFormatter setDateFormat:@"mm"];
    self.minutosLabel.text = [NSString stringWithFormat:@"%@",[outputFormatter stringFromDate:datePicker.date]];
    
    [outputFormatter setDateFormat:@"a"];
    self.periodoLabel.text = [NSString stringWithFormat:@"%@",[outputFormatter stringFromDate:datePicker.date]];
    
}

#pragma mark - UITextFieldDelegate Methods -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - IBOutlet Methods -

- (IBAction)addReminderTouched:(id)sender {
    
    if (![self.descriptionText.text isEqual:@""]) {
        ADLembrete *lembrete = [NSEntityDescription insertNewObjectForEntityADLembrete];
        lembrete.data = self.timePicker.date;
        lembrete.descricao = self.descriptionText.text;

#warning arrumar label de periodo
//        lembrete.periodo = [NSNumber numberWithInt:1];
        [[ADModel sharedInstance] saveChanges];

        UILocalNotification *newNotification = [UILocalNotification defaultLocalNotificationWith:lembrete];
        [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)horaChangedTouched:(id)sender {
    UIDatePicker *datePicker = (UIDatePicker*)sender;
    [self _refreshTimeLabel:datePicker];
}

- (IBAction)cancelarTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
