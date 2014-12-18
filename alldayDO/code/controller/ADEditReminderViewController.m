//
//  ADNewReminderViewController.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADEditReminderViewController.h"

#import <JVFloatLabeledTextField.h>
#import <JCRBlurView.h>
#import <NGAParallaxMotion.h>

#import "ADLembrete.h"
#import "ADModel.h"
#import "ADLocalNotification.h"

#import "alldayDO-Swift.h"

#define MARGIN_TOP 70.f
#define MARGIN_LEFT 20.f
#define ACTIVE_COLOR_HEX @"#3B89C6"
#define DEFAULT_COLOR_HEX @"#487BAF"
#define ERROR_COLOR_HEX @"bb3c45"

#define NUMBER_OF_ICONS 51

@interface ADEditReminderViewController () <UIGestureRecognizerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *labelHeader;

@property (nonatomic, strong) JVFloatLabeledTextField *descriptionTextField;
@property (nonatomic, strong) JVFloatLabeledTextField *periodoTextField;
@property (nonatomic, strong) JVFloatLabeledTextField *horaTextField;
@property (nonatomic, strong) JVFloatLabeledTextField *dataTextField;

@property (nonatomic, strong) UIPickerView *periodoPickerView;
@property (nonatomic, strong) UIDatePicker *horaPicker;
@property (nonatomic, strong) UIDatePicker *dataPicker;

@property (nonatomic, strong) UILabel *badgeLabel;
@property (nonatomic, strong) UIButton *cancelarButton;
@property (nonatomic, strong) UIButton *salvarButton;

@property (nonatomic, strong) UIView *badgeView;
@property (nonatomic, strong) ADBadgeImageView *badgeImageView;

@property (nonatomic, strong) UIView *badgeIconView;
@property (nonatomic, strong) UICollectionView *badgeIconCollectionView;

@property (nonatomic, strong) NSMutableArray *icons;

@property (nonatomic, strong) UITapGestureRecognizer *dismissKeyboardGesture;

@property (nonatomic, strong) UIToolbar *toolbar;


- (void)_salvarTouched;

- (void)_addBlurView;
- (void)_addGesturesRecognizer;
- (void)_addInputViewForTextField;
- (void)_addSubViews;
- (void)_editReminderMode;
- (void)_removeGestureRecognizer;
- (void)_cancelarTouched;
- (void)_dismissKeyboard;
- (void)_nextFieldText;

- (void)_refreshTimeLabel:(UIDatePicker *)datePicker;
- (void)_refreshDataInicialLabel:(UIDatePicker *)datePicker;
- (BOOL)_requiredValidation;
- (void)_displayBadgeIconView;

@end

@implementation ADEditReminderViewController

#pragma mark - UIViewController Methods -

- (id)init {
    self = [super init];
    if (self) {
        self.badgeView.parallaxIntensity = 7.f;
        [self _addBlurView];
        [self _addGesturesRecognizer];
        [self _addInputViewForTextField];
        [self _addSubViews];
    }
    return self;
}

#pragma mark - Getter Methods -

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView viewWithFrame:self.view.bounds];
        [_headerView setH:60.f];
        _headerView.backgroundColor = [UIColor sam_colorWithHex:ACTIVE_COLOR_HEX];
        
        self.labelHeader = [UILabel label];
        [self.labelHeader setW:_headerView.width andH:40.f];
        [self.labelHeader setY:(_headerView.maxY - self.labelHeader.height)];
        self.labelHeader.textColor = [UIColor whiteColor];
        self.labelHeader.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:self.labelHeader];
    }
    return _headerView;
}

