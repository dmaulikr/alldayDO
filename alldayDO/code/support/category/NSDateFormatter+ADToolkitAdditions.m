//
//  NSDateFormatter+ADToolkitAdditions.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 02/08/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "NSDateFormatter+ADToolkitAdditions.h"

@implementation NSDateFormatter (ADToolkitAdditions)

+ (NSDateFormatter *)formatter {
    return [[NSDateFormatter alloc] init];
}

+ (NSDateFormatter *)formatterWithFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [NSDateFormatter formatter];
    formatter.locale = [NSLocale autoupdatingCurrentLocale];
    formatter.dateFormat = dateFormat;
    return formatter;
}

+ (NSDateFormatter *)formatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
    NSDateFormatter *formatter = [NSDateFormatter formatter];
    formatter.dateStyle = dateStyle;
    formatter.timeStyle = timeStyle;
    formatter.locale = [NSLocale autoupdatingCurrentLocale];
    return formatter;
}

+ (NSDateFormatter *)formatterWithInverseDateFormat {
    return [self formatterWithFormat:@"yyyy/MM/dd"];
}

+ (NSDateFormatter *)formatterWithMonthAndYearDateFormat {
    return [self formatterWithFormat:@"LLLL 'de' yyyy"];
}

+ (NSDateFormatter *)formatterWithBrazilianDateFormat {
    NSDateFormatter *formatter = [self formatterWithFormat:@"dd/MM/yyyy"];
    formatter.locale = [NSLocale autoupdatingCurrentLocale];
    return formatter;
}

+ (NSDateFormatter *)formatterWithBrazilianDateTimeFormat {
    return [self formatterWithBrazilianDateTimeFormatShowingSeconds:YES];
}

+ (NSDateFormatter *)formatterWithBrazilianDateTimeFormatShowingSeconds:(BOOL)showingSeconds {
    NSString *format = @"dd/MM/yyyy HH:mm";
    if (showingSeconds) {
        format = [format stringByAppendingString:@":ss"];   
    }
    NSDateFormatter *formatter = [NSDateFormatter formatterWithFormat:format];
    formatter.locale = [NSLocale autoupdatingCurrentLocale];
    return formatter;
}

+ (NSDateFormatter *)formatterWithBrazilianExtention {
    NSDateFormatter *formatter = [NSDateFormatter formatterWithFormat:@"eee, d 'de' MMM HH:mm"];
    formatter.locale = [NSLocale autoupdatingCurrentLocale];
    return formatter;
}

+ (NSDateFormatter *)formatterWithOnlyHours {
    NSDateFormatter *formatter = [NSDateFormatter formatterWithFormat:@"HH:mm"];
    formatter.locale = [NSLocale autoupdatingCurrentLocale];
    return formatter;
}

@end
