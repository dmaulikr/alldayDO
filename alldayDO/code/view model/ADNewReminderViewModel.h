//
//  ADNewReminderViewModel.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 14/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADNewReminderViewModel : NSObject

@property (nonatomic, strong) NSDate * data;
@property (nonatomic, strong) NSString * descricao;
@property (nonatomic, strong) NSNumber * periodo;
@property (nonatomic, strong) NSData * imagem;
@property (nonatomic, strong) NSDate * dataInicial;

@property (nonatomic, strong) NSArray *cycleType;

- (void)saveChanges;

- (NSString *)textForCycleType:(NSInteger)cycleType;

@end
