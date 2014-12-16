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
#import "ADWalkthrough.h"

#import "alldayDO-Swift.h"

#import <Crashlytics/Crashlytics.h>

@interface ADAppDelegate () <EAIntroDelegate>

- (void)_setupAnalytics;
- (void)_setupCrashlytics;
- (void)_walkthrough;

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

- (void)_walkthrough {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
        ADWalkthrough *walkthroughView = [[ADWalkthrough alloc] initWithFrame:self.window.frame];
        walkthroughView.delegate = self;
        [walkthroughView showInView:self.window.rootViewController.view animateDuration:0.4f];
    }
}

#pragma mark - UIApplication Methods -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ADStyleSheet initStyles];
    [self _setupAnalytics];
    [self _setupCrashlytics];
    [self _walkthrough];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[GAI sharedInstance] sendAction:@"ClosedAppActivity" withCategory:@"Action"];
    [[ADLocalNotification sharedInstance] scheduleAllLocalNotification];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[GAI sharedInstance] sendAction:@"OpenAppActivity" withCategory:@"Action"];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[ADLocalNotification sharedInstance] scheduleAllLocalNotification];
}

#pragma mark - UIApplication Methods - Local Notification - 

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (application.applicationState == UIApplicationStateInactive ||
        application.applicationState == UIApplicationStateBackground ) {
        [[GAI sharedInstance] sendAction:@"OpenFromPushActivity" withCategory:@"Action"];
        [[NSNotificationCenter defaultCenter] postNotificationName:APPLICATION_DID_RECEIVE_LOCAL_NOTIFICATION_BACKGROUND object:notification];
    } else if (application.applicationState == UIApplicationStateActive ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:APPLICATION_DID_RECEIVE_LOCAL_NOTIFICATION_ACTIVE object:notification];
    }
}

#pragma mark - EAIntroDelegate Methods

- (void)introDidFinish:(EAIntroView *)introView {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

@end