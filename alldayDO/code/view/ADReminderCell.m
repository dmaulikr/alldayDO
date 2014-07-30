//
//  ADReminderCell.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 07/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADReminderCell.h"
#import <QuartzCore/QuartzCore.h>

@interface ADReminderCell ()

- (void)_initialize;

@end

@implementation ADReminderCell

#pragma mark - Getter Methods -

- (ADBadgeImageView *)badgeImageView {
    if (!_badgeImageView) {
        _badgeImageView = [[ADBadgeImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 60.f, 60.f)];
        _badgeImageView.image = [[UIImage imageNamed:@"Hexacon"] tintedImageWithColor:[UIColor sam_colorWithHex:@"#5E82B6"]];
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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initialize];
    }
    return self;
}

#pragma mark - Private Methods -

- (void)_initialize {
    [self addSubview:self.badgeImageView];
        
    [self.badgeImageView setX:20.f andY:16.f];
    [self.badgeImageView.badgeIconImageView setW:22.f andH:22.f];
    [self.badgeImageView.badgeIconImageView centerWith:self.badgeImageView];
}

@end
