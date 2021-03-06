//
//  ADRemindersViewModel.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 14/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADRemindersViewModel.h"
#import "ADLocalNotification.h"

@interface ADRemindersViewModel ()

@property (nonatomic, strong) ADLembrete *lembrete;
@property (nonatomic, strong) NSArray *lembretes;
@property (nonatomic, strong) NSMutableArray *lembretesTodos;
@property (nonatomic, strong) NSMutableArray *lembretesCompletados;
@property (nonatomic, strong) NSMutableArray *lembretesNaoCompletados;
@property (nonatomic, strong) NSMutableArray *lembretesParaHoje;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsControllerCategoria;

- (void)_fetchResultsForLembretesInDiferentsCategories;
- (NSArray *)_sortReminders:(NSArray *)reminders;
- (BOOL)_isJustOneTimeOrNeverTypeForLembrete:(ADLembrete *)lembrete;
- (void)_nullableLembretes;

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

- (NSMutableArray *)lembretesParaHoje {
    if (!_lembretesParaHoje) {
        _lembretesParaHoje = [NSMutableArray array];
    }
    return _lembretesParaHoje;
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

- (NSFetchedResultsController *)fetchedResultsControllerCategoria {
    if (!_fetchedResultsControllerCategoria) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ADCategoria"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"descricao" ascending:YES]];
        
        _fetchedResultsControllerCategoria = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[ADModel sharedInstance].managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:@"descricao_reminders_cache"];
    }
    return _fetchedResultsControllerCategoria;
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
    BOOL hasReminderAlert = NO;
    if ([self.lembrete.periodo isEqualToNumber:[NSNumber numberWithInt:ADCycleTypeNever]]) {
        hasReminderAlert = YES;
    }
    if ([self.lembrete.periodo isEqualToNumber:[NSNumber numberWithInt:ADCycleTypeJustOneTime]]
        && [[self.lembrete dateFormattedForJustOneTime] compare:[NSDate date]] == NSOrderedAscending) {
        hasReminderAlert = YES;
    }
    return hasReminderAlert;
}

- (NSArray *)categorias {
    [self.fetchedResultsControllerCategoria performFetch:nil];
    return [self.fetchedResultsControllerCategoria fetchedObjects];
}

- (NSArray *)searchBarScopesTitles {
    NSMutableArray *titles = [NSMutableArray array];
    [titles addObject:NSLocalizedString(@"all", nil)];
    for (ADCategoria *categoria in self.categorias) {
        if ([categoria.descricao isEqualToString:@"Home"]) {
            [titles addObject:NSLocalizedString(@"home", nil)];
        } else if ([categoria.descricao isEqualToString:@"Personal"]) {
            [titles addObject:NSLocalizedString(@"personal", nil)];
        } else if ([categoria.descricao isEqualToString:@"Work"]) {
            [titles addObject:NSLocalizedString(@"work", nil)];
        } else {
            [titles addObject:categoria.descricao];
        }
    }
    return titles;
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

- (NSArray *)todayReminders {
    return self.lembretesParaHoje;
}

#pragma mark - Private Methods -

- (void)_fetchResultsForLembretesInDiferentsCategories {
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
        if ([lembrete.nextFireDate isToday]) {
            [self.lembretesParaHoje addObject:lembrete];
        }
    }
}

- (NSArray *)_sortReminders:(NSArray *)reminders {
    NSArray *sortedReminders = [reminders sortedArrayUsingComparator: ^(id obj1, id obj2) {
            ADLembrete *lembrete1 = (ADLembrete *)obj1;
            ADLembrete *lembrete2 = (ADLembrete *)obj2;
        return [lembrete1.nextFireDate compare:lembrete2.nextFireDate];
    }];
    NSArray *sortedWithTypes = [sortedReminders sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ADLembrete *lembrete1 = (ADLembrete *)obj1;
        ADLembrete *lembrete2 = (ADLembrete *)obj2;
        if ([self _isJustOneTimeOrNeverTypeForLembrete:lembrete1] ||
            [self _isJustOneTimeOrNeverTypeForLembrete:lembrete2]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    return sortedWithTypes;
}

- (BOOL)_isJustOneTimeOrNeverTypeForLembrete:(ADLembrete *)lembrete {
    BOOL isType = NO;
    if ([lembrete.periodo isEqualToNumber:[NSNumber numberWithInt:ADCycleTypeJustOneTime]] &&
        [[lembrete dateFormattedForJustOneTime] compare:[NSDate date]] == NSOrderedAscending) {
        isType = YES;
    } else if ([lembrete.periodo isEqualToNumber:[NSNumber numberWithInt:ADCycleTypeNever]]) {
        isType = YES;
    }
    return isType;
}

- (void)_nullableLembretes {
    self.lembretes = nil;
    self.lembretesTodos = nil;
    self.lembretesCompletados = nil;
    self.lembretesNaoCompletados = nil;
    self.lembretesParaHoje = nil;
}

#pragma mark - Public Methods -

- (void)deleteRow:(NSIndexPath *)indexPath {
    ADLembrete *lembrete = [self.lembretes objectAtIndex:indexPath.row];
    [self.lembretesTodos removeObject:lembrete];
    [self.lembretesCompletados removeObject:lembrete];
    [self.lembretesNaoCompletados removeObject:lembrete];
    [self.lembretesParaHoje removeObject:lembrete];
    
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
    [self _nullableLembretes];
    
    [self.fetchedResultsController performFetch:nil];
    [self.lembretesTodos addObjectsFromArray:[self _sortReminders:[self.fetchedResultsController fetchedObjects]]];
     self.lembretes = self.lembretesTodos;
    
    [self _fetchResultsForLembretesInDiferentsCategories];
}

- (void)executeFetchRequestForAllWithCategoria:(ADCategoria *)categoria {
    [self _nullableLembretes];
    
    [self.fetchedResultsController performFetch:nil];
    for (ADLembrete *lembrete in [self _sortReminders:[self.fetchedResultsController fetchedObjects]]) {
        if ([lembrete.categoria isEqual:categoria]) {
            [self.lembretesTodos addObject:lembrete];
        }
    }
    self.lembretes = self.lembretesTodos;
    
    [self _fetchResultsForLembretesInDiferentsCategories];
}

- (void)executeFetchRequestForDoneReminders {
    self.lembretes = self.lembretesCompletados;
}

- (void)executeFetchRequestForUndoneReminders {
    self.lembretes = self.lembretesNaoCompletados;
}

- (void)searchBarWithText:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        self.lembretes = self.lembretesTodos;
    } else {
        NSMutableArray *lembretes = [NSMutableArray array];
        for (ADLembrete *lembrete in self.lembretesTodos) {
            if ([lembrete.descricao hasPrefix:searchText]) {
                [lembretes addObject:lembrete];
            } else {
                [lembretes removeObject:lembrete];
            }
        }
         self.lembretes = lembretes;
    }
}

- (NSString *)nextReminderFormated {
    return [self nextReminderFormatedWithDate:nil];
}

- (NSString *)nextReminderFormatedWithDate:(NSDate *)date {
    if (!date) {
        date = self.lembrete.nextFireDate;
    }
    
    NSString *dateAsString;
    if (date) {
        dateAsString = [[NSDate date] dateAsStringFromDate:date extended:YES];
    }
    
    NSString *message = NSLocalizedString(@"Lembrete em", nil);
    return [NSString stringWithFormat:@"%@ %@", message, dateAsString];
}

- (ADLembrete *)modelAtIndexPath:(NSIndexPath *)indexPath {
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