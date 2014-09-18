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
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"aboutScreen"];
    [tracker set:kGAIEventCategory value:@"Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    self.title = NSLocalizedString(@"about", nil);
    self.descriptionLabel.text = NSLocalizedString(@"aboutDescription", nil);
}

- (IBAction)fabioTwitterTouched:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventAction value:@"fabioTwitterActivity"];
    [tracker set:kGAIEventCategory value:@"Action"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/fabintk"]];
}

- (IBAction)arthurTwitterTouched:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventAction value:@"arthurTwitterActivity"];
    [tracker set:kGAIEventCategory value:@"Action"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/arthurklose"]];    
}

@end
