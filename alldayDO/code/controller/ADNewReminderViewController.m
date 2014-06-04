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

#import <JCRBlurView.h>

typedef enum {
    ADCycleTypeDay,
    ADCycleTypeWeek,
    ADCycleTypeMonth,
    ADCycleTypeYear,
} ADCycleType;

#define PADDING 10.f
#define ACTIVE_COLOR [UIColor sam_colorWithHex:@"#A459C1"];
#define DEFAULT_COLOR [UIColor sam_colorWithHex:@"#603172"];


@interface ADNewReminderViewController () <UIGestureRecognizerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) JVFloatLabeledTextField *descriptionTextField;
@property (nonatomic, strong) JVFloatLabeledTextField *periodoTextField;
@property (nonatomic, strong) JVFloatLabeledTextField *dataTextField;

@property (nonatomic, strong) UIDatePicker *dataPicker;
@property (nonatomic, strong) UIPickerView *periodoPickerView;

@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UIButton *cancelarButton;
@property (nonatomic, strong) UIButton *salvarButton;

@property (nonatomic, strong) UIToolbar *toolbarKeyboard;

- (void)_addBlurView;
- (void)_addReminderTouched;
- (void)_addGesturesRecognizer;
- (void)_addInputViewForTextField;
- (void)_addSubViews;
- (void)_cancelarTouched;
- (void)_dismissKeyboard;
- (void)_refreshTimeLabel:(UIDatePicker*)datePicker;
- (NSString *)_textForCycleType:(NSInteger)cycleType;

@end

@implementation ADNewReminderViewController

#pragma mark - UIViewController Methods -

- (id)init {
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 0, 300, 400);
        
        [self _addBlurView];
        [self _addGesturesRecognizer];
        [self _addInputViewForTextField];
        [self _addSubViews];
    }
    return self;
}

#pragma mark - Getter Methods -

- (JVFloatLabeledTextField *)descriptionTextField {
    if (!_descriptionTextField) {
        _descriptionTextField = [[JVFloatLabeledTextField alloc] init];
        _descriptionTextField.delegate = self;
        _descriptionTextField.returnKeyType = UIReturnKeyNext;
        _descriptionTextField.floatingLabelActiveTextColor = ACTIVE_COLOR;
        _descriptionTextField.floatingLabelTextColor = DEFAULT_COLOR;
        _descriptionTextField.frame = CGRectMake(PADDING, PADDING, self.view.width - PADDING, 44.f);
        [_descriptionTextField setPlaceholder:@"O que precisamos te lembrar?"
                            floatingTitle:@"Você não pode esquecer de"];
        _descriptionTextField.inputAccessoryView = self.toolbarKeyboard;
    }
    return _descriptionTextField;
}

- (JVFloatLabeledTextField *)periodoTextField {
    if (!_periodoTextField) {
        _periodoTextField = [[JVFloatLabeledTextField alloc] init];
        _periodoTextField.delegate = self;
        _periodoTextField.frame = CGRectMake(PADDING, self.descriptionTextField.maxY, self.view.width, 44.f);
        _periodoTextField.floatingLabelActiveTextColor = ACTIVE_COLOR;
        _periodoTextField.floatingLabelTextColor = DEFAULT_COLOR;
        [_periodoTextField setPlaceholder:@"Quando?"
                            floatingTitle:@"No periodo de"];
        _periodoTextField.inputAccessoryView = self.toolbarKeyboard;
    }
    return _periodoTextField;
}

- (JVFloatLabeledTextField *)dataTextField {
    if (!_dataTextField) {
        _dataTextField = [[JVFloatLabeledTextField alloc] init];
        _dataTextField.delegate = self;
        _dataTextField.frame = CGRectMake(PADDING, self.periodoTextField.maxY, self.view.width, 44.f);
        _dataTextField.floatingLabelActiveTextColor = ACTIVE_COLOR;
        _dataTextField.floatingLabelTextColor = DEFAULT_COLOR;
        [_dataTextField setPlaceholder:@"Que horas?"
                            floatingTitle:@"às"];
        _dataTextField.inputAccessoryView = self.toolbarKeyboard;
    }
    return _dataTextField;
}

- (UIDatePicker *)dataPicker {
    if (!_dataPicker) {
        _dataPicker = [[UIDatePicker alloc] init];
        _dataPicker.datePickerMode = UIDatePickerModeTime;
        _dataPicker.backgroundColor = [UIColor whiteColor];
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
        _periodoPickerView.backgroundColor = [UIColor whiteColor];
    }
    return _periodoPickerView;
}

- (UIButton *)iconButton {
    if (!_iconButton) {
        _iconButton = [UIButton buttonWithType:UIButtonTypeRoundedRect frame:CGRectMake(0, 0, 90.f, 90.f)];
        _iconButton.tintColor = [UIColor darkGrayColor];
        _iconButton.center = self.view.center;
        [_iconButton setY:(self.salvarButton.y - self.dataTextField.maxY) - PADDING];
        [_iconButton setImage:[UIImage imageNamed:@"newHexacon"] forState:UIControlStateNormal];
    }
    return _iconButton;
}

