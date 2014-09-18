//
//  NSDateFormatter+ADToolkitAdditions.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 02/08/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (ADToolkitAdditions)

+ (NSDateFormatter *)formatter;
+ (NSDateFormatter *)formatterWithFormat:(NSString *)dateFormat;
+ (NSDateFormatter *)formatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
+ (NSDateFormatter *)formatterWithInverseDateFormat;
+ (NSDateFormatter *)formatterWithOnlyHours;

@end
