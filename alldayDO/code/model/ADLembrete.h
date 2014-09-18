//
//  ADLembrete.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 16/08/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ADLembreteConfirmado;

@interface ADLembrete : NSManagedObject

@property (nonatomic, retain) NSDate *data;
@property (nonatomic, retain) NSDate *dataInicial;
@property (nonatomic, retain) NSString *descricao;
@property (nonatomic, retain) NSData *imagem;
@property (nonatomic, retain) NSNumber *periodo;
@property (nonatomic, retain) NSNumber *seguidos;
@property (nonatomic, retain) NSSet *lembretesConfirmados;

@end

@interface ADLembrete (CoreDataGeneratedAccessors)

- (void)addLembretesConfirmadosObject:(ADLembreteConfirmado *)value;
- (void)removeLembretesConfirmadosObject:(ADLembreteConfirmado *)value;
- (void)addLembretesConfirmados:(NSSet *)values;
- (void)removeLembretesConfirmados:(NSSet *)values;

@end
