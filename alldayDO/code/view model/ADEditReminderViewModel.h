//
//  ADEditReminderViewModel.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 14/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADEditReminderViewModel : NSObject

@property (nonatomic, strong) NSString * descricao;
@property (nonatomic, strong) NSDate * data;
@property (nonatomic, strong) NSDate * dataInicial;
@property (nonatomic, strong) NSNumber * periodo;
@property (nonatomic, strong) NSData * imagem;

@property (nonatomic, readonly) NSString * descricaoEdit;
@property (nonatomic, readonly) NSDate * dataEdit;
@property (nonatomic, readonly) NSDate * dataInicialEdit;
@property (nonatomic, readonly) NSNumber * periodoEdit;
@property (nonatomic, readonly) NSData * imagemEdit;

@property (nonatomic, strong) NSArray *cycleType;

- (void)saveChanges;

- (NSString *)textForCycleType:(NSInteger)cycleType;

- (void)lembreteEdit:(ADLembrete *)lembrete;

@end
