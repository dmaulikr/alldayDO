//
//  ADNewReminderViewModel.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 14/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADNewReminderViewModel.h"

#import "ADModel.h"

typedef enum {
    ADCycleTypeDay,
    ADCycleTypeWeek,
    ADCycleTypeMonth,
    ADCycleTypeYear,
} ADCycleType;

@interface ADNewReminderViewModel ()

@property (nonatomic, strong) ADLembrete *lembreteEdit;

@end

@implementation ADNewReminderViewModel

#pragma mark - Getter Methods -

- (NSArray *)cycleType {
    if(!_cycleType){
        _cycleType = @[
                    @"Diariamente",
                    @"Semanalmente",
                    @"Mensalmente",
                    @"Anualmente"
                ];
    }
    return _cycleType;
}

#pragma mark - Public Methods -

- (void)editChanges {
    self.lembreteEdit.descricao = self.descricao;
    self.lembreteEdit.periodo = self.periodo;
    self.lembreteEdit.data = self.data;
    self.lembreteEdit.dataInicial = self.dataInicial;
    self.lembreteEdit.imagem = self.imagem;
    
    [[ADModel sharedInstance] saveChanges];
    
    NSLog(@"\n Notificações EditChange Before = %@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
    
    #warning Verificar comportamento da noticação alterada
    UILocalNotification *newNotification = [UILocalNotification defaultLocalNotificationWith:self.lembreteEdit];
    [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
    
    NSLog(@"\n Notificações EditChange After = %@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
}

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

- (void)lembreteEdit:(ADLembrete *)lembrete {
    self.lembreteEdit = lembrete;
    self.descricao = lembrete.descricao;
    self.periodo = lembrete.periodo;
    self.data = lembrete.data;
    self.dataInicial = lembrete.dataInicial;
    self.imagem = lembrete.imagem;
}

@end
