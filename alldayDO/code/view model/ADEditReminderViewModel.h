//
//  ADEditReminderViewModel.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 14/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "alldayDOKit.h"

@interface ADEditReminderViewModel : NSObject

@property (nonatomic, strong) NSString *descricao;
@property (nonatomic, strong) NSDate *data;
@property (nonatomic, strong) NSDate *dataInicial;
@property (nonatomic, strong) NSNumber *periodo;
@property (nonatomic, strong) ADCategoria *categoria;
@property (nonatomic, strong) NSData *imagem;

@property (nonatomic, readonly) NSString *descricaoEdit;
@property (nonatomic, readonly) NSDate *dataEdit;
@property (nonatomic, readonly) NSDate *dataInicialEdit;
@property (nonatomic, readonly) NSNumber *periodoEdit;
@property (nonatomic, readonly) ADCategoria *categoriaEdit;
@property (nonatomic, readonly) NSData *imagemEdit;

@property (nonatomic, readonly) NSArray *lembretes;
@property (nonatomic, readonly) NSArray *cycleType;
@property (nonatomic, readonly) NSArray *categorias;

- (void)saveChanges;

- (NSString *)textForCycleType:(NSInteger)cycleType;

- (void)LembreteEdit:(ADLembrete *)lembrete;

- (NSInteger)typeForCycleString:(NSString *)CycleType;

@end
