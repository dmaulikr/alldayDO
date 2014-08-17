//
//  ADDetailReminderViewModel.m
//  alldayDO
//
//  Created by Fábio Almeida on 8/15/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADDetailReminderViewModel.h"
#import "ADModel.h"

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
    [self.lembrete addLembretesConfirmadosObject:self.lembreteConfirmado];
    
    for (ADLembreteConfirmado *lembreteConfirmado in self.lembrete.lembretesConfirmados) {
        if (lembreteConfirmado.data.yesterday) {
            self.lembrete.seguidos = [NSNumber numberWithInt:self.lembrete.seguidos.intValue + 1];
        }
    }
    
    
    [[ADModel sharedInstance] saveChanges];
}

- (void)removeLembreteConfirmado {
    ADLembreteConfirmado *lembreteConfirmadoToRemove = nil;
    
    for (ADLembreteConfirmado *lembreteConfirmado in self.lembrete.lembretesConfirmados) {
        if (lembreteConfirmado.data.isToday) {
            lembreteConfirmadoToRemove = lembreteConfirmado;
        }
    }
    
    self.lembrete.seguidos = [NSNumber numberWithInt:self.lembrete.seguidos.intValue - 1];
    [self.lembrete removeLembretesConfirmadosObject:lembreteConfirmadoToRemove];
    [[ADModel sharedInstance] deleteObject:lembreteConfirmadoToRemove];
    [[ADModel sharedInstance] saveChanges];
    
    self.lembreteConfirmado = nil;
}

- (void)lembreteDetail:(ADLembrete *)lembrete {
    self.lembrete = lembrete;
}

- (NSInteger)quantidadeConfirmacaoPorMes {
    NSInteger quantidadeConfirmados = 0;
    
    NSArray *lembretesConfirmados = self.lembrete.lembretesConfirmados.allObjects;
    for (ADLembreteConfirmado *lembreteConfirmado in lembretesConfirmados) {
        if ([lembreteConfirmado.data isCurrentMonth]) {
            quantidadeConfirmados++;
        }
    }
    return quantidadeConfirmados;
}

- (NSInteger)quantidadeConfirmacaoPorSemama {
    NSInteger quantidadeConfirmados = 0;
    
    NSArray *lembretesConfirmados = self.lembrete.lembretesConfirmados.allObjects;
    for (ADLembreteConfirmado *lembreteConfirmado in lembretesConfirmados) {
        if ([lembreteConfirmado.data isCurrentWeek]) {
            quantidadeConfirmados++;
        }
    }
    return quantidadeConfirmados;
}

- (NSInteger)quantidadeConfirmacaoSeguidos {
    return self.lembrete.seguidos.intValue;
}

- (BOOL)isLembreteConfirmated {
    BOOL isToday = NO;
    
    for (ADLembreteConfirmado *lembreteConfirmado in self.lembrete.lembretesConfirmados) {
        if (lembreteConfirmado.data.isToday) {
            isToday = YES;
        }
    }
    
    return isToday;
}

@end
