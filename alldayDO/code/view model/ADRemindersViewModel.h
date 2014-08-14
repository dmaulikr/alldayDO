//
//  ADRemindersViewModel.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 14/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADLembrete.h"

@interface ADRemindersViewModel : NSObject

@property (nonatomic, readonly) NSString *descricao;
@property (nonatomic, readonly) NSString *periodo;
@property (nonatomic, readonly) UIImage *imagem;

- (void)deleteRow:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (void)fetchObjectAtIndexPath:(NSIndexPath *)indexPath;
- (void)executeFetchRequest;

- (NSString *)nextReminderFormated;

#warning NÃO DEIXAR ESSA PROPRIEDADE PUBLICA
@property (nonatomic, strong) ADLembrete *lembrete;

@end
