//
//  ADToday.h
//  alldayDO
//
//  Created by Fábio Nogueira de Almeida on 25/02/15.
//  Copyright (c) 2015 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADToday : NSObject

@property (nonatomic, readonly) NSMutableArray *todayReminders;

- (void)executeFetchRequestForToday;

@end
