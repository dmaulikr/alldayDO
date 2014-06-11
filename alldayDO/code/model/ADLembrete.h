//
//  ADLembrete.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 10/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ADLembrete : NSManagedObject

@property (nonatomic, retain) NSDate * data;
@property (nonatomic, retain) NSString * descricao;
@property (nonatomic, retain) NSNumber * periodo;
@property (nonatomic, retain) NSData * imagem;
@property (nonatomic, retain) NSDate * dataInicial;

@end
