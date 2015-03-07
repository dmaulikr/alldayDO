//
//  NSEntityDescription+ADToolkitAdditions.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "NSEntityDescription+ADToolkitAdditions.h"

@implementation NSEntityDescription (ADToolkitAdditions)

+ (id)insertNewObjectForEntityADLembrete {
    return [NSEntityDescription insertNewObjectForEntityForName:@"ADLembrete"
                                         inManagedObjectContext:[ADModel sharedInstance].managedObjectContext];
}

+ (id)insertNewObjectForEntityADLembreteConfirmado {
    return [NSEntityDescription insertNewObjectForEntityForName:@"ADLembreteConfirmado"
                                         inManagedObjectContext:[ADModel sharedInstance].managedObjectContext];
}

+ (id)insertNewObjectForEntityADCategoria {
    return [NSEntityDescription insertNewObjectForEntityForName:@"ADCategoria"
                                         inManagedObjectContext:[ADModel sharedInstance].managedObjectContext];
}

@end
