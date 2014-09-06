//
//  ADSettingsViewController.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 06/09/14.
//  Copyright (c) 2014 F√°bio Nogueira . All rights reserved.
//

#import "ADSettingsViewController.h"

@interface ADSettingsViewController ()

- (void)_IBOutletTitle;

@end

@implementation ADSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_second_color_bg"]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self _IBOutletTitle];
}

#pragma mark - Private Methods -

- (void)_IBOutletTitle {
    self.title = NSLocalizedString(@"settings", nil);

    [self.aboutButton setTitle:NSLocalizedString(@"about", nil) forState:UIControlStateNormal];
    [self.seedFeedbackButton setTitle:NSLocalizedString(@"feedback", nil) forState:UIControlStateNormal];
    [self.rateButton setTitle:NSLocalizedString(@"rate", nil) forState:UIControlStateNormal];
    [self.websiteButton setTitle:NSLocalizedString(@"website", nil) forState:UIControlStateNormal];
    
    self.shareLabel.text = NSLocalizedString(@"shared", nil);
}

#pragma mark - IBOutlet Methods -

- (IBAction)twitterTouched:(id)sender {
}

- (IBAction)facebookTouched:(id)sender {
}

@end
