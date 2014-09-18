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

+ (NSDateFormatter *)formatterWithOnlyHours {
    NSDateFormatter *formatter = [NSDateFormatter formatterWithFormat:@"HH:mm"];
    formatter.locale = [NSLocale autoupdatingCurrentLocale];
    return formatter;
}

@end
