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
        case 3:
            repeatInterval = kCFCalendarUnitYear;
            break;
        default:
        repeatInterval = 0;
        break;
    }
    return repeatInterval;
}

@end