- (JVFloatLabeledTextField *)descriptionTextField {
    if (!_descriptionTextField) {
        _descriptionTextField = [[JVFloatLabeledTextField alloc] init];
        _descriptionTextField.delegate = self;
        _descriptionTextField.returnKeyType = UIReturnKeyNext;
        _descriptionTextField.floatingLabelActiveTextColor = [UIColor sam_colorWithHex:ACTIVE_COLOR_HEX];
        _descriptionTextField.floatingLabelTextColor = [UIColor sam_colorWithHex:DEFAULT_COLOR_HEX];
        _descriptionTextField.frame = CGRectMake(MARGIN_LEFT, MARGIN_TOP, self.view.width - MARGIN_LEFT, 44.f);
        [_descriptionTextField setPlaceholder:NSLocalizedString(@"O que precisamos te lembrar?", nil)
                            floatingTitle:NSLocalizedString(@"Você não pode esquecer de", nil)];
        _descriptionTextField.inputAccessoryView = self.toolbar;
    }
    return _descriptionTextField;
}

- (JVFloatLabeledTextField *)periodoTextField {
    if (!_periodoTextField) {
        _periodoTextField = [[JVFloatLabeledTextField alloc] init];
        _periodoTextField.delegate = self;
        _periodoTextField.frame = CGRectMake(MARGIN_LEFT, self.descriptionTextField.maxY, self.view.width, 44.f);
        _periodoTextField.floatingLabelActiveTextColor = [UIColor sam_colorWithHex:ACTIVE_COLOR_HEX];
        _periodoTextField.floatingLabelTextColor = [UIColor sam_colorWithHex:DEFAULT_COLOR_HEX];
        [_periodoTextField setPlaceholder:NSLocalizedString(@"Quando?", nil)
                            floatingTitle:NSLocalizedString(@"Te lembraremos", nil)];
        _periodoTextField.inputAccessoryView = self.toolbar;
    }
    return _periodoTextField;
}

- (JVFloatLabeledTextField *)horaTextField {
    if (!_horaTextField) {
        _horaTextField = [[JVFloatLabeledTextField alloc] init];
        _horaTextField.delegate = self;
        _horaTextField.frame = CGRectMake(MARGIN_LEFT, self.periodoTextField.maxY, self.view.width, 44.f);
        _horaTextField.floatingLabelActiveTextColor = [UIColor sam_colorWithHex:ACTIVE_COLOR_HEX];
        _horaTextField.floatingLabelTextColor = [UIColor sam_colorWithHex:DEFAULT_COLOR_HEX];
        [_horaTextField setPlaceholder:NSLocalizedString(@"Que horas?", nil)
                            floatingTitle:NSLocalizedString(@"às", nil)];
        _horaTextField.inputAccessoryView = self.toolbar;
    }
    return _horaTextField;
}

