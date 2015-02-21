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

- (NSArray *)calendario {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:self.dataLembretesConfirmados.firstObject
                                                          toDate:[NSDate date].nextWeek
                                                         options:0];
    
    NSMutableArray *calendario = [NSMutableArray array];
    for (int i = 1; i < components.day + 1; i++) {
        NSDate *date = [self.dataLembretesConfirmados.firstObject dateByAddingDays:i];
        if (date) {
            [calendario addObject:date];
        }
    }
    return calendario;
}

- (NSArray *)dataLembretesConfirmados {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];

    NSMutableArray *lembretesConfirmados = [NSMutableArray array];
    for (ADLembreteConfirmado *lembreteConfirmado in self.lembrete.lembretesConfirmados.allObjects) {
        if ([lembreteConfirmado.data isCurrentMonth]) {
            [lembretesConfirmados addObject:lembreteConfirmado.data];
        }
    }
    return [lembretesConfirmados sortedArrayUsingDescriptors:descriptors];
}

- (NSString *)title {
    return self.lembrete.descricao;
}

#pragma mark - Private Methods - 

- (void)_setTodayDate {
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
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
        if ([lembreteConfirmado.data isEqualToDate:self.lembreteConfirmado.data.yesterday]
                && self.lembrete.seguidos) {
            self.lembrete.seguidos = [NSNumber numberWithInt:self.lembrete.seguidos.intValue + 1];
        } else if (self.lembrete.seguidos.intValue < 1) {
            self.lembrete.seguidos = [NSNumber numberWithInt:1];
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
    if (lembreteConfirmadoToRemove.data.yesterday) {
        self.lembrete.seguidos = [NSNumber numberWithInt:self.lembrete.seguidos.intValue - 1];
    } else {
        self.lembrete.seguidos = 0;
    }
    
    [self.lembrete removeLembretesConfirmadosObject:lembreteConfirmadoToRemove];
    [[ADModel sharedInstance] saveChanges];
    
    self.lembreteConfirmado = nil;
}

- (void)setLembreteDetail:(ADLembrete *)lembrete {
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
    NSInteger seguidos = 0;
    if (self.lembrete.seguidos != nil &&
        self.lembrete.seguidos.intValue > 0) {
        seguidos = self.lembrete.seguidos.intValue;
    }
    return seguidos;
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

- (NSUInteger)chartDataItemCount {
    return self.calendario.count;
}

- (NSArray *)chartDataXLabels {
    NSMutableArray *datasCalendarioLabels = [NSMutableArray array];
    for (NSDate *dataConfirmada in self.calendario) {
        if ([dataConfirmada isCurrentMonth] || self.calendario.count == 7) {
            [datasCalendarioLabels addObject:[NSString stringWithFormat:@"%ld", (long)dataConfirmada.day]];
        }
    }
    return datasCalendarioLabels;
}

- (ADLembrete *)model {
    return self.lembrete;
}

@end