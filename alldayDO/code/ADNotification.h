//
//  ADNotification.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADLembrete.h"

@interface ADNotification : NSObject

+ (instancetype)sharedInstance;


- (void)createLocalNotificationFor:(NSArray *)lembretes;

@end
