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
    UIFont *descFont = [UIFont fontWithName:@"Helvetica-Light" size:14.f];
    UIImage *bgImage = [UIImage imageNamed:@"bgWalkthrough"];
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Rápido e prático";
    page1.desc = @"Poucos cliques e atividades salvas. \n AH! E você também pode preparar uma nova atividade dando um Shake!";
    page1.descFont = descFont;
    page1.bgImage = bgImage;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shake-pt"]];
    [imageView setW:288.f andH:311.f];
    page1.titleIconView = imageView;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"Acompanhe sua produtividade";
    page2.desc = @"Nossos gráficos te ajudam a acompanhar seu desempenho";
    page2.descFont = descFont;
    page2.bgImage = bgImage;
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"Não perca nenhuma informação";
    page3.desc = @"Confira todas suas atividades, as que você não fez e as já completadas";
    page3.descFont = descFont;
    page3.bgImage = bgImage;
    page3.titleIconPositionY = 0.f;
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"walkthrough"]];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"E claro, divertido";
    page4.desc = @"Chega de notificação simples. Queremos que você lembre de forma divertida";
    page4.descFont = descFont;
    page4.bgImage = bgImage;
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.title = @"Agora é com você!";
    page5.desc = @"Adicione uma atividade e veja a mágica acontecer!";
    page5.descFont = descFont;
    page5.bgImage = bgImage;
    page5.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title5"]];

    self.pages = @[page1, page2, page3, page4, page5];
}

@end
