//
//  ADNewReminderViewModel.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 14/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADNewReminderViewModel.h"

#import "ADModel.h"
#import "ADLembrete+ADToolkitAdditions.h"

typedef enum {
    ADCycleTypeDay,
    ADCycleTypeWeek,
    ADCycleTypeMonth,
    ADCycleTypeYear,
} ADCycleType;

@implementation ADNewReminderViewModel

#pragma mark - Getter Methods -

- (NSArray *)cycleType {
    if(!_cycleType){
        _cycleType = @[
                    @"Diáriamente",
                    @"Semanalmente",
                    @"Mensalmente",
                    @"Anualmente"
                ];
    }
    return _cycleType;
}

#pragma mark - Public Methods -

- (void)saveChanges {
    ADLembrete *lembrete = [NSEntityDescription insertNewObjectForEntityADLembrete];
    lembrete.descricao = self.descricao;
    lembrete.periodo = self.periodo;
    lembrete.data = self.data;
    lembrete.dataInicial = self.dataInicial;
    lembrete.imagem = self.imagem;
    
    [[ADModel sharedInstance] saveChanges];
    
    UILocalNotification *newNotification = [UILocalNotification defaultLocalNotificationWith:lembrete];
    [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
}

- (NSString *)textForCycleType:(NSInteger)cycleType {
    return [self.cycleType objectAtIndex:cycleType];
}

@end
