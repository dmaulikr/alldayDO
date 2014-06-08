//
//  ADStyleSheet.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 07/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADStyleSheet.h"

@implementation ADStyleSheet

+ (void)initStyles {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigation_bg"]
                                       forBarMetrics:UIBarMetricsDefault];
}

@end