- (JVFloatLabeledTextField *)dataTextField {
    if (!_dataTextField) {
        _dataTextField = [[JVFloatLabeledTextField alloc] init];
        _dataTextField.delegate = self;
        _dataTextField.frame = CGRectMake(MARGIN_LEFT, self.horaTextField.maxY, self.view.width, 44.f);
        _dataTextField.floatingLabelActiveTextColor = [UIColor sam_colorWithHex:ACTIVE_COLOR_HEX];
        _dataTextField.floatingLabelTextColor = [UIColor sam_colorWithHex:DEFAULT_COLOR_HEX];
        [_dataTextField setPlaceholder:NSLocalizedString(@"Começando no dia?", nil)
                         floatingTitle:NSLocalizedString(@"a partir do dia", nil)];
        _dataTextField.inputAccessoryView = self.toolbar;
    }
    return _dataTextField;
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

- (UIDatePicker *)horaPicker {
    if (!_horaPicker) {
        _horaPicker = [[UIDatePicker alloc] init];
        _horaPicker.datePickerMode = UIDatePickerModeTime;
        _horaPicker.locale = [NSLocale autoupdatingCurrentLocale];
        _horaPicker.backgroundColor = [UIColor whiteColor];
        [_horaPicker addTarget:self
                       action:@selector(_refreshTimeLabel:)
             forControlEvents:UIControlEventAllEvents];
    }
    return _horaPicker;
}

- (UIDatePicker *)dataPicker {
    if (!_dataPicker) {
        _dataPicker = [[UIDatePicker alloc] init];
        _dataPicker.datePickerMode = UIDatePickerModeDate;
        _dataPicker.backgroundColor = [UIColor whiteColor];
        [_dataPicker addTarget:self
                        action:@selector(_refreshDataInicialLabel:)
              forControlEvents:UIControlEventAllEvents];
    }
    return _dataPicker;
}

- (UIView *)badgeView {
    if (!_badgeView) {
        _badgeView = [UIView viewWithFrame:CGRectMake(0.f, 0.f, 80.f, 90.f)];
        _badgeView.center = self.view.center;
        
        CGFloat yBetweenDataTextAndSalvarButton = self.dataTextField.maxY + (((self.salvarButton.y - self.dataTextField.maxY) / 2) - _badgeView.height / 2);
        [_badgeView setY:yBetweenDataTextAndSalvarButton];
        UITapGestureRecognizer *iconGestureRecognizer = [UITapGestureRecognizer gestureRecognizerWithTarget:self
                                                                                                     action:@selector(_displayBadgeIconView)];
        [_badgeView addGestureRecognizer:iconGestureRecognizer];
        
        self.badgeImageView = [[ADBadgeImageView alloc] initWithFrame:_badgeView.bounds];
        [_badgeView addSubview:self.badgeImageView];
    }
    return _badgeView;
}

- (UILabel *)badgeLabel {
    if (!_badgeLabel) {
        _badgeLabel = [UILabel label];
        [_badgeLabel setW:self.view.width andH:44.f];
        [_badgeLabel setY:(self.badgeView.y - _badgeLabel.height)];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.textColor = [UIColor sam_colorWithHex:@"#B6BEC9"];
        _badgeLabel.font = [UIFont systemFontOfSize:16.f];
        _badgeLabel.text = NSLocalizedString(@"selecione_miniatura", nil);
    }
    return _badgeLabel;
}

- (UIButton *)cancelarButton {
    if (!_cancelarButton) {
        _cancelarButton = [[UIButton alloc] initWithFrame:CGRectMake(self.salvarButton.maxX,
                                                                    self.view.maxY - 50.f,
                                                                    self.view.width / 2,
                                                                    50.f)];
        [_cancelarButton setTitle:NSLocalizedString(@"Cancelar", nil) forState:UIControlStateNormal];
        [_cancelarButton addTarget:self action:@selector(_cancelarTouched) forControlEvents:UIControlEventTouchUpInside];
        _cancelarButton.backgroundColor = [UIColor sam_colorWithHex:ERROR_COLOR_HEX];
    }
    return _cancelarButton;
}

- (UIButton *)salvarButton {
    if (!_salvarButton) {
        _salvarButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                  self.view.maxY - 50.f,
                                                                  self.view.width / 2,
                                                                  50.f)];
        [_salvarButton setTitle:NSLocalizedString(@"Salvar", nil) forState:UIControlStateNormal];
        [_salvarButton addTarget:self action:@selector(_salvarTouched) forControlEvents:UIControlEventTouchUpInside];
        _salvarButton.backgroundColor = [UIColor sam_colorWithHex:ACTIVE_COLOR_HEX];
    }
    return _salvarButton;
}

- (UIView *)badgeIconView {
    if (!_badgeIconView) {
        _badgeIconView = [UIView viewWithFrame:self.view.bounds];
        _badgeIconView.alpha = 0.f;
    }
    return _badgeIconView;
}

- (UICollectionView *)badgeIconCollectionView {
    if (!_badgeIconCollectionView) {
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        collectionViewLayout.itemSize = CGSizeMake(40.f, 40.f);
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(20.f, 20.f, 20.f, 20.f);
        _badgeIconCollectionView = [[UICollectionView alloc] initWithFrame:self.badgeIconView.frame
                                                      collectionViewLayout:collectionViewLayout];
        _badgeIconCollectionView.dataSource = self;
        _badgeIconCollectionView.delegate = self;
        _badgeIconCollectionView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.800];
    }
    return _badgeIconCollectionView;
}

- (NSMutableArray *)icons {
    if (!_icons) {
        _icons = [NSMutableArray array];
        
        for (int i = 1; i <= NUMBER_OF_ICONS; i++) {
            [_icons addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%i.png", i]]];
        }
    }
    return _icons;
}

- (UIGestureRecognizer *)dismissKeyboardGesture {
    if (!_dismissKeyboardGesture) {
        _dismissKeyboardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismissKeyboard)];
        _dismissKeyboardGesture.delegate = self;
    }
    return _dismissKeyboardGesture;
}

