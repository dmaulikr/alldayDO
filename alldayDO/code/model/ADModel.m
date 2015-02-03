//
//  ADModel.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADModel.h"

#define REMINDER_NOTIFICATION_CACHE_NAME @"reminder_notification"
#define ICLOUD_STORE_KEY @"alldayDOCloudStore"

@interface ADModel ()

- (void)_persistentStoreDidImportUbiquitousContentChanges:(NSNotification *)changeNotification;
- (void)_storesWillChange:(NSNotification *)notification;
- (void)_storesDidChange:(NSNotification *)notification;

@end

@implementation ADModel

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Getter Methods

+ (instancetype)sharedInstance {
    static ADModel * __sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[ADModel alloc] init];
        [__sharedInstance registerForiCloudNotifications];
    });
    return __sharedInstance;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ADLembrete"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"descricao" ascending:YES]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[ADModel sharedInstance].managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:REMINDER_NOTIFICATION_CACHE_NAME];
    }
    return _fetchedResultsController;
}

#pragma mark - Core Data Components

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"alldayDO" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.alldaydo"];
    
    NSURL *storeURL = [groupURL URLByAppendingPathComponent:@"alldayDO.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *storeOptions = @{NSPersistentStoreUbiquitousContentNameKey : ICLOUD_STORE_KEY};
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:storeOptions
                                                           error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Public Methods

- (void)saveChanges {
    NSError *error = nil;
    if ([self.managedObjectContext hasChanges]) {
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Save failed: %@", [error localizedDescription]);
        } else {
            [self _storesWillChange:nil];
            NSLog(@"Save succeeded");
        }
    }
}

- (void)cancelChanges {
    [self.managedObjectContext rollback];
}

- (void)reloadChangesiCloud {
    [self _storesWillChange:nil];
}

- (void)deleteObject:(id)object {
    [self.managedObjectContext deleteObject:object];
    [self saveChanges];
}

#pragma mark - Notification Observers

- (void)registerForiCloudNotifications {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector(_storesWillChange:)
                               name:NSPersistentStoreCoordinatorStoresWillChangeNotification
                             object:self.persistentStoreCoordinator];
    
    [notificationCenter addObserver:self
                           selector:@selector(_storesDidChange:)
                               name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                             object:self.persistentStoreCoordinator];
    
    [notificationCenter addObserver:self
                           selector:@selector(_persistentStoreDidImportUbiquitousContentChanges:)
                               name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                             object:self.persistentStoreCoordinator];
}

# pragma mark - iCloud Support

- (void)_persistentStoreDidImportUbiquitousContentChanges:(NSNotification *)changeNotification {
    [self.managedObjectContext performBlock:^{
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:changeNotification];
    }];    
}

- (void)_storesWillChange:(NSNotification *)notification {
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error;
        if ([self.managedObjectContext hasChanges]) {
            if (![self.managedObjectContext save:&error] && error) {
                NSLog(@"%@", [error localizedDescription]);
            }
        }
        [self.managedObjectContext reset];
    }];
}

- (void)_storesDidChange:(NSNotification *)notification {
    // update UI
}

@end