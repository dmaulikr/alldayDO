//
//  ADRemindersViewModel.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 14/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADRemindersViewModel.h"
#import "ADModel.h"
#import "ADLocalNotification.h"

@interface ADRemindersViewModel ()

@property (nonatomic, strong) ADLembrete *lembrete;
@property (nonatomic, strong) NSArray *lembretes;
@property (nonatomic, strong) NSMutableArray *lembretesTodos;
@property (nonatomic, strong) NSMutableArray *lembretesCompletados;
@property (nonatomic, strong) NSMutableArray *lembretesNaoCompletados;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)_fetchResultsForLembretesConfirmadosAndNaoConfirmados;
- (NSArray *)_sortReminders:(NSArray *)reminders;

@end

@implementation ADRemindersViewModel

#pragma mark - Getter Methods -

- (NSMutableArray *)lembretesTodos {
    if (!_lembretesTodos) {
        _lembretesTodos = [NSMutableArray array];
    }
    return _lembretesTodos;
}

- (NSMutableArray *)lembretesCompletados {
    if (!_lembretesCompletados) {
        _lembretesCompletados = [NSMutableArray array];
    }
    return _lembretesCompletados;
}

- (NSMutableArray *)lembretesNaoCompletados {
    if (!_lembretesNaoCompletados) {
        _lembretesNaoCompletados = [NSMutableArray array];
    }
    return _lembretesNaoCompletados;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ADLembrete"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"data" ascending:YES]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[ADModel sharedInstance].managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:@"reminders_cache"];
    }
    
    return _fetchedResultsController;
}

- (NSString *)descricao {
    return self.lembrete.descricao;
}

- (UIImage *)imagem {
    return [UIImage imageWithData:self.lembrete.imagem];
}

- (NSNumber *)seguidos {
    return self.lembrete.seguidos;
}

- (BOOL)hasNoReminderAlert {
    BOOL hasReminderAlert = YES;
    if ([self.lembrete.periodo isEqualToNumber:[NSNumber numberWithInt:3]]) {
        hasReminderAlert = NO;
    }
    return hasReminderAlert;
}

- (NSArray *)allReminders {
    return self.lembretesTodos;
}

- (NSArray *)doneReminders {
    return self.lembretesCompletados;
}

- (NSArray *)undoneReminders {
    return self.lembretesNaoCompletados;
}

#pragma mark - Private Methods -

- (void)_fetchResultsForLembretesConfirmadosAndNaoConfirmados {
    for (ADLembrete *lembrete in self.lembretes) {
        BOOL DoneReminder = NO;
        
        for (ADLembreteConfirmado *lembreteConfirmado in lembrete.lembretesConfirmados) {
            
            if ([lembreteConfirmado.data isToday]) {
                [self.lembretesCompletados addObject:lembrete];
                DoneReminder = YES;
            }
        }
        
        if (!DoneReminder) {
            
            [self.lembretesNaoCompletados addObject:lembrete];
        }
    }
}

- (NSArray *)_sortReminders:(NSArray *)reminders {
    return [reminders sortedArrayUsingComparator: ^(id obj1, id obj2) {
                ADLembrete *lembrete1 = (ADLembrete *)obj1;
                ADLembrete *lembrete2 = (ADLembrete *)obj2;
                return [lembrete1.nextFireDate compare:lembrete2.nextFireDate];
            }];
}

#pragma mark - Public Methods -

- (void)deleteRow:(NSIndexPath *)indexPath {
    ADLembrete *lembrete = [self.lembretes objectAtIndex:indexPath.row];
    [self.lembretesTodos removeObject:lembrete];
    [self.lembretesCompletados removeObject:lembrete];
    [self.lembretesNaoCompletados removeObject:lembrete];
    
    [[ADModel sharedInstance] deleteObject:lembrete];
    [[ADLocalNotification sharedInstance] scheduleAllLocalNotification];
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return self.lembretes.count;
}

- (void)fetchObjectAtIndexPath:(NSIndexPath *)indexPath {
    self.lembrete = [self.lembretes objectAtIndex:indexPath.row];
}

- (void)executeFetchRequestForAll {
    self.lembretes = nil;
    self.lembretesTodos = nil;
    self.lembretesCompletados = nil;
    self.lembretesNaoCompletados = nil;
    
    [self.fetchedResultsController performFetch:nil];
    [self.lembretesTodos addObjectsFromArray:[self _sortReminders:[self.fetchedResultsController fetchedObjects]]];
     self.lembretes = self.lembretesTodos;
    
    [self _fetchResultsForLembretesConfirmadosAndNaoConfirmados];
}

- (void)executeFetchRequestForDoneReminders {
    self.lembretes = self.lembretesCompletados;
}

- (void)executeFetchRequestForUndoneReminders {
    self.lembretes = self.lembretesNaoCompletados;
}

- (NSString *)nextReminderFormated {
    NSString *message = NSLocalizedString(@"Lembrete em", nil);
    NSString *dateAsString = [[NSDate date] dateAsStringFromDate:self.lembrete.nextFireDate extended:YES];
    return [NSString stringWithFormat:@"%@ %@", message, dateAsString];
}

- (ADLembrete *)lembreteAtIndexPath:(NSIndexPath *)indexPath {
    [self fetchObjectAtIndexPath:indexPath];
    return self.lembrete;
}

- (ADLembrete *)lembreteWithDescricao:(NSString *)descricao {
    ADLembrete *lembreteWithDescricao = nil;
    
    for (ADLembrete *lembrete in self.lembretes) {
        
        if ([lembrete.descricao isEqualToString:descricao]) {
            lembreteWithDescricao = lembrete;
            break;
        }
    }
    return lembreteWithDescricao;
}

- (NSIndexPath *)indexPathForLembreteWithDescricao:(NSString *)descricao {
    NSIndexPath *indexPath = nil;
    
    for (ADLembrete *lembrete in self.lembretes) {
        
        if ([lembrete.descricao isEqualToString:descricao]) {
            indexPath = [NSIndexPath indexPathForRow:[self.lembretes indexOfObject:lembrete] inSection:0];
            break;
        }
    }
    return indexPath;
}

@end