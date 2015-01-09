//
//  ADRemindersViewModel.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 14/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADLembreteConfirmado.h"

#import "alldayDOKit.h"

@interface ADRemindersViewModel : NSObject

@property (nonatomic, readonly) NSString *descricao;
@property (nonatomic, readonly) NSString *periodo;
@property (nonatomic, readonly) UIImage *imagem;
@property (nonatomic, readonly) NSNumber *seguidos;
@property (nonatomic, readonly) BOOL hasNoReminderAlert;

@property (nonatomic, readonly) NSMutableArray *allReminders;
@property (nonatomic, readonly) NSMutableArray *doneReminders;
@property (nonatomic, readonly) NSMutableArray *undoneReminders;
@property (nonatomic, readonly) NSMutableArray *todayReminders;


- (void)deleteRow:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (void)fetchObjectAtIndexPath:(NSIndexPath *)indexPath;
- (void)executeFetchRequestForAll;
- (void)executeFetchRequestForToday;
- (void)executeFetchRequestForDoneReminders;
- (void)executeFetchRequestForUndoneReminders;

- (NSString *)nextReminderFormated;
- (NSString *)nextReminderFormatedWithDate:(NSDate *)date;

- (ADLembrete *)modelAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForLembreteWithDescricao:(NSString *)descricao;

@end
