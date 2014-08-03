//
//  NSLocale+ADToolkitAdditions.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 02/08/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "NSLocale+ADToolkitAdditions.h"

@implementation NSLocale (ADToolkitAdditions)

+ (NSLocale *)brazilian {
    return [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
}

@end
