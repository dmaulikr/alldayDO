//
//  GAI+ADToolkitAdditions.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/09/14.
//  Copyright (c) 2014 F√°bio Nogueira . All rights reserved.
//

#import "GAI.h"

@interface GAI (ADToolkitAdditions)

- (void)sendAction:(NSString *)action withCategory:(NSString *)category;
- (void)sendScreen:(NSString *)screen withCategory:(NSString *)category;

@end
