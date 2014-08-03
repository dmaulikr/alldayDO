//
//  NSString+ADToolkitAdditions.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 02/08/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ADToolkitAdditions)

@property (nonatomic, readonly) BOOL isPresent;

- (BOOL)isDigit;

@end
