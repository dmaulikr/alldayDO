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
#import "GAI.h"

#import <Crashlytics/Crashlytics.h>

@interface ADAppDelegate ()

- (void)_setupAnalytics;
- (void)_setupCrashlytics;

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

#pragma mark - Private Methods - 

- (void)_setupAnalytics {
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;
    gai.dispatchInterval = 20;
    [gai trackerWithTrackingId:@"UA-42898056-2"];
}

- (void)_setupCrashlytics {
    [Crashlytics startWithAPIKey:@"ba0eee4e53729a8c93fd47ad94835d6be7ec81c8"];
}

#pragma mark - UIApplication Methods -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self _setupAnalytics];
    [self _setupCrashlytics];
    
    [ADStyleSheet initStyles];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventAction value:@"ClosedAppActivity"];
    [tracker set:kGAIEventCategory value:@"Action"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [[ADLocalNotification sharedInstance] scheduleAllLocalNotification];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventAction value:@"OpenAppActivity"];
    [tracker set:kGAIEventCategory value:@"Action"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[ADLocalNotification sharedInstance] scheduleAllLocalNotification];
}

#pragma mark - UIApplication Methods - Local Notification - 

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

    if (application.applicationState == UIApplicationStateInactive ||
        application.applicationState == UIApplicationStateBackground ) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIEventAction value:@"OpenFromPushActivity"];
        [tracker set:kGAIEventCategory value:@"Action"];
        [tracker send:[[GAIDictionaryBuilder createAppView] build]];
        
            [[NSNotificationCenter defaultCenter] postNotificationName:APPLICATION_DID_RECEIVE_LOCAL_NOTIFICATION_BACKGROUND object:notification];
    } else if (application.applicationState == UIApplicationStateActive ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:APPLICATION_DID_RECEIVE_LOCAL_NOTIFICATION_ACTIVE object:notification];
    }
    
}

@end