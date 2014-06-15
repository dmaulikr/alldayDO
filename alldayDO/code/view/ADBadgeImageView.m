//
//  ADBadgeImageView.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 14/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADBadgeImageView.h"

@implementation ADBadgeImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"newHexacon"];
        self.badgeIconImageView.center = self.center;
        [self addSubview:self.badgeIconImageView];
    }
    return self;
}

#pragma mark - Getter Methods -

- (UIImageView *)badgeIconImageView {
    if (!_badgeIconImageView) {
        _badgeIconImageView = [[UIImageView alloc] init];
        _badgeIconImageView.frame = CGRectMake(0.f, 0.f, 32.f, 32.f);
    }
    return _badgeIconImageView;
}

@end
