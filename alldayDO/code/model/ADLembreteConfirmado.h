//
//  ADLembreteConfirmado.h
//  alldayDO
//
//  Created by Fábio Nogueira de Almeida on 28/02/15.
//  Copyright (c) 2015 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ADLembrete;

@interface ADLembreteConfirmado : NSManagedObject

@property (nonatomic, retain) NSDate * data;
@property (nonatomic, retain) ADLembrete *lembrete;

@end
