//
//  ADBadgeCell.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 08/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADBadgeCell.h"

@interface ADBadgeCell ()

- (void)_initialize;

@end

@implementation ADBadgeCell

#pragma mark - Getter Methods -

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView imageViewWithImageNamed:nil];
        _iconImageView.frame = self.bounds;
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
    [self addSubview:self.iconImageView];
}

@end
