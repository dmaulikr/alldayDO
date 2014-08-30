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

@property (nonatomic) BOOL initialized;

- (void)_initialize;

@end

@implementation ADReminderCell

#pragma mark - Getter Methods -

- (ADBadgeImageView *)badgeImageView {
    if (!_badgeImageView) {
        _badgeImageView = [[ADBadgeImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 50.f, 50.f)];
        _badgeImageView.image = [[UIImage imageNamed:@"Hexacon"] tintedImageWithColor:[UIColor sam_colorWithHex:@"#3B89C6"]];
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
    [self.badgeImageView.badgeIconImageView setW:22.f andH:22.f];
    [self.badgeImageView.badgeIconImageView centerWith:self.badgeImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.initialized) {
        self.barChart.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [self.barChart setX:9.f andY:3.f];
        
        [self.badgeImageView setX:(self.borderTimelineContentView.x - self.badgeImageView.width) / 2.f];
        [self.badgeImageView centerYWith:self];
        [self.lineTopView centerXWith:self.badgeImageView];
        [self.lineBottomView centerXWith:self.badgeImageView];
        
        self.initialized = YES;
    }
}

#pragma mark - Public Methods - 

- (void)initBarChartAlreadyCreated {
    self.initialized = NO;
    [self.barChart removeFromSuperview];
    
    CGRect frame = CGRectMake(0, 0, self.barChartContentView.frame.size.height, self.barChartContentView.frame.size.width);
    self.barChart = [[PNBarChart alloc] initWithFrame:frame];
    
    self.barChart.chartMargin = 0.f;
    self.barChart.labelMarginTop = 0.f;
    
    self.barChart.yMaxValue = 7;
    self.barChart.yChartLabelWidth = 0.f;
    
    self.barChart.barRadius = 3.f;
    
    self.barChart.showLabel = NO;
    self.barChart.showChartBorder = NO;
    self.barChart.backgroundColor = [UIColor clearColor];
    
    [self.barChartContentView addSubview:self.barChart];
}

@end
