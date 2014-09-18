//
//  ADLocalNotification.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 22/08/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADLocalNotification.h"
#import "ADModel.h"

@interface ADLocalNotification ()

@property (nonatomic, readonly) NSString *alert_body;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (UILocalNotification *)_defaultLocalNotificationWith:(ADLembrete *)lembrete;

@end

@implementation ADLocalNotification

#pragma mark - Initialize Methods -

+ (instancetype)sharedInstance {
    static ADLocalNotification * __sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[ADLocalNotification alloc] init];
    });
    return __sharedInstance;
}

#pragma mark - Getter Methods - 

- (NSString *)alert_body {
    NSString *alert_body = nil;
    
    NSArray *messages = @[
        NSLocalizedString(@"Você lembrou de %@?", nil),
        NSLocalizedString(@"Hey, não esqueceu de %@ né?", nil),
        NSLocalizedString(@"Tá na hora de %@!", nil),
        NSLocalizedString(@"Passando pra lembrar que chegou a hora de %@!", nil),
        NSLocalizedString(@"Não se esqueça de %@ heim?", nil),
        NSLocalizedString(@"Chegou a hora de %@!", nil),
        NSLocalizedString(@"Agora é hora de %@!", nil),
        NSLocalizedString(@"Parem as máquinas! É hora de %@.", nil)
    ];

    int index = arc4random() % messages.count;
    alert_body = [messages objectAtIndex:index];
    return alert_body;
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

#pragma mark - Private Methods -

- (UILocalNotification *)_defaultLocalNotificationWith:(ADLembrete *)lembrete {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = lembrete.data;
    localNotification.repeatInterval = [lembrete repeatInterval];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertAction = NSLocalizedString(@"concluir a tarefa", nil);
    localNotification.alertBody = [NSString stringWithFormat:self.alert_body, lembrete.descricao];
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
        localNotification.alertBody = [NSString stringWithFormat:self.alert_body, lembrete.descricao];
        if (![lembrete.periodo isEqualToNumber:[NSNumber numberWithInt:3]]) {
             [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];   
        }
    }
}

@end
