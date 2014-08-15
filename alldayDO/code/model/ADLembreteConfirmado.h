//
//  ADLembreteConfirmado.h
//  alldayDO
//
//  Created by Fábio Almeida on 8/15/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ADLembrete;

@interface ADLembreteConfirmado : NSManagedObject

@property (nonatomic, retain) NSDate * data;
@property (nonatomic, retain) ADLembrete *lembrete;

@end
