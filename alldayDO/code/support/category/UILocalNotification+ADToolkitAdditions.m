//
//  UILocalNotification+ADToolkitAdditions.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "UILocalNotification+ADToolkitAdditions.h"
#import "ADLembrete+ADToolkitAdditions.h"

@implementation UILocalNotification (ADToolkitAdditions)

// Código Copiado do link - http://stackoverflow.com/questions/20926952/detect-next-uilocalnotification-that-will-fire

- (NSDate *)myNextFireDateAfterDate:(NSDate *)afterDate {
    
    // Check if fire date is in the future:
    if ([self.fireDate compare:afterDate] == NSOrderedDescending) {
        return self.fireDate;
    }
    
    // The notification can have its own calendar, but the default is the current calendar:
    NSCalendar *cal = self.repeatCalendar;
    if (cal == nil) {
        cal = [NSCalendar currentCalendar];   
    }
    
    // Number of repeat intervals between fire date and the reference date:
    NSDateComponents *difference = [cal components:self.repeatInterval
                                          fromDate:self.fireDate
                                            toDate:afterDate
                                           options:0];
    
    // Add this number of repeat intervals to the initial fire date:
    NSDate *nextFireDate = [cal dateByAddingComponents:difference
                                                toDate:self.fireDate
                                               options:0];
    
    // If necessary, add one more:
    if ([nextFireDate compare:afterDate] == NSOrderedAscending) {
        switch (self.repeatInterval) {
            case NSCalendarUnitMonth:
                difference.month++;
                break;
            case kCFCalendarUnitWeek:
                difference.week++;
                break;
            case NSCalendarUnitDay:
                difference.day++;
                break;
            case NSCalendarUnitHour:
                difference.hour++;
                break;
                // ... add cases for other repeat intervals ...
            default:
                break;
        }
        nextFireDate = [cal dateByAddingComponents:difference
                                            toDate:self.fireDate
                                           options:0];
    }
    return nextFireDate;
}

@end