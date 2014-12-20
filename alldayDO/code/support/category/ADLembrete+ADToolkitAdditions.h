//
//  ADLembrete+ADToolkitAdditions.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 03/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "alldayDOKit.h"

#define LOCAL_NOTIFICATION_DOMAIN @"mobi.fabionogueira.alldayDO"

@interface ADLembrete (ADToolkitAdditions)

- (NSInteger)repeatInterval;
- (NSDate *)nextFireDate;
- (NSDate *)dateFormattedForJustOneTime;

@end
