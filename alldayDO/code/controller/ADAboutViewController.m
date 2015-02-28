//
//  ADSettingsViewController.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 06/09/14.
//  Copyright (c) 2014 F√°bio Nogueira . All rights reserved.
//

#import "ADAboutViewController.h"
#import "ADWalkthrough.h"

#import <MessageUI/MessageUI.h>
#import <Social/Social.h>

@interface ADAboutViewController () <MFMailComposeViewControllerDelegate, EAIntroDelegate>

- (void)_IBOutletTitle;
- (void)_cornerRadiusButtons;

@end

@implementation ADAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_second_color_bg"]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self _IBOutletTitle];
    [self _cornerRadiusButtons];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GAI sharedInstance] sendScreen:@"DetailReminderScreen" withCategory:@"Screen"];
}

#pragma mark - Private Methods -

- (void)_IBOutletTitle {
    self.title = NSLocalizedString(@"settings", nil);

    [self.aboutButton setTitle:NSLocalizedString(@"about", nil) forState:UIControlStateNormal];
    [self.seedFeedbackButton setTitle:NSLocalizedString(@"feedback", nil) forState:UIControlStateNormal];
    [self.rateButton setTitle:NSLocalizedString(@"rate", nil) forState:UIControlStateNormal];
    [self.websiteButton setTitle:NSLocalizedString(@"website", nil) forState:UIControlStateNormal];
    [self.walkthroughButton setTitle:NSLocalizedString(@"walkthrough", nil) forState:UIControlStateNormal];
    self.shareLabel.text = NSLocalizedString(@"shared", nil);
}

- (void)_cornerRadiusButtons {
    CGFloat radius = 10;
    self.aboutButton.layer.cornerRadius = radius;
    self.seedFeedbackButton.layer.cornerRadius = radius;
    self.rateButton.layer.cornerRadius = radius;
    self.websiteButton.layer.cornerRadius = radius;
    self.walkthroughButton.layer.cornerRadius = radius;
    self.shareLabel.layer.cornerRadius = radius;
}

#pragma mark - IBOutlet Methods -

- (IBAction)feedbackTouched:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        [mailViewController setSubject:@"Feedback alldayDO"];
        [mailViewController setToRecipients:@[@"alldaydo.info@gmail.com"]];
        [mailViewController setMessageBody:nil
                                    isHTML:NO];
        mailViewController.mailComposeDelegate = self;
        mailViewController.navigationBar.tintColor = [UIColor whiteColor];
        
        [self presentViewController:mailViewController
                           animated:YES
                         completion:^{
                             [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                         }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"errorConfigEmail", nil)
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)rateTouched:(id)sender {
    [[GAI sharedInstance] sendAction:@"rateAppActivity" withCategory:@"Action"];
    NSString *appID = @"916494166";
    NSString *urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (IBAction)websiteTouched:(id)sender {
    [[GAI sharedInstance] sendAction:@"websiteActivity" withCategory:@"Action"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.alldayDO.com"]];
}

- (IBAction)facebookTouched:(id)sender {
    [[GAI sharedInstance] sendAction:@"FacebookActivity" withCategory:@"Action"];
    SLComposeViewController *facebookComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [facebookComposeViewController setInitialText:NSLocalizedString(@"facebookMessageDefault", nil)];
    [self presentViewController:facebookComposeViewController animated:YES completion:nil];
}

- (IBAction)walkthroughTouched:(id)sender {
        [[GAI sharedInstance] sendAction:@"WalktroughActivity" withCategory:@"Action"];
    ADWalkthrough *walkthroughView = [[ADWalkthrough alloc] initWithFrame:self.navigationController.view.frame];
    walkthroughView.delegate = self;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    [walkthroughView showInView:self.navigationController.view animateDuration:0.4f];
}

- (IBAction)twitterTouched:(id)sender {
    [[GAI sharedInstance] sendAction:@"TwitterActivity" withCategory:@"Action"];
    SLComposeViewController *twitterComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [twitterComposeViewController setInitialText:NSLocalizedString(@"twitterMessageDefault", nil)];
    [self presentViewController:twitterComposeViewController animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    [[GAI sharedInstance] sendAction:@"EmailSentActivity" withCategory:@"Action"];
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

#pragma mark - EAIntroDelegate Methods

- (void)introDidFinish:(EAIntroView *)introView {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

@end