- (ADEditReminderViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ADEditReminderViewModel alloc] init];
    }
    return _viewModel;
}

- (UIToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.f)];
        _toolbar.translucent = YES;
        _toolbar.tintColor = [UIColor sam_colorWithHex:DEFAULT_COLOR_HEX];
        
        UIBarButtonItem *spaceButtonItem = [UIBarButtonItem barButtonItemWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                          target:self
                                                                                          action:NULL];
        UIBarButtonItem *nextButtonItem = [UIBarButtonItem barButtonItemWithTitle:NSLocalizedString(@"Próximo", nil)
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(_nextFieldText)];
        _toolbar.items = @[spaceButtonItem, nextButtonItem];
    }
    return _toolbar;
}

#pragma mark - UIViewController Methods -

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GAI sharedInstance] sendScreen:@"EditReminderScreen"
                        withCategory:@"EditReminderScreen"];
    
    NSString *labelHeaderText = NSLocalizedString(@"new_reminder", nil);
    if (self.actionMode == ADEditMode) {
        labelHeaderText = NSLocalizedString(@"edit_reminder", nil);
        [self _editReminderMode];
    }
    self.labelHeader.text = labelHeaderText;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self _dismissKeyboard];
}

#pragma mark - Private Methods -

- (void)_salvarTouched {
    [[GAI sharedInstance] sendAction:@"saveActivity" withCategory:@"Action"];
    if ([self _requiredValidation]) {

        self.viewModel.periodo = [NSNumber numberWithInteger:[self.viewModel typeForCycleString:self.periodoTextField.text]];
        self.viewModel.descricao = self.descriptionTextField.text;
        self.viewModel.data = self.horaPicker.date;
        self.viewModel.dataInicial = self.dataPicker.date;
        self.viewModel.imagem = UIImagePNGRepresentation(self.badgeImageView.badgeIconImageView.image);
        [self.viewModel saveChanges];
        if ([self.delegate respondsToSelector:@selector(newReminderViewController:didSaveReminder:)]) {
            [self.delegate newReminderViewController:self
                                     didSaveReminder:(ADLembrete *)self.viewModel];
        }
    }
}

- (void)_addBlurView {
    JCRBlurView *blurView = [JCRBlurView new];
    blurView.frame = self.view.frame;
    [blurView addSubview:self.headerView];
    [self.view addSubview:blurView];
}

- (void)_addGesturesRecognizer {
    [self.view addGestureRecognizer:self.dismissKeyboardGesture];
}

- (void)_addInputViewForTextField {
    self.periodoTextField.inputView = self.periodoPickerView;
    self.horaTextField.inputView = self.horaPicker;
    self.dataTextField.inputView = self.dataPicker;
}

- (void)_addSubViews {
    [self.view addSubview:self.descriptionTextField];
    [self.view addSubview:self.periodoTextField];
    [self.view addSubview:self.horaTextField];
    [self.view addSubview:self.dataTextField];
    [self.view addSubview:self.badgeView];
    [self.view addSubview:self.salvarButton];
    [self.view addSubview:self.cancelarButton];
    [self.view addSubview:self.badgeLabel];
    [self.view addSubview:self.badgeIconView];
    [self.badgeIconView addSubview:self.badgeIconCollectionView];
}

