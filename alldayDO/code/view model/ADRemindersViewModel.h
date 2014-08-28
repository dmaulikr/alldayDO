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
@property (nonatomic, readonly) NSNumber *seguidos;

- (void)deleteRow:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (void)fetchObjectAtIndexPath:(NSIndexPath *)indexPath;
- (void)executeFetchRequest;

- (NSString *)nextReminderFormated;

- (ADLembrete *)lembreteAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForLembreteWithDescricao:(NSString *)descricao;

@end
