//
//  NSDate+ADToolkitAdditions.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 02/08/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "NSDate+ADToolkitAdditions.h"
#import "NSDateComponents+ADToolkitAdditions.h"
#import "NSDateFormatter+ADToolkitAdditions.h"

@implementation NSDate (ADToolkitAdditions)


#pragma mark - Private Interface

- (NSCalendar *)currentCalendarStartingOnSunday:(BOOL)sunday {
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    if (sunday) {
        currentCalendar.firstWeekday = ADWeekdaySunday;
    } else {
        currentCalendar.firstWeekday = ADWeekdayMonday;
    }
    return currentCalendar;
}

#pragma mark - Date Management

+ (NSDate *)vbDate {
    return [[self dateWithDay:30 month:12 year:1899] beginningOfDay];
}

+ (NSDate *)dateWithDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = day;
    dateComponents.month = month;
    dateComponents.year = year;
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

+ (NSDate *)dateFormattedWithDate:(NSDate *)date andHourFromAnotherDate:(NSDate *)hour {
    NSDateComponents *component = [[NSDateComponents alloc] init];
    [component setDay:date.day];
    [component setMonth:date.month];
    [component setYear:date.year];
    [component setHour:hour.hour];
    [component setMinute:hour.minute];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar dateFromComponents:component];
}

- (NSDate *)dateByAddingComponents:(NSDateComponents *)dateComponents {
    return [self dateByAddingComponents:dateComponents timeZone:nil];
}

- (NSDate *)dateByAddingComponents:(NSDateComponents *)dateComponents timeZone:(NSTimeZone *)timeZone {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if (timeZone) {
        calendar.timeZone = timeZone;
    }
    return [calendar dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDate *)dateByAddingDays:(NSInteger)numberOfDays {
    NSDateComponents *daysComponent = [[NSDateComponents alloc] init];
    daysComponent.day = numberOfDays;
    return [self dateByAddingComponents:daysComponent];
}

- (NSDate *)dateByAddingMonths:(NSInteger)numberOfMonths {
    NSDateComponents *monthComponent = [[NSDateComponents alloc] init];
    monthComponent.month = numberOfMonths;
    return [self dateByAddingComponents:monthComponent];
}

- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears {
    NSDateComponents *yearComponent = [[NSDateComponents alloc] init];
    yearComponent.year = numberOfYears;
    return [self dateByAddingComponents:yearComponent];
}

- (NSDate *)dateBySettingTime:(NSString *)time {
    NSArray *timeComponents = [time componentsSeparatedByString:@":"];
    NSInteger hours = [[timeComponents firstObject] intValue];
    NSInteger minutes = [[timeComponents lastObject] intValue];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = hours;
    components.minute = minutes;
    return [[self beginningOfDay] dateByAddingComponents:components];
}

- (NSDate *)beginningOfUnit:(NSCalendarUnit)unit {
    NSDate *date = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:unit startDate:&date interval:NULL forDate:self];
    return date;
}

- (NSDate *)beginningOfDay {
    return [self beginningOfUnit:NSCalendarUnitDay];
}

- (NSDate *)endOfDay {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.second = -1;
    return [[[self beginningOfDay] dateByAddingDays:1] dateByAddingComponents:components];
}

- (NSDate *)noon {
    NSDateComponents *noonComponent = [[NSDateComponents alloc] init];
    noonComponent.hour = 12;
    return [[self beginningOfDay] dateByAddingComponents:noonComponent];
}

- (NSDate *)tomorrow {
    return [self dateByAddingDays:1];
}

- (NSDate *)yesterday {
    return [self dateByAddingDays:-1];
}

- (NSDate *)nextWeek {
    return [self dateByAddingDays:7];
}

- (NSDate *)nextMonth {
    return [self dateByAddingMonths:1];
}

- (NSDate *)lastMonth {
    return [self dateByAddingMonths:-1];
}

- (NSDate *)nextYear {
    return [self dateByAddingYears:1];
}

- (NSDate *)lastYear {
    return [self dateByAddingYears:-1];
}

- (NSDate *)firstDayInMonth {
    return [self beginningOfUnit:NSCalendarUnitMonth];
}

- (NSDate *)lastDayInMonth {
    return [[[self firstDayInMonth] nextMonth] yesterday];
}

#pragma mark - Formatting

- (NSString *)stringWithInverseDateFormat {
    return [[NSDateFormatter formatterWithInverseDateFormat] stringFromDate:self];
}

- (NSString *)stringWithOnlyHours {
    return [[NSDateFormatter formatterWithOnlyHours] stringFromDate:self];
}

#pragma mark - Date Components

- (NSInteger)minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}


- (NSInteger)daysInMonth {
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}

- (BOOL)compareComponents:(NSUInteger)unitFlags withDate:(NSDate *)date {
    NSDateComponents *componentsFromSelf = [[NSCalendar currentCalendar] components:unitFlags fromDate:self];
    NSDateComponents *componentsFromOther = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    return [componentsFromSelf isEqual:componentsFromOther];
}

- (BOOL)isToday {
    return [self isSameDay:[NSDate date]];
}

- (BOOL)isCurrentWeek {
    return [self isSameWeek:[NSDate date]];
}

- (BOOL)isCurrentMonth {
    return [self isSameMonth:[NSDate date]];
}

- (BOOL)isCurrentYear {
    return [self compareComponents:NSCalendarUnitYear withDate:[NSDate date]];
}

- (BOOL)isSameDay:(NSDate *)date {
    NSInteger dayMonthYear = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
    return [self compareComponents:dayMonthYear withDate:date];
}

- (BOOL)isSameWeek:(NSDate *)date {
    NSInteger weekMonthYear = NSCalendarUnitWeekOfMonth|NSCalendarUnitMonth|NSCalendarUnitYear;
    return [self compareComponents:weekMonthYear withDate:date];
}

- (BOOL)isSameMonth:(NSDate *)date {
    NSInteger monthYear = NSCalendarUnitMonth|NSCalendarUnitYear;
    return [self compareComponents:monthYear withDate:date];
}

- (BOOL)isPast {
    return [self compare:[NSDate date].beginningOfDay] == NSOrderedAscending;
}

- (BOOL)isFuture {
    return [self compare:[NSDate date].endOfDay] == NSOrderedDescending;
}

- (NSString *)dateAsString {
    return [self dateAsStringFromDate:[NSDate date] extended:NO];
}

- (NSString *)dateAsStringExtended {
    return [self dateAsStringFromDate:[NSDate date] extended:YES];
}

- (NSString *)dateAsStringFromDate:(NSDate *)date extended:(BOOL)extended {
    NSUInteger componentsFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:componentsFlag
                                                                   fromDate:self
                                                                     toDate:date
                                                                    options:0];
    NSString *dataAsString = nil;
    if (extended) {
        dataAsString = [components dateAsStringExtended];
    } else {
        dataAsString = [components dateAsString];
    }
    return dataAsString;
}

@end