- (void)_editReminderMode {
    self.descriptionTextField.text = self.viewModel.descricaoEdit;
    self.periodoTextField.text = [self.viewModel textForCycleType:self.viewModel.periodoEdit.integerValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    self.dataTextField.text = [formatter stringFromDate:self.viewModel.dataInicialEdit];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh"];
    NSString *horaFormated = [NSString stringWithFormat:@"%@", [outputFormatter stringFromDate:self.viewModel.dataEdit]];
    
    [outputFormatter setDateFormat:@"mm"];
    NSString *minutosFormated = [NSString stringWithFormat:@"%@", [outputFormatter stringFromDate:self.viewModel.dataEdit]];
    
    [outputFormatter setDateFormat:@"a"];
    NSString *periodoFormated = [NSString stringWithFormat:@"%@", [outputFormatter stringFromDate:self.viewModel.dataEdit]];
    
    self.horaTextField.text = [NSString stringWithFormat:@"%@:%@ %@", horaFormated, minutosFormated, periodoFormated];
    
    self.badgeImageView.image = [[UIImage imageNamed:@"HexaconEdit"] tintedImageWithColor:[UIColor sam_colorWithHex:DEFAULT_COLOR_HEX]];
    self.badgeImageView.badgeIconImageView.image = [[UIImage imageWithData:self.viewModel.imagemEdit] tintedImageWithColor:[UIColor whiteColor]];
}

- (void)_removeGestureRecognizer {
    [self.view removeGestureRecognizer:self.dismissKeyboardGesture];
}

- (void)_cancelarTouched {
    [[GAI sharedInstance] sendAction:@"CancelActivity" withCategory:@"Action"];
    
    [[UIAlertView alertViewWithTitle:@""
                             message:NSLocalizedString(@"Você realmente deseja cancelar?", nil)
                            delegate:self
                   cancelButtonTitle:NSLocalizedString(@"Não", nil)
                   otherButtonTitles:NSLocalizedString(@"Sim", nil), nil] show];
}

- (void)_dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)_nextFieldText {
    [[GAI sharedInstance] sendAction:@"clickNextField" withCategory:@"Action"];
    if (self.descriptionTextField.isFirstResponder) {
        [self.periodoTextField becomeFirstResponder];
        
    } else if (self.periodoTextField.isFirstResponder) {
        [self.horaTextField becomeFirstResponder];
        
    } else if (self.horaTextField.isFirstResponder) {
        [self.dataTextField becomeFirstResponder];
        
    } else if (self.dataTextField.isFirstResponder) {
        if (self.actionMode == ADAddMode) {
            [self _displayBadgeIconView];
        } else {
            [self _dismissKeyboard];
        }
    }
}

- (void)_refreshTimeLabel:(UIDatePicker *)datePicker {
    NSDate *date = [NSDate date];
    if (datePicker) {
        date = datePicker.date;
    }
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setDateFormat:@"hh"];
    NSString *horaFormated = [NSString stringWithFormat:@"%@", [outputFormatter stringFromDate:date]];
    
    [outputFormatter setDateFormat:@"mm"];
    NSString *minutosFormated = [NSString stringWithFormat:@"%@", [outputFormatter stringFromDate:date]];

    [outputFormatter setDateFormat:@"a"];
    NSString *periodoFormated = [NSString stringWithFormat:@"%@", [outputFormatter stringFromDate:date]];
    
    self.horaTextField.text = [NSString stringWithFormat:@"%@:%@ %@", horaFormated, minutosFormated, periodoFormated];
}

- (void)_refreshDataInicialLabel:(UIDatePicker *)datePicker {
    NSDate *date = [NSDate date];
    if (datePicker) {
        date = datePicker.date;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale autoupdatingCurrentLocale];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    self.dataTextField.text = [formatter stringFromDate:date];
}

