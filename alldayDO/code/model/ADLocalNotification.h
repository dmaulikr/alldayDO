//
//  ADLocalNotification.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 22/08/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLocalNotification : NSObject

+ (instancetype)sharedInstance;

- (void)scheduleAllLocalNotification;

@end
