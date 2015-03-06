//
//  ADSettingsTableViewController.m
//  alldayDO
//
//  Created by Fábio Nogueira de Almeida on 05/03/15.
//  Copyright (c) 2015 Fábio Nogueira . All rights reserved.
//

#import "ADSettingsTableViewController.h"

@interface ADSettingsTableViewController ()

@end

@implementation ADSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_second_color_bg"]
                                                  forBarMetrics:UIBarMetricsDefault];

    #warning TODO - colocar tradução
    self.title = @"Settings";
}

@end
