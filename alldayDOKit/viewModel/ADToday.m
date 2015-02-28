//
//  ADToday.m
//  alldayDO
//
//  Created by Fábio Nogueira de Almeida on 25/02/15.
//  Copyright (c) 2015 Fábio Nogueira . All rights reserved.
//

#import <CoreData/CoreData.h>

#import "ADToday.h"
#import "alldayDOKit.h"

@interface ADToday ()

@property (nonatomic, strong) NSMutableArray *lembretes;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)_fetchResultsForLembretesForToday;

@end

@implementation ADToday

#pragma mark - Getter Methods - 

- (NSMutableArray *)lembretes {
    if (!_lembretes) {
        _lembretes = [NSMutableArray array];
    }
    return _lembretes;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ADLembrete"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"data" ascending:YES]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[ADModel sharedInstance].managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:@"today_reminders_cache"];
    }
    return _fetchedResultsController;
}

- (NSArray *)todayReminders {
    return self.lembretes;
}

#pragma mark - Private Methods - 

- (void)_fetchResultsForLembretesForToday {
    NSArray *lembretes = [self.fetchedResultsController fetchedObjects];

#warning TODO - retornar apenas os lembretes que tem para hoje
    
    [self.lembretes addObjectsFromArray:lembretes];
}

#pragma mark - Public Methods -

- (void)executeFetchRequestForToday {
    self.lembretes = nil;
    [self.fetchedResultsController performFetch:nil];
    [self _fetchResultsForLembretesForToday];
}

@end
