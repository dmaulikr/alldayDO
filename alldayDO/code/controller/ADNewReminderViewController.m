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

#import <JVFloatLabeledTextField.h>


@interface ADNewReminderViewController ()

@property (nonatomic, strong) JVFloatLabeledTextField *descriptionTextField;
@property (nonatomic, strong) JVFloatLabeledTextField *periodoTextField;
@property (nonatomic, strong) JVFloatLabeledTextField *dataTextField;

- (void)_dismissKeyboard;
- (void)_initialization;
- (void)_addGesturesRecognizer;
- (void)_refreshTimeLabel:(UIDatePicker*)datePicker;

@end

@implementation ADNewReminderViewController

#pragma mark - Getter Methods -

- (JVFloatLabeledTextField *)descriptionTextField {
    if (!_descriptionTextField) {
        _descriptionTextField = [[JVFloatLabeledTextField alloc] init];
        _descriptionTextField.frame = CGRectMake(0.f,
                                                 40.f,
                                                 self.view.frame.size.width,
                                                 44.f);
        [_descriptionTextField setPlaceholder:@"Do que que você precisa ser lembrado?"
                            floatingTitle:@"Iremos te lembrar da atividade"];
        _descriptionTextField.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    }
    return _descriptionTextField;
}

- (JVFloatLabeledTextField *)periodoTextField {
    if (!_periodoTextField) {
        _periodoTextField = [[JVFloatLabeledTextField alloc] init];
        _periodoTextField.frame = CGRectMake(0.f,
                                             80.f,
                                             self.view.frame.size.width,
                                             44.f);
        [_periodoTextField setPlaceholder:@"Qual a periodicidade?"
                            floatingTitle:@"Entre os intervalos de"];
        _periodoTextField.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    }
    return _periodoTextField;
}

- (JVFloatLabeledTextField *)dataTextField {
    if (!_dataTextField) {
        _dataTextField = [[JVFloatLabeledTextField alloc] init];
        _dataTextField.frame = CGRectMake(0.f,
                                          120.f,
                                          self.view.frame.size.width,
                                          44.f);
        [_dataTextField setPlaceholder:@"Qual o horário"
                            floatingTitle:@"No horário das"];
        _dataTextField.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    }
    return _dataTextField;
}


#pragma mark - UIViewController Methods -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initialization];
    
    [self _addGesturesRecognizer];
    
    [self.view addSubview:self.descriptionTextField];
    [self.view addSubview:self.periodoTextField];
    [self.view addSubview:self.dataTextField];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self _dismissKeyboard];
}

#pragma mark - Private Methods -

- (void)_addGesturesRecognizer {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismissKeyboard)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
}

- (void)_dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)_initialization {
    self.descriptionTextField.delegate = self;
    [self.descriptionTextField becomeFirstResponder];
    
    UIDatePicker *dataPicker = [[UIDatePicker alloc] init];
    dataPicker.datePickerMode = UIDatePickerModeTime;
    [dataPicker addTarget:self
                   action:@selector(_refreshTimeLabel:)
         forControlEvents:UIControlEventAllEvents];
    self.dataTextField.delegate = self;
    self.dataTextField.inputView = dataPicker;
}

- (void)_refreshTimeLabel:(UIDatePicker*)datePicker {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setDateFormat:@"hh"];
    NSString *horaFormated = [NSString stringWithFormat:@"%@",[outputFormatter stringFromDate:datePicker.date]];
    
    [outputFormatter setDateFormat:@"mm"];
    NSString *minutosFormated = [NSString stringWithFormat:@"%@",[outputFormatter stringFromDate:datePicker.date]];

    [outputFormatter setDateFormat:@"a"];
    NSString *periodoFormated = [NSString stringWithFormat:@"%@",[outputFormatter stringFromDate:datePicker.date]];
    
    self.dataTextField.text = [NSString stringWithFormat:@"%@:%@ %@", horaFormated, minutosFormated, periodoFormated];
}

#pragma mark - UITextFieldDelegate Methods -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - IBOutlet Methods -

- (IBAction)addReminderTouched:(id)sender {
    
    if (![self.descriptionTextField.text isEqual:@""]) {
        ADLembrete *lembrete = [NSEntityDescription insertNewObjectForEntityADLembrete];
//        lembrete.data = self.timePicker.date;
        lembrete.descricao = self.descriptionTextField.text;

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