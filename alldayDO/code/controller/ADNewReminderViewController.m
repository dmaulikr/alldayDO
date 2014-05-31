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

typedef enum {
    ADCycleTypeDay,
    ADCycleTypeWeek,
    ADCycleTypeMonth,
    ADCycleTypeYear,
} ADCycleType;


@interface ADNewReminderViewController () <UIGestureRecognizerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) JVFloatLabeledTextField *descriptionTextField;
@property (nonatomic, strong) JVFloatLabeledTextField *periodoTextField;
@property (nonatomic, strong) JVFloatLabeledTextField *dataTextField;

@property (nonatomic, strong) UIDatePicker *dataPicker;
@property (nonatomic, strong) UIPickerView *periodoPickerView;

- (void)_addGesturesRecognizer;
- (void)_addInputViewForTextField;
- (void)_dismissKeyboard;
- (void)_refreshTimeLabel:(UIDatePicker*)datePicker;
- (NSString *)_textForCycleType:(NSInteger)cycleType;

@end

@implementation ADNewReminderViewController

#pragma mark - UIViewController Methods -

- (id)init {
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 0, 300, 300);
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Getter Methods -

- (JVFloatLabeledTextField *)descriptionTextField {
    if (!_descriptionTextField) {
        _descriptionTextField = [[JVFloatLabeledTextField alloc] init];
        _descriptionTextField.delegate = self;
        _descriptionTextField.returnKeyType = UIReturnKeyNext;
        _descriptionTextField.frame = CGRectMake(0.f,
                                                 40.f,
                                                 self.view.frame.size.width,
                                                 44.f);
        [_descriptionTextField setPlaceholder:@"Do que que você precisa ser lembrado?"
                            floatingTitle:@"Iremos te lembrar da atividade"];
    }
    return _descriptionTextField;
}

- (JVFloatLabeledTextField *)periodoTextField {
    if (!_periodoTextField) {
        _periodoTextField = [[JVFloatLabeledTextField alloc] init];
        _periodoTextField.delegate = self;
        _periodoTextField.frame = CGRectMake(0.f,
                                             80.f,
                                             self.view.frame.size.width,
                                             44.f);
        [_periodoTextField setPlaceholder:@"Qual a periodicidade?"
                            floatingTitle:@"Entre os intervalos de"];
    }
    return _periodoTextField;
}

- (JVFloatLabeledTextField *)dataTextField {
    if (!_dataTextField) {
        _dataTextField = [[JVFloatLabeledTextField alloc] init];
        _dataTextField.delegate = self;
        _dataTextField.frame = CGRectMake(0.f,
                                          120.f,
                                          self.view.frame.size.width,
                                          44.f);
        [_dataTextField setPlaceholder:@"Qual o horário"
                            floatingTitle:@"No horário das"];
    }
    return _dataTextField;
}

- (UIDatePicker *)dataPicker {
    if (!_dataPicker) {
        _dataPicker = [[UIDatePicker alloc] init];
        _dataPicker.datePickerMode = UIDatePickerModeTime;
        [_dataPicker addTarget:self
                       action:@selector(_refreshTimeLabel:)
             forControlEvents:UIControlEventAllEvents];
    }
    return _dataPicker;
}

- (UIPickerView *)periodoPickerView {
    if (!_periodoPickerView) {
        _periodoPickerView = [[UIPickerView alloc] init];
        _periodoPickerView.dataSource = self;
        _periodoPickerView.delegate = self;
    }
    return _periodoPickerView;
}


#pragma mark - UIViewController Methods -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _addGesturesRecognizer];
    [self _addInputViewForTextField];
    
    [self.view addSubview:self.descriptionTextField];
    [self.view addSubview:self.periodoTextField];
    [self.view addSubview:self.dataTextField];
    
    [self.descriptionTextField becomeFirstResponder];
    
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

- (void)_addInputViewForTextField {
    self.dataTextField.inputView = self.dataPicker;
    self.periodoTextField.inputView = self.periodoPickerView;
}

- (void)_dismissKeyboard {
    [self.view endEditing:YES];
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

- (NSString *)_textForCycleType:(NSInteger)cycleType {
    NSString *text;
    
    switch (cycleType) {
        case ADCycleTypeDay:
            text = @"Diário";
            break;
        case ADCycleTypeWeek:
            text = @"Semanal";
            break;
        case ADCycleTypeMonth:
            text = @"Mensal";
            break;
        case ADCycleTypeYear:
            text = @"Anual";
            break;
    }
    
    return text;
}

#pragma mark - UITextFieldDelegate Methods -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.descriptionTextField) {
        [self.periodoTextField becomeFirstResponder];
    }
    return YES;
}

#pragma mark - IBOutlet Methods -

//- (IBAction)addReminderTouched:(id)sender {
//    
//    if (![self.descriptionTextField.text isEqual:@""]) {
//        ADLembrete *lembrete = [NSEntityDescription insertNewObjectForEntityADLembrete];
////        lembrete.data = self.timePicker.date;
//        lembrete.descricao = self.descriptionTextField.text;
//
//#warning arrumar label de periodo
////        lembrete.periodo = [NSNumber numberWithInt:1];
//        [[ADModel sharedInstance] saveChanges];
//
//        UILocalNotification *newNotification = [UILocalNotification defaultLocalNotificationWith:lembrete];
//        [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
//        
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//}
//
//- (IBAction)horaChangedTouched:(id)sender {
//    UIDatePicker *datePicker = (UIDatePicker*)sender;
//    [self _refreshTimeLabel:datePicker];
//}
//
//- (IBAction)cancelarTouched:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - UIPickerViewDataSource Methods -


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return sizeof(ADCycleType) - 1;
}

#pragma mark - UIPickerViewDelegate Methods -

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self _textForCycleType:row];
}

@end