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

- (ADBadgeImageView *)badgeImageView {
    if (!_badgeImageView) {
        _badgeImageView = [[ADBadgeImageView alloc] initWithFrame:self.frame];
        _badgeImageView.image = [[UIImage imageNamed:@"Hexacon"] tintedImageWithColor:[UIColor sam_colorWithHex:@"#655BB3"]];
    }
    return _badgeImageView;
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
    [self addSubview:self.badgeImageView];
}

@end
