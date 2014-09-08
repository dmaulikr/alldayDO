//
//  NSDateComponents+ADToolkitAdditions.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 02/08/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "NSDateComponents+ADToolkitAdditions.h"
#import "NSString+ADToolkitAdditions.h"

@implementation NSDateComponents (ADToolkitAdditions)

- (NSString *)dateAsString {
    NSString *date = @"";
    
    if (self.year && self.year != INT_MAX) {
        date = [NSString stringWithFormat:@"%d a", self.year];
    }
    
    if (self.month && self.month != INT_MAX) {
        if (date.isPresent) {
            date = [date stringByAppendingString:@", "];
        }
        
        NSString *noMeses = [NSString stringWithFormat:@"%d m", self.month];
        date = [date stringByAppendingString:noMeses];
    }
    
    if (self.day && self.day != INT_MAX) {
        if (date.isPresent) {
            date = [date stringByAppendingString:@", "];
        }
        
        NSString *noDias = [NSString stringWithFormat:@"%d d", self.day];
        date = [date stringByAppendingString:noDias];
    }

    if (self.hour && self.hour != INT_MAX) {
        if (date.isPresent) {
            date = [date stringByAppendingString:@", "];
        }
        
        NSString *noDias = [NSString stringWithFormat:@"%d h", self.hour];
        date = [date stringByAppendingString:noDias];
    }
    
    if (self.minute && self.minute != INT_MAX) {
        if (date.isPresent) {
            date = [date stringByAppendingString:@", "];
        }
        
        NSString *noDias = [NSString stringWithFormat:@"%d m", self.minute];
        date = [date stringByAppendingString:noDias];
    }
    
    if (!date.isPresent) {
        if (self.second && self.second != INT_MAX) {
            NSString *noDias = [NSString stringWithFormat:@"%d s", self.second];
            date = [date stringByAppendingString:noDias];
        }
    }
    
    return date;
}

- (NSString *)dateAsStringExtended {
    NSString *date = @"";
    
    if (self.year && self.year != INT_MAX) {
        
        NSString *yearLabel = nil;
        if (self.year == 1) {
            yearLabel = NSLocalizedString(@"ano", nil);
        } else {
            yearLabel = NSLocalizedString(@"anos", nil);
        }
        
        date = [NSString stringWithFormat:@"%d %@", self.year, yearLabel];
    }
    
    if (self.month && self.month != INT_MAX) {
        if (date.isPresent) {
            date = [date stringByAppendingString:@", "];
        }
        
        NSString *monthLabel = nil;
        if (self.month == 1) {
            monthLabel = NSLocalizedString(@"mês", nil);
        } else {
            monthLabel = NSLocalizedString(@"meses", nil);
        }
        NSString *noMeses = [NSString stringWithFormat:@"%d %@", self.month, monthLabel];
        date = [date stringByAppendingString:noMeses];
    }
    
    if (self.day && self.day != INT_MAX) {
        if (date.isPresent) {
            date = [date stringByAppendingString:@", "];
        }
        
        NSString *daylabel = nil;
        if (self.day == 1) {
            daylabel = NSLocalizedString(@"dia", nil);
        } else {
            daylabel = NSLocalizedString(@"dias", nil);
        }
        NSString *noDias = [NSString stringWithFormat:@"%d %@", self.day, daylabel];
        date = [date stringByAppendingString:noDias];
    }
    
    if (self.hour && self.hour != INT_MAX) {
        if (date.isPresent) {
            date = [date stringByAppendingString:@", "];
        }
        
        NSString *daylabel = nil;
        if (self.hour == 1) {
            daylabel = NSLocalizedString(@"hora", nil);
        } else {
            daylabel = NSLocalizedString(@"horas", nil);
        }
        NSString *noDias = [NSString stringWithFormat:@"%d %@", self.hour, daylabel];
        date = [date stringByAppendingString:noDias];
    }
    
    if (self.minute && self.minute != INT_MAX) {
        if (date.isPresent) {
            date = [date stringByAppendingString:@" e "];
        }
        
        NSString *daylabel = nil;
        if (self.minute == 1) {
            daylabel = NSLocalizedString(@"minuto", nil);
        } else {
            daylabel = NSLocalizedString(@"minutos", nil);
        }
        NSString *noDias = [NSString stringWithFormat:@"%d %@", self.minute, daylabel];
        date = [date stringByAppendingString:noDias];
    }
    
    if (!date.isPresent) {
        NSString *daylabel = nil;
        if (self.second == 1) {
            daylabel = NSLocalizedString(@"segundo", nil);
        } else {
            daylabel = NSLocalizedString(@"segundos", nil);
        }
        NSString *noDias = [NSString stringWithFormat:@"%d %@", self.second, daylabel];
        date = [date stringByAppendingString:noDias];
    }
    
    return date;
}

@end
