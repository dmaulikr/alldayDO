//
//  UILocalNotification+ADToolkitAdditions.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "UILocalNotification+ADToolkitAdditions.h"
#import "ADLembrete+ADToolkitAdditions.h"

#define ALERT_BODY @"Você lembrou de %@?"
#define LocalNotificationDomain @"mobi.fabionogueira.alldayDO"

@implementation UILocalNotification (ADToolkitAdditions)

+ (instancetype)defaultLocalNotificationWith:(ADLembrete *)lembrete {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = lembrete.data;
    localNotification.repeatInterval = [lembrete repeatInterval];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertAction = @"Não esqueça!";
    localNotification.alertBody = [NSString stringWithFormat:ALERT_BODY, lembrete.descricao];;
    localNotification.applicationIconBadgeNumber =+1;
    localNotification.timeZone = [NSTimeZone localTimeZone];
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:lembrete.descricao forKey:LocalNotificationDomain];
    localNotification.userInfo = infoDict;
    
    return localNotification;
}

@end
