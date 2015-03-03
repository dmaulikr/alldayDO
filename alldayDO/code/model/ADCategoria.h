//
//  ADCategoria.h
//  alldayDO
//
//  Created by Fábio Nogueira de Almeida on 02/03/15.
//  Copyright (c) 2015 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ADLembrete;

@interface ADCategoria : NSManagedObject

@property (nonatomic, retain) NSString *descricao;
@property (nonatomic, retain) NSSet *lembrete;

@end

@interface ADCategoria (CoreDataGeneratedAccessors)

- (void)addLembreteObject:(ADLembrete *)value;
- (void)removeLembreteObject:(ADLembrete *)value;
- (void)addLembrete:(NSSet *)values;
- (void)removeLembrete:(NSSet *)values;

@end
