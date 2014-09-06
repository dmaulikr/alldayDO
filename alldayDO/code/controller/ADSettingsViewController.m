//
//  ADSettingsViewController.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 06/09/14.
//  Copyright (c) 2014 F√°bio Nogueira . All rights reserved.
//

#import "ADSettingsViewController.h"

#import <MessageUI/MessageUI.h>
#import <Social/Social.h>

@interface ADSettingsViewController () <MFMailComposeViewControllerDelegate>

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"DetailReminderScreen"];
    [tracker set:kGAIEventCategory value:@"Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
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

- (IBAction)feedbackTouched:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        NSString *body = NSLocalizedString(@"bodyFeedbackEmail", nil);
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        [mailViewController setSubject:@"Feedback alldayDO"];
        [mailViewController setToRecipients:@[@"fna.contact@gmail.com"]];
        [mailViewController setMessageBody:body
                                    isHTML:NO];
        mailViewController.mailComposeDelegate = self;
        mailViewController.navigationBar.tintColor = [UIColor whiteColor];
        
        [self presentViewController:mailViewController
                           animated:YES
                         completion:^{
                             [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                         }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"errorConfigEmail", nil)
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)rateTouched:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventAction value:@"rateAppActivity"];
    [tracker set:kGAIEventCategory value:@"Action"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    NSString *appID = @"916494166";
    NSString *urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (IBAction)websiteTouched:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventAction value:@"websiteActivity"];
    [tracker set:kGAIEventCategory value:@"Action"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.alldayDO.com"]];
}

- (IBAction)facebookTouched:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventAction value:@"FacebookActivity"];
    [tracker set:kGAIEventCategory value:@"Action"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    SLComposeViewController *facebookComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [facebookComposeViewController setInitialText:NSLocalizedString(@"facebookMessageDefault", nil)];
    [self presentViewController:facebookComposeViewController animated:YES completion:nil];
}

- (IBAction)twitterTouched:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventAction value:@"TwitterActivity"];
    [tracker set:kGAIEventCategory value:@"Action"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    SLComposeViewController *twitterComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [twitterComposeViewController setInitialText:NSLocalizedString(@"twitterMessageDefault", nil)];
    [self presentViewController:twitterComposeViewController animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventAction value:@"EmailSentActivity"];
    [tracker set:kGAIEventCategory value:@"Action"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    switch (result) {
        case MFMailComposeResultFailed:
            [[[UIAlertView alloc] initWithTitle:@"Email não enviado"
                                        message:@"Verifique sua conexão com a internet e tente novamente."
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil] show];
            break;
        case MFMailComposeResultSent:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
