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

@implementation ADNewReminderViewModel

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

@end
