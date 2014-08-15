//
//  ADLembrete.h
//  alldayDO
//
//  Created by Fábio Almeida on 8/14/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ADLembreteConfirmado;

@interface ADLembrete : NSManagedObject

@property (nonatomic, retain) NSDate * data;
@property (nonatomic, retain) NSDate * dataInicial;
@property (nonatomic, retain) NSString * descricao;
@property (nonatomic, retain) NSData * imagem;
@property (nonatomic, retain) NSNumber * periodo;
@property (nonatomic, retain) NSSet *lembreteConfirmado;
@end

@interface ADLembrete (CoreDataGeneratedAccessors)

- (void)addLembreteConfirmadoObject:(ADLembreteConfirmado *)value;
- (void)removeLembreteConfirmadoObject:(ADLembreteConfirmado *)value;
- (void)addLembreteConfirmado:(NSSet *)values;
- (void)removeLembreteConfirmado:(NSSet *)values;

@end
