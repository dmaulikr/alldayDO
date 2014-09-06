//
//  ADSettingsViewController.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 06/09/14.
//  Copyright (c) 2014 F√°bio Nogueira . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *seedFeedbackButton;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;

- (IBAction)feedbackTouched:(id)sender;
- (IBAction)rateTouched:(id)sender;
- (IBAction)websiteTouched:(id)sender;
- (IBAction)twitterTouched:(id)sender;
- (IBAction)facebookTouched:(id)sender;

@end
