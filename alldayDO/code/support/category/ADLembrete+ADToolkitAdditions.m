//
//  ADLembrete+ADToolkitAdditions.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 03/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADLembrete+ADToolkitAdditions.h"

@implementation ADLembrete (ADToolkitAdditions)

- (NSInteger)repeatInterval {
    NSInteger repeatInterval;
    switch (self.periodo.intValue) {
        case 0:
            repeatInterval = kCFCalendarUnitDay;
            break;
        case 1:
            repeatInterval = kCFCalendarUnitWeek;
            break;
        case 2:
            repeatInterval = kCFCalendarUnitMonth;
            break;
        default:
            repeatInterval = 0;
            break;
    }
    return repeatInterval;
}

- (NSDate *)nextFireDate {
    NSDate *nextFireDate = [NSDate date];
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notifications) {
        if ([[notification.userInfo objectForKey:LOCAL_NOTIFICATION_DOMAIN] isEqualToString:self.descricao]) {
            
            NSDate *dateInicial = [NSDate date];
            if ([self.dataInicial compare:dateInicial] == NSOrderedDescending) {
                dateInicial = self.dataInicial;
            }
            nextFireDate = [notification myNextFireDateAfterDate:dateInicial];
        }
    }
    return nextFireDate;
}

- (NSDate *)dateFormattedForJustOneTime {
    NSDateComponents *component = [[NSDateComponents alloc] init];
    [component setDay:self.dataInicial.day];
    [component setMonth:self.dataInicial.month];
    [component setYear:self.dataInicial.year];
    [component setHour:self.data.hour];
    [component setMinute:self.data.minute];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar dateFromComponents:component];
}

@end
