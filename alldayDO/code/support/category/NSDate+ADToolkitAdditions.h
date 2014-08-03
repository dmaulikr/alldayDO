//
//  NSDate+ADToolkitAdditions.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 02/08/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>

#define NUMBER_WEEDAYS 7

enum {
    ADWeekdaySunday = 1,
    ADWeekdayMonday,
    ADWeekdayTuesday,
    ADWeekdayWednesday,
    ADWeekdayThursday,
    ADWeekdayFriday,
    ADWeekdaySaturday,
};
typedef NSUInteger ADWeekday;


@interface NSDate (ADToolkitAdditions)

- (NSCalendar *)currentCalendarStartingOnSunday:(BOOL)sunday;

+ (NSDate *)vbDate;
+ (NSDate *)dateWithDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year;

- (NSDate *)dateByAddingComponents:(NSDateComponents *)dateComponents;
- (NSDate *)dateByAddingComponents:(NSDateComponents *)dateComponents timeZone:(NSTimeZone *)timeZone;
- (NSDate *)dateByAddingDays:(NSInteger)numberOfDays;
- (NSDate *)dateByAddingMonths:(NSInteger)numberOfMonths;
- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears;
- (NSDate *)dateBySettingTime:(NSString *)time;
- (NSDate *)beginningOfUnit:(NSCalendarUnit)unit;
- (NSDate *)beginningOfDay;
- (NSDate *)endOfDay;
- (NSDate *)noon;
- (NSDate *)tomorrow;
- (NSDate *)yesterday;
- (NSDate *)nextMonth;
- (NSDate *)lastMonth;
- (NSDate *)nextYear;
- (NSDate *)lastYear;
- (NSDate *)lastWeekday:(ADWeekday)weekday;
- (NSDate *)nextWeekday:(ADWeekday)weekday;
- (NSDate *)firstDayInMonth;
- (NSDate *)lastDayInMonth;

- (NSString *)stringWithInverseDateFormat;
- (NSString *)stringWithMonthAndYear;
- (NSString *)stringWithSmallDateAndTime;
- (NSString *)stringWithBrazilianDateFormat;
- (NSString *)stringWithBrazilianDateTimeFormat;
- (NSString *)stringWithBrazilianDateTimeFormatShowingSeconds:(BOOL)showingSeconds;
- (NSString *)stringWithOnlyHours;

- (NSInteger)minute;
- (NSInteger)hour;
- (NSInteger)day;
- (NSInteger)month;
- (NSInteger)year;
- (NSInteger)weekday;
- (NSInteger)weekdayWithWeekStartingOnSunday:(BOOL)sunday;
- (NSInteger)daysInMonth;
- (NSInteger)weeksInMonth;
- (NSInteger)weeksInMonthStartingOnSunday:(BOOL)sunday;

- (BOOL)compareComponents:(NSUInteger)unitFlags withDate:(NSDate *)date;
- (BOOL)isToday;
- (BOOL)isCurrentMonth;
- (BOOL)isCurrentYear;
- (BOOL)isSameDay:(NSDate *)date;
- (BOOL)isSameMonth:(NSDate *)date;

- (BOOL)isPast;
- (BOOL)isFuture;

- (NSString *)dateAsString;
- (NSString *)dateAsStringExtended;
- (NSString *)dateAsStringFromDate:(NSDate *)date extended:(BOOL)extended;

@end
