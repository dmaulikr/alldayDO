//
//  ADLocalNotification.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 22/08/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADLocalNotification.h"
#import "ADModel.h"

#define ALERT_BODY @"Você lembrou de %@?"

@interface ADLocalNotification ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (UILocalNotification *)_defaultLocalNotificationWith:(ADLembrete *)lembrete;

@end

@implementation ADLocalNotification

#pragma mark - Initialize Methods -

+ (instancetype)sharedInstance {
    static ADLocalNotification *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[ADLocalNotification alloc] init];
    });
    return __sharedInstance;
}


#pragma mark - Getter Methods - 

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

#pragma mark - Private Methods -

- (UILocalNotification *)_defaultLocalNotificationWith:(ADLembrete *)lembrete {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = lembrete.data;
    localNotification.repeatInterval = [lembrete repeatInterval];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertAction = @"concluir a tarefa";
    localNotification.alertBody = [NSString stringWithFormat:ALERT_BODY, lembrete.descricao];
    localNotification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    localNotification.timeZone = [NSTimeZone localTimeZone];
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:lembrete.descricao forKey:LOCAL_NOTIFICATION_DOMAIN];
    localNotification.userInfo = infoDict;
    
    return localNotification;
}

#pragma mark - Public Methods -

- (void)scheduleAllLocalNotification {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self.fetchedResultsController performFetch:nil];
    for (ADLembrete *lembrete in [self.fetchedResultsController fetchedObjects]) {
        UILocalNotification *localNotification = [self _defaultLocalNotificationWith:lembrete];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

@end
