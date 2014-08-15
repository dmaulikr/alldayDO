//
//  ADDetailReminderViewController.m
//  alldayDO
//
//  Created by Fábio Almeida on 8/13/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADDetailReminderViewController.h"

#import "ADModel.h"

@interface ADDetailReminderViewController ()

@end

@implementation ADDetailReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_second_color_bg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - IBAction Methods -

- (IBAction)cancelButtonTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)editButtonTouched:(id)sender {
}

- (IBAction)doneButtonTouched:(id)sender {
    
#warning CRIAR VIEW MODEL PARA ESSA CLASSE
    
    ADLembreteConfirmado *lembreteConfirmado = [NSEntityDescription insertNewObjectForEntityADLembreteConfirmado];
    lembreteConfirmado.data = [NSDate date];
    
    if (self.doneButton.selected) {
        [self.lembrete removeLembreteConfirmadoObject:lembreteConfirmado];
    } else {
        [self.lembrete addLembreteConfirmadoObject:lembreteConfirmado];
    }
    
    [[ADModel sharedInstance] saveChanges];
    
    self.doneButton.selected = !self.doneButton.selected;
}

@end
