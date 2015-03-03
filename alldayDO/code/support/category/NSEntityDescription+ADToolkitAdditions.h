//
//  NSEntityDescription+ADToolkitAdditions.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <CoreData/CoreData.h>
#import <alldayDOKit/alldayDOKit.h>

@interface NSEntityDescription (ADToolkitAdditions)

+ (id)insertNewObjectForEntityADLembrete;
+ (id)insertNewObjectForEntityADLembreteConfirmado;
+ (id)insertNewObjectForEntityADCategoria;

@end
