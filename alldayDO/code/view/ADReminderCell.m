//
//  ADReminderCell.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 07/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADReminderCell.h"

@interface ADReminderCell ()

- (void)_initialize;

@end

@implementation ADReminderCell

#pragma mark - Getter Methods -

- (UIImageView *)hexaconImageView {
    if (!_hexaconImageView) {
        _hexaconImageView = [UIImageView imageViewWithImage:[[UIImage imageNamed:@"Hexacon"] tintedImageWithColor:[UIColor sam_colorWithHex:@"#655BB3"]]];
    }
    return _hexaconImageView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView imageViewWithImageNamed:nil];
        _iconImageView.frame = CGRectMake(0.f, 0.f, 32.f, 32.f);
        _iconImageView.center = self.hexaconImageView.center;
    }
    return _iconImageView;
}

#pragma mark - Designator Initialize

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

#pragma mark - Private Methods -

- (void)_initialize {
    [self addSubview:self.hexaconImageView];
    [self.hexaconImageView addSubview:self.iconImageView];
}

@end