- (BOOL)_requiredValidation {
    BOOL sucess = YES;
    NSString *messageError;
    
    UIColor *requiredColor = [UIColor sam_colorWithHex:ERROR_COLOR_HEX];
    
    UIImage *iconImage = self.badgeImageView.badgeIconImageView.image;
    if ([self.descriptionTextField.text isEqualToString:@""]) {
        [self.descriptionTextField setValue:requiredColor
                                 forKeyPath:@"_placeholderLabel.textColor"];
        messageError = NSLocalizedString(@"", nil);
        sucess = NO;
        
    } else if ([self.periodoTextField.text isEqualToString:@""]){
        [self.periodoTextField setValue:requiredColor
                             forKeyPath:@"_placeholderLabel.textColor"];
        messageError = NSLocalizedString(@"", nil);
        sucess = NO;
        
    } else if ([self.horaTextField.text isEqualToString:@""]) {
        [self.horaTextField setValue:requiredColor
                          forKeyPath:@"_placeholderLabel.textColor"];
        messageError = NSLocalizedString(@"", nil);
        sucess = NO;
        
    } else if ([self.dataTextField.text isEqualToString:@""]) {
        [self.dataTextField setValue:requiredColor
                          forKeyPath:@"_placeholderLabel.textColor"];
        messageError = NSLocalizedString(@"", nil);
        sucess = NO;
        
    } else if (!iconImage) {
        [[GAI sharedInstance] sendAction:@"NolCon" withCategory:@"Action"];
        self.badgeImageView.image = [self.badgeImageView.image tintedImageWithColor:requiredColor];
        messageError = NSLocalizedString(@"", nil);
        sucess = NO;
    }
    if ([[NSDate dateFormattedWithDate:self.dataPicker.date
               andHourFromAnotherDate:self.horaPicker.date] compare:[NSDate date]] == NSOrderedAscending) {
        messageError = NSLocalizedString(@"", nil);
        sucess = NO;
    }
    if (messageError.isPresent) {
        #warning apresentar mensagem de error por notification - cocoapod
    }
    return sucess;
}

- (void)_displayBadgeIconView {
    [self _dismissKeyboard];
    [UIView animateWithDuration:0.4f animations:^{
        self.badgeIconView.alpha = 1.f;
        [self.badgeIconCollectionView reloadData];
    }];
    [self _removeGestureRecognizer];
}

#pragma mark - UITextFieldDelegate Methods -

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.descriptionTextField) {
        [[GAI sharedInstance] sendAction:@"descricaoTextField" withCategory:@"FocusOnTextField"];
    } else if (textField == self.periodoTextField) {
        [[GAI sharedInstance] sendAction:@"periodoTextField" withCategory:@"FocusOnTextField"];
        if (self.actionMode == ADAddMode) {
            self.periodoTextField.text = [self.viewModel textForCycleType:0];
            [self.periodoPickerView selectRow:0 inComponent:0 animated:YES];
        }
    } else if (textField == self.horaTextField) {
        [[GAI sharedInstance] sendAction:@"horaTextField" withCategory:@"FocusOnTextField"];
        if (self.actionMode == ADAddMode) {
            [self _refreshTimeLabel:nil];
            self.horaPicker.date = [NSDate date];
        }
    } else if (textField == self.dataTextField) {
        [[GAI sharedInstance] sendAction:@"dataTextField" withCategory:@"FocusOnTextField"];
        if (self.actionMode == ADAddMode) {
            [self _refreshDataInicialLabel:nil];
            self.dataPicker.date = [NSDate date];
        }
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
    return self.viewModel.cycleType.count;
}

#pragma mark - UIPickerViewDelegate Methods -

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.viewModel textForCycleType:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.periodoTextField.text = [self.viewModel textForCycleType:row];
}

#pragma mark - UICollectionViewDataSource Methods -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return NUMBER_OF_ICONS;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"badgeCell-%@", indexPath];
    
    [collectionView registerClass:[ADIconCell class] forCellWithReuseIdentifier:identifier];
    
    ADIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.iconImageView.image = [[self.icons objectAtIndex:indexPath.row] tintedImageWithColor:[UIColor blackColor]];;
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods -

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:0.4f animations:^{
        self.badgeIconView.alpha = 0.0f;
    }];

    self.badgeImageView.image = [[UIImage imageNamed:@"Hexacon"] tintedImageWithColor:[UIColor sam_colorWithHex:DEFAULT_COLOR_HEX]];
    self.badgeImageView.badgeIconImageView.image = [[self.icons objectAtIndex:indexPath.row] tintedImageWithColor:[UIColor whiteColor]];
    
    [self _addGesturesRecognizer];
}

#pragma mark - UIAlertViewDelegate Methods -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            [self dismissViewControllerAnimated:YES completion:nil];
            if ([self.delegate respondsToSelector:@selector(newReminderViewControllerDidCancelReminder:)]) {
                [self.delegate newReminderViewControllerDidCancelReminder:self];
            }
            break;
        default:
        break;
    }
}

@end