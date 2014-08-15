//
//  ADDetailReminderViewModel.h
//  alldayDO
//
//  Created by Fábio Almeida on 8/15/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADDetailReminderViewModel : NSObject

- (void)addLembreteConfirmado;
- (void)removeLembreteConfirmado;

- (void)lembreteDetail:(ADLembrete *)lembrete;

- (NSInteger)quantidadeConfirmacaoPorMes;
- (NSInteger)quantidadeConfirmacaoPorSemama;
- (NSInteger)quantidadeConfirmacaoSeguidos;

- (BOOL)isLembreteConfirmated;

@end
