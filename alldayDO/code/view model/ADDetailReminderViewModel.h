//
//  ADDetailReminderViewModel.h
//  alldayDO
//
//  Created by Fábio Almeida on 8/15/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ADLembreteConfirmado.h"
#import "PNLineChartDataItem.h"

@interface ADDetailReminderViewModel : NSObject

@property (nonatomic, readonly) NSArray *calendario;
@property (nonatomic, readonly) NSArray *dataLembretesConfirmados;
@property (nonatomic, readonly) NSString *title;

- (void)addLembreteConfirmado;
- (void)removeLembreteConfirmado;

- (void)setLembreteDetail:(ADLembrete *)lembrete;

- (NSInteger)quantidadeConfirmacaoPorMes;
- (NSInteger)quantidadeConfirmacaoPorSemama;
- (NSInteger)quantidadeConfirmacaoSeguidos;

- (BOOL)isLembreteConfirmated;

- (NSUInteger)chartDataItemCount;
- (NSArray *)chartDataXLabels;

- (ADLembrete *)model;

@end
