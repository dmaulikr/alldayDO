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
@property (nonatomic, strong) NSArray *lembretesSorted;
@property (nonatomic, strong) NSMutableArray *lembretesCompletados;
@property (nonatomic, strong) NSMutableArray *lembretesNaoCompletados;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)_fetchResultsForLembretesConfirmadosAndNaoConfirmados;
- (NSArray *)_sortReminders:(NSArray *)reminders;

@end

@implementation ADRemindersViewModel

#pragma mark - Getter Methods -

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

- (NSArray *)doneReminders {
    return self.lembretesCompletados;
}

- (NSArray *)undoneReminders {
    return self.lembretesNaoCompletados;
}

#pragma mark - Private Methods -

- (void)_fetchResultsForLembretesConfirmadosAndNaoConfirmados {
    self.lembretesCompletados = nil;
    self.lembretesNaoCompletados = nil;
    
    for (ADLembrete *lembrete in self.lembretesSorted) {
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
    ADLembrete *lembrete = [self.lembretesSorted objectAtIndex:indexPath.row];
    [[ADModel sharedInstance] deleteObject:lembrete];
    
    [[ADLocalNotification sharedInstance] scheduleAllLocalNotification];
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return sectionInfo.numberOfObjects;
}

- (void)fetchObjectAtIndexPath:(NSIndexPath *)indexPath {
    self.lembrete = [self.lembretesSorted objectAtIndex:indexPath.row];
}

- (void)executeFetchRequest {
    [self.fetchedResultsController performFetch:nil];
    self.lembretesSorted = [self _sortReminders:[self.fetchedResultsController fetchedObjects]];
    [self _fetchResultsForLembretesConfirmadosAndNaoConfirmados];
}

- (NSString *)nextReminderFormated {
    NSString *message = @"Lembrete em";
    NSString *dateAsString = [[NSDate date] dateAsStringFromDate:self.lembrete.nextFireDate extended:YES];
    return [NSString stringWithFormat:@"%@ %@", message, dateAsString];
}

- (ADLembrete *)lembreteAtIndexPath:(NSIndexPath *)indexPath {
    [self fetchObjectAtIndexPath:indexPath];
    return self.lembrete;
}

- (ADLembrete *)lembreteWithDescricao:(NSString *)descricao {
    ADLembrete *lembreteWithDescricao = nil;
    
    for (ADLembrete *lembrete in self.lembretesSorted) {
        if ([lembrete.descricao isEqualToString:descricao]) {
            lembreteWithDescricao = lembrete;
            break;
        }
    }

    return lembreteWithDescricao;
}

- (NSIndexPath *)indexPathForLembreteWithDescricao:(NSString *)descricao {
    NSIndexPath *indexPath = nil;
    
    for (ADLembrete *lembrete in self.lembretesSorted) {
        if ([lembrete.descricao isEqualToString:descricao]) {
            indexPath = [NSIndexPath indexPathForRow:[self.lembretesSorted indexOfObject:lembrete] inSection:0];
            break;
        }
    }
    
    return indexPath;
}

@end