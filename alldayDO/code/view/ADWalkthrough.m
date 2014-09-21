//
//  ADWalkthrough.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 21/09/14.
//  Copyright (c) 2014 F√°bio Nogueira . All rights reserved.
//

#import "ADWalkthrough.h"

@interface ADWalkthrough ()

- (void)_initialize;

@end

@implementation ADWalkthrough

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

#pragma mark - Private Methods

- (void)_initialize {
    [self.skipButton setTitle:NSLocalizedString(@"skip", nil) forState:UIControlStateNormal];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"bgWalkthrough"];
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"texto";
    page1.bgImage = backgroundImage;
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alldayDO-icon"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = @"texto";
    page2.bgImage = backgroundImage;
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = @"texto";
    page3.bgImage = backgroundImage;
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.desc = @"texto";
    page4.bgImage = backgroundImage;
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];    

    self.pages = @[page1, page2, page3, page4];
}

@end
