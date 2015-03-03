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
#import <iRate.h>
#import <Parse/Parse.h>

@interface ADAppDelegate () <EAIntroDelegate>

- (void)_setupAnalytics;
- (void)_setupCrashlytics;
- (void)_setupRate;
- (void)_walkthrough;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsControllerForCategoria;

@end

@implementation ADAppDelegate

#pragma mark - Getter Interface -

- (NSFetchedResultsController *)fetchedResultsControllerForCategoria {
    if (!_fetchedResultsControllerForCategoria) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ADCategoria"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"categoria" ascending:YES]];
        _fetchedResultsControllerForCategoria = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[ADModel sharedInstance].managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:@"categoria_cache"];
    }
    return _fetchedResultsControllerForCategoria;
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

- (void)_setupRate {
    [iRate sharedInstance].daysUntilPrompt = 3.f;
    [iRate sharedInstance].remindPeriod = 8.f;

    [iRate sharedInstance].messageTitle = @"Gostou do alldayDO?";

    [iRate sharedInstance].message = @"O alldayDO lhe ajuda no\ndia-a-dia? Poderia avaliá-lo?\n\nNão vai demorar mais de um minuto.\nObrigado pelo apoio.";

    [iRate sharedInstance].cancelButtonLabel = @"Não, Obrigado";
    [iRate sharedInstance].rateButtonLabel = @"Avaliar agora";
    [iRate sharedInstance].remindButtonLabel = @"Avaliar mais tarde";

    [iRate sharedInstance].promptForNewVersionIfUserRated = NO;
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
}

- (void)_setupPushNotification {
    [Parse setApplicationId:@"9pfskNLkTOcoeq0mFRFrIhbXP608aDl84rdkPAvh"
                  clientKey:@"GIgl8dUghpL9IzWZTV0BlyXSdJEtxOxBZXJz3Mal"];
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

- (void)_updateDB {
    [self.fetchedResultsControllerForCategoria performFetch:nil];
    NSArray *categorias = [self.fetchedResultsControllerForCategoria fetchedObjects];
    if (categorias.count != 3) {
        ADCategoria *categoria1 = [NSEntityDescription insertNewObjectForEntityADCategoria];
        categoria1.categoria = NSLocalizedString(@"personal", nil);
        
        ADCategoria *categoria2 = [NSEntityDescription insertNewObjectForEntityADCategoria];
        categoria2.categoria = NSLocalizedString(@"home", nil);
        
        ADCategoria *categoria3 = [NSEntityDescription insertNewObjectForEntityADCategoria];
        categoria3.categoria = NSLocalizedString(@"work", nil);
        
        [[ADModel sharedInstance] saveChanges];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ADStyleSheet initStyles];
    [self _setupAnalytics];
    [self _setupCrashlytics];
    [self _setupRate];
    [self _setupPushNotification];
    
    [self _walkthrough];
    [self _updateDB];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    if ([UIApplication instancesRespondToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
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

#pragma mark - UIApplication Methods - Remote Notification -

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

#pragma mark - EAIntroDelegate Methods

- (void)introDidFinish:(EAIntroView *)introView {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

@end