//
//  ADLembrete+ADToolkitAdditions.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 03/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADLembrete.h"

@interface ADLembrete (ADToolkitAdditions)

- (NSInteger)repeatInterval;
- (NSDate *)nextFireDate;

@end