- (UIButton *)cancelarButton {
    if (!_cancelarButton) {
        _cancelarButton = [UIButton buttonWithCustomTypeAndFrame:CGRectMake(self.salvarButton.maxX,
                                                                            self.view.maxY - 60.f,
                                                                            self.view.width / 2,
                                                                            60.f)];
        [_cancelarButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        [_cancelarButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_cancelarButton addTarget:self action:@selector(_cancelarTouched) forControlEvents:UIControlEventAllEvents];
    }
    return _cancelarButton;
}

- (UIButton *)salvarButton {
    if (!_salvarButton) {
        _salvarButton = [UIButton buttonWithCustomTypeAndFrame:CGRectMake(0,
                                                                          self.view.maxY - 60.f,
                                                                          self.view.width / 2,
                                                                          60.f)];
        [_salvarButton setTitle:@"Salvar" forState:UIControlStateNormal];
        [_salvarButton setTitleColor:[UIColor colorWithRed:0.29 green:0.13 blue:0.38 alpha:1] forState:UIControlStateNormal];
        [_salvarButton addTarget:self action:@selector(_addReminderTouched) forControlEvents:UIControlEventAllEvents];
    }
    return _salvarButton;
}

- (UIToolbar *)toolbarKeyboard {
    if (!_toolbarKeyboard) {
        _toolbarKeyboard = [[UIToolbar alloc] init];
        [_toolbarKeyboard setW:self.view.width andH:38.f];
        UIBarButtonItem *flexibleButton = [UIBarButtonItem barButtonItemWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                         target:self
                                                                                         action:nil];
        UIBarButtonItem *nextButton = [UIBarButtonItem barButtonItemWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                     target:self
                                                                                     action:@selector(_dismissKeyboard)];
        nextButton.tintColor = ACTIVE_COLOR;
        _toolbarKeyboard.items = @[flexibleButton, nextButton];
    }
    return _toolbarKeyboard;
}

#pragma mark - UIViewController Methods -

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self _dismissKeyboard];
}

#pragma mark - Private Methods -

- (void)_addBlurView {
    JCRBlurView *blurView = [JCRBlurView new];
    blurView.frame = self.view.frame;
    blurView.layer.cornerRadius = 6.f;
    [self.view addSubview:blurView];
}

- (void)_addReminderTouched {
    
    if (![self.descriptionTextField.text isEqual:@""]) {
        ADLembrete *lembrete = [NSEntityDescription insertNewObjectForEntityADLembrete];
        lembrete.descricao = self.descriptionTextField.text;
        lembrete.periodo = [NSNumber numberWithInteger:[self.periodoPickerView selectedRowInComponent:0]];
        lembrete.data = self.dataPicker.date;
        
        [[ADModel sharedInstance] saveChanges];
        
        UILocalNotification *newNotification = [UILocalNotification defaultLocalNotificationWith:lembrete];
        [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)_addGesturesRecognizer {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismissKeyboard)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
}

- (void)_addInputViewForTextField {
    self.dataTextField.inputView = self.dataPicker;
    self.periodoTextField.inputView = self.periodoPickerView;
}

- (void)_addSubViews {
    [self.view addSubview:self.descriptionTextField];
    [self.view addSubview:self.periodoTextField];
    [self.view addSubview:self.dataTextField];
    [self.view addSubview:self.iconButton];
    [self.view addSubview:self.salvarButton];
    [self.view addSubview:self.cancelarButton];
}

- (void)_cancelarTouched {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)_refreshTimeLabel:(UIDatePicker*)datePicker {
    NSDate *date = [NSDate date];
    
    if (datePicker) {
        date = datePicker.date;
    }
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setDateFormat:@"hh"];
    NSString *horaFormated = [NSString stringWithFormat:@"%@",[outputFormatter stringFromDate:date]];
    
    [outputFormatter setDateFormat:@"mm"];
    NSString *minutosFormated = [NSString stringWithFormat:@"%@",[outputFormatter stringFromDate:date]];

    [outputFormatter setDateFormat:@"a"];
    NSString *periodoFormated = [NSString stringWithFormat:@"%@",[outputFormatter stringFromDate:date]];
    
    self.dataTextField.text = [NSString stringWithFormat:@"%@:%@ %@", horaFormated, minutosFormated, periodoFormated];
}

- (NSString *)_textForCycleType:(NSInteger)cycleType {
    NSString *text;
    
    switch (cycleType) {
        case ADCycleTypeDay:
            text = @"Diáriamente";
            break;
        case ADCycleTypeWeek:
            text = @"Semanalmente";
            break;
        case ADCycleTypeMonth:
            text = @"Mensalmente";
            break;
        case ADCycleTypeYear:
            text = @"Anualmente";
            break;
    }
    
    return text;
}

#pragma mark - UITextFieldDelegate Methods -

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.periodoTextField) {
        self.periodoTextField.text = [self _textForCycleType:0];
    } else if (textField == self.dataTextField) {
        [self _refreshTimeLabel:nil];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL edited = NO;
    
    if (textField == self.descriptionTextField) {
        edited = YES;
    }
    
    return edited;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.descriptionTextField) {
        [self.periodoTextField becomeFirstResponder];
    }
    
    return YES;
}

#pragma mark - UIPickerViewDataSource Methods -


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return sizeof(ADCycleType);
}

#pragma mark - UIPickerViewDelegate Methods -

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self _textForCycleType:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.periodoTextField.text = [self _textForCycleType:row];
}

@end