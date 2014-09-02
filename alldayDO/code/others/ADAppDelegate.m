//
//  ADAppDelegate.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADAppDelegate.h"
#import "ADModel.h"
#import "ADLocalNotification.h"
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
    [[ADLocalNotification sharedInstance] scheduleAllLocalNotification];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[ADLocalNotification sharedInstance] scheduleAllLocalNotification];
}

#pragma mark - UIApplication Methods - Local Notification - 

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (application.applicationState == UIApplicationStateInactive ||
        application.applicationState == UIApplicationStateBackground ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:APPLICATION_DID_RECEIVE_LOCAL_NOTIFICATION_BACKGROUND object:notification];
    } else if (application.applicationState == UIApplicationStateActive ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:APPLICATION_DID_RECEIVE_LOCAL_NOTIFICATION_ACTIVE object:notification];
    }
    
}

@end