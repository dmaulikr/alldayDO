//
//  NSString+ADToolkitAdditions.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 02/08/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "NSString+ADToolkitAdditions.h"

@implementation NSString (ADToolkitAdditions)

- (BOOL)isPresent {
    return self && [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0;
}

#pragma mark - Strings Kinds

- (BOOL)isDigit {
    NSRegularExpression *digitRegex = [NSRegularExpression regularExpressionWithPattern:@"\\d*" options:0 error:NULL];
    NSRange range = [digitRegex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    return self.length > 0 && range.length == self.length;
}

@end
