//
//  ADNotification.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADNotification.h"
#import "UILocalNotification+ADToolkitAdditions.h"

#import "ADModel.h"

@interface ADNotification ()

@end

@implementation ADNotification

#pragma mark - Getter Methods -

+ (instancetype)sharedInstance {
    static ADNotification *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[self alloc] init];
    });
    return __sharedInstance;
}

#pragma mark - Public Interface -

- (void)createLocalNotificationFor:(NSArray *)lembretes {
    for (ADLembrete *lembrete in lembretes) {
        UILocalNotification *notification = [UILocalNotification defaultLocalNotificationWith:lembrete];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

@end
