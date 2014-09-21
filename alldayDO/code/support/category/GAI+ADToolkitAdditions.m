//
//  GAI+ADToolkitAdditions.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/09/14.
//  Copyright (c) 2014 F√°bio Nogueira . All rights reserved.
//

#import "GAI+ADToolkitAdditions.h"

@implementation GAI (ADToolkitAdditions)

- (void)sendAction:(NSString *)action withCategory:(NSString *)category {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                         action:action
                                                          label:nil
                                                          value:nil] build]];
}

- (void)sendScreen:(NSString *)screen withCategory:(NSString *)category {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:screen];
    [tracker set:kGAIEventCategory value:category];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

@end
