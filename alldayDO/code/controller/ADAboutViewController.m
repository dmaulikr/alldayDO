//
//  ADAboutViewController.m
//  alldayDO
//
//  Created by Fábio Almeida on 9/9/14.
//  Copyright (c) 2014 F√°bio Nogueira . All rights reserved.
//

#import "ADAboutViewController.h"

@interface ADAboutViewController ()

@end

@implementation ADAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[GAI sharedInstance] sendScreen:@"aboutScreen" withCategory:@"Screen"];
    self.title = NSLocalizedString(@"about", nil);
    self.descriptionLabel.text = NSLocalizedString(@"aboutDescription", nil);
    
    CGFloat radius = 10.f;
    self.fabioButton.layer.cornerRadius = radius;
    self.arthurButton.layer.cornerRadius = radius;
}

- (IBAction)fabioTwitterTouched:(id)sender {
    [[GAI sharedInstance] sendAction:@"fabioTwitterActivity" withCategory:@"Action"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/fabintk"]];
}

- (IBAction)arthurTwitterTouched:(id)sender {
    [[GAI sharedInstance] sendAction:@"arthurTwitterActivity" withCategory:@"Action"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/arthurklose"]];    
}

@end
