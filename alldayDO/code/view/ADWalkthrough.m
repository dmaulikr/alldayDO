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
        
        [[GAI sharedInstance] sendScreen:@"WalkthroughScreen"
                            withCategory:@"Screen"];
    }
    return self;
}

#pragma mark - Private Methods

- (void)_initialize {
    [self.skipButton setTitle:NSLocalizedString(@"skip", nil) forState:UIControlStateNormal];
    UIFont *descFont = [UIFont fontWithName:@"Helvetica-Light" size:14.f];
    UIImage *bgImage = [UIImage imageNamed:@"bgWalkthrough"];
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = NSLocalizedString(@"page1Title", nil);
    page1.desc = NSLocalizedString(@"page1Desc", nil);
    page1.descFont = descFont;
    page1.bgImage = bgImage;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedString(@"shakeImage", nil)]];
    [imageView setW:288.f andH:311.f];
    page1.titleIconView = imageView;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = NSLocalizedString(@"page2Title", nil);
    page2.desc = NSLocalizedString(@"page2Desc", nil);
    page2.descFont = descFont;
    page2.bgImage = bgImage;
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedString(@"detailImage", nil)]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = NSLocalizedString(@"page3Title", nil);
    page3.desc = NSLocalizedString(@"page3Desc", nil);
    page3.descFont = descFont;
    page3.bgImage = bgImage;
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedString(@"badgesImage", nil)]];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = NSLocalizedString(@"page4Title", nil);
    page4.desc = NSLocalizedString(@"page4Desc", nil);
    page4.descFont = descFont;
    page4.bgImage = bgImage;
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedString(@"notificationImage", nil)]];
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.title = NSLocalizedString(@"page5Title", nil);
    page5.desc = NSLocalizedString(@"page5Desc", nil);
    page5.descFont = descFont;
    page5.bgImage = bgImage;
    page5.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedString(@"mainImage", nil)]];
    
//    CGFloat titleIconPositionY = 10.f;
//    CGFloat titleIconViewHeight = 20.f;
//    page1.titleIconPositionY = titleIconPositionY;
//    page2.titleIconPositionY = titleIconPositionY;
//    page3.titleIconPositionY = titleIconPositionY;
//    page4.titleIconPositionY = titleIconPositionY;
//    page5.titleIconPositionY = titleIconPositionY;
//    
//    [page1.titleIconView setW:(page1.titleIconView.width - titleIconViewHeight)
//                         andH:(page1.titleIconView.height - titleIconViewHeight)];
//    [page2.titleIconView setW:(page1.titleIconView.width - titleIconViewHeight)
//                         andH:(page1.titleIconView.height - titleIconViewHeight)];
//    [page3.titleIconView setW:(page1.titleIconView.width - titleIconViewHeight)
//                         andH:(page1.titleIconView.height - titleIconViewHeight)];
//    [page4.titleIconView setW:(page1.titleIconView.width - titleIconViewHeight)
//                         andH:(page1.titleIconView.height - titleIconViewHeight)];
//    [page5.titleIconView setW:(page1.titleIconView.width - titleIconViewHeight)
//                         andH:(page1.titleIconView.height - titleIconViewHeight)];

    self.pages = @[page1, page2, page3, page4, page5];
}

@end
