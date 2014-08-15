//
//  ADDetailReminderViewModel.m
//  alldayDO
//
//  Created by Fábio Almeida on 8/15/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADDetailReminderViewModel.h"
#import "ADModel.h"

#import "ADLembrete.h"
#import "ADLembreteConfirmado.h"

@interface ADDetailReminderViewModel ()

@property (nonatomic, strong) ADLembrete *lembrete;
@property (nonatomic, strong) ADLembreteConfirmado *lembreteConfirmado;

- (void)_setTodayDate;

@end

@implementation ADDetailReminderViewModel

#pragma mark - Getter Methods - 

- (ADLembreteConfirmado *)lembreteConfirmado {
    if (!_lembreteConfirmado) {
        _lembreteConfirmado = [NSEntityDescription insertNewObjectForEntityADLembreteConfirmado];
    }
    return _lembreteConfirmado;
}

#pragma mark - Private Methods - 

- (void)_setTodayDate {
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                    fromDate:[NSDate date]];
    NSDate *today = [[NSCalendar currentCalendar]
                         dateFromComponents:components];
    self.lembreteConfirmado.data = today;
}

#pragma mark - Public Methods -

- (void)addLembreteConfirmado {
    [self _setTodayDate];
    [self.lembrete addLembreteConfirmadoObject:self.lembreteConfirmado];
    [[ADModel sharedInstance] saveChanges];
}

- (void)removeLembreteConfirmado {
    ADLembreteConfirmado *lembreteConfirmadoToRemove = nil;
    
    for (ADLembreteConfirmado *lembreteConfirmado in self.lembrete.lembreteConfirmado) {
        if (lembreteConfirmado.data.isToday) {
            lembreteConfirmadoToRemove = lembreteConfirmado;
        }
    }
    
    [self.lembrete removeLembreteConfirmadoObject:lembreteConfirmadoToRemove];
    [[ADModel sharedInstance] deleteObject:lembreteConfirmadoToRemove];
    [[ADModel sharedInstance] saveChanges];
}

- (void)lembreteDetail:(ADLembrete *)lembrete {
    self.lembrete = lembrete;
}

- (NSInteger)quantidadeConfirmacaoPorMes {
    return 22;
}

- (NSInteger)quantidadeConfirmacaoPorSemama {
    return 11;
}

- (NSInteger)quantidadeConfirmacaoSeguidos {
    return 00;
}

- (BOOL)isLembreteConfirmated {
    BOOL isToday = NO;
    
    for (ADLembreteConfirmado *lembreteConfirmado in self.lembrete.lembreteConfirmado) {
        if (lembreteConfirmado.data.isToday) {
            isToday = YES;
        }
    }
    
    return isToday;
}

@end
