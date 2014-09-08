//
//  ADRemindersViewModel.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 14/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADLembrete.h"
#import "ADLembreteConfirmado.h"

@interface ADRemindersViewModel : NSObject

@property (nonatomic, readonly) NSString *descricao;
@property (nonatomic, readonly) NSString *periodo;
@property (nonatomic, readonly) UIImage *imagem;
@property (nonatomic, readonly) NSNumber *seguidos;
@property (nonatomic, readonly) BOOL *hasNoReminderAlert;

@property (nonatomic, readonly) NSMutableArray *allReminders;
@property (nonatomic, readonly) NSMutableArray *doneReminders;
@property (nonatomic, readonly) NSMutableArray *undoneReminders;


- (void)deleteRow:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (void)fetchObjectAtIndexPath:(NSIndexPath *)indexPath;
- (void)executeFetchRequestForAll;
- (void)executeFetchRequestForDoneReminders;
- (void)executeFetchRequestForUndoneReminders;

- (NSString *)nextReminderFormated;

- (ADLembrete *)lembreteAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForLembreteWithDescricao:(NSString *)descricao;

@end
