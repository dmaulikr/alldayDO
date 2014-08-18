//
//  UILocalNotification+ADToolkitAdditions.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADLembrete.h"

#define APPLICATION_DID_RECEIVE_LOCAL_NOTIFICATION_ACTIVE @"ApplicationDidReceiveLocalNotificationActive"
#define APPLICATION_DID_RECEIVE_LOCAL_NOTIFICATION_BACKGROUND @"ApplicationDidReceiveLocalNotificationBackground"

#define LOCAL_NOTIFICATION_DOMAIN @"mobi.fabionogueira.alldayDO"

@interface UILocalNotification (ADToolkitAdditions)

+ (instancetype)defaultLocalNotificationWith:(ADLembrete *)lembrete;

- (NSDate *)myNextFireDateAfterDate:(NSDate *)afterDate;

@end
