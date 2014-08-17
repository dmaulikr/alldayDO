//
//  ADAppDelegate.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADAppDelegate.h"
#import "ADModel.h"
#import "ADNotification.h"
#import "ADStyleSheet.h"

#import <Crashlytics/Crashlytics.h>

@interface ADAppDelegate ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ADAppDelegate

#pragma mark - Getter Interface -

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ADLembrete"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"descricao" ascending:YES]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[ADModel sharedInstance].managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:@"reminders_cache"];
    }
    
    return _fetchedResultsController;
}

#pragma mark - UIApplication Methods -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Crashlytics startWithAPIKey:@"ba0eee4e53729a8c93fd47ad94835d6be7ec81c8"];
    
    [ADStyleSheet initStyles];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[ADNotification sharedInstance] createLocalNotificationFor:self.fetchedResultsController.fetchedObjects];
    
    NSLog(@"\n Notificações applicationDidEnterBackground = %@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[ADNotification sharedInstance] createLocalNotificationFor:self.fetchedResultsController.fetchedObjects];
    
    NSLog(@"\n Notificações applicationDidBecomeActive = %@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
}

#pragma mark - UIApplication Methods - Local Notification - 

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:APPLICATION_DID_RECEIVE_LOCAL_NOTIFICATION object:notification];
    
    NSLog(@"%@", notification);
}



@end