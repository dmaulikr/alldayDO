//
//  ADRemindersCollectionViewController.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 05/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADRemindersTableViewController.h"

#import "ADLembrete.h"
#import "ADModel.h"
#import "ADReminderCell.h"

#import "ADEditReminderViewController.h"
#import "ADEditReminderViewControllerDelegate.h"

#import "ADDetailReminderViewController.h"

#import "PresentingAnimator.h"
#import "DismissingAnimator.h"

#import "PNChart.h"

#define DETAIL_REMINDER_NAME_SEGUE @"detailReminderSegue"

@interface ADRemindersTableViewController () <UIViewControllerTransitioningDelegate, ADEditReminderViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) ADRemindersViewModel *viewModel;

@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UIView *blurView;
@property (nonatomic, strong) UITextView *emptyMessage;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (void)_applicationDidReceiveLocalNotificationOnActive:(NSNotification *)notification;
- (void)_applicationDidReceiveLocalNotificationOnBackground:(NSNotification *)notification;

- (void)_addSubView;
- (void)_addNotificationCenter;

- (void)_adjustHexaconSelect:(id)sender;

- (UIColor *)_colorForNumberOfSeguidos:(NSNumber *)seguidos;
- (void)_initStyle;
- (void)_presentNewReminderViewController;
- (void)_refreshTableView;
- (void)_reloadData;
- (void)_selectRowAtIndexPathForLembreteDescricao:(NSString *)descricao;
- (void)_showBlurViewWithAnimation;

- (void)_fetchRequestForAll;
- (void)_fetchRequestForDoneReminders;
- (void)_fetchRequestForUndoneReminders;

@end

@implementation ADRemindersTableViewController

#pragma mark - Getter Methods -

- (ADRemindersViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ADRemindersViewModel alloc] init];
    }
    return _viewModel;
}

- (UIAlertView *)alertView {
    if (!_alertView) {
        _alertView = [UIAlertView alertViewWithTitle:nil
                                             message:nil
                                            delegate:self
                                   cancelButtonTitle:NSLocalizedString(@"Não", nil)
                                   otherButtonTitles:NSLocalizedString(@"Sim", nil), nil];
    }
    return _alertView;
}

- (UIView *)blurView {
    if (!_blurView) {
        _blurView = [UIView viewWithFrame:self.view.frame];
        _blurView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.300];
    }
    
    return _blurView;
}

- (UITextView *)emptyMessage {
    if (!_emptyMessage) {
        _emptyMessage = [[UITextView alloc] initWithFrame:self.tableView.frame];
        _emptyMessage.center = self.tableView.center;
        _emptyMessage.backgroundColor = [UIColor clearColor];
        _emptyMessage.editable = NO;

        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Suas atividades ficam aqui \nSeus lembretes aparecem aqui e são fáceis de editar", nil)];
        
        [text setAttributes:@{NSFontAttributeName: [UIFont fontWithName:nil size:24.f],
                             NSFontAttributeName: [UIColor darkGrayColor]}
                      range:NSMakeRange(0, 28)];
        
        _emptyMessage.attributedText = text;
        _emptyMessage.textColor = [UIColor sam_colorWithHex:@"#79868F"];
        _emptyMessage.textAlignment = NSTextAlignmentCenter;
        [self.tableView addSubview:_emptyMessage];
    }
    return _emptyMessage;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(_refreshTableView) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

#pragma mark - UIView Lifecycle Methods -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initStyle];
    [self _addSubView];
    [self _addNotificationCenter];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"RemindersScreen"];
    [tracker set:kGAIEventCategory value:@"Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self _reloadData];
}

#pragma mark - Private Methods -

- (void)_applicationDidReceiveLocalNotificationOnActive:(NSNotification *)notification {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    UILocalNotification *localNotification = notification.object;
    
    NSString *descricaoLembrete = [localNotification.userInfo objectForKey:LOCAL_NOTIFICATION_DOMAIN];
    [self _selectRowAtIndexPathForLembreteDescricao:descricaoLembrete];
    
    self.alertView.message = localNotification.alertBody;
    if (!self.alertView.isVisible) {
        [self.alertView show];
    }
}

- (void)_applicationDidReceiveLocalNotificationOnBackground:(NSNotification *)notification {
    UILocalNotification *localNotification = notification.object;
    
    NSString *descricaoLembrete = [localNotification.userInfo objectForKey:LOCAL_NOTIFICATION_DOMAIN];
    [self _selectRowAtIndexPathForLembreteDescricao:descricaoLembrete];
    
    [self performSegueWithIdentifier:DETAIL_REMINDER_NAME_SEGUE sender:self];
}

- (void)_addSubView {
    [self.view addSubview:self.blurView];
    [self.view sendSubviewToBack:self.blurView];
    [self.tableView addSubview:self.refreshControl];
}

- (void)_addNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_applicationDidReceiveLocalNotificationOnActive:)
                                                 name:APPLICATION_DID_RECEIVE_LOCAL_NOTIFICATION_ACTIVE
                                               object:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_applicationDidReceiveLocalNotificationOnBackground:)
                                                 name:APPLICATION_DID_RECEIVE_LOCAL_NOTIFICATION_BACKGROUND
                                               object:NULL];
}

- (void)_adjustHexaconSelect:(id)sender {
    BOOL selected = NO;
    self.hexaconAllButton.selected = selected;
    self.hexaconDoneButton.selected = selected;
    self.hexaconUndoneButton.selected = selected;
    
    if (sender == self.hexaconAllButton) {
        self.hexaconAllButton.selected = !selected;;
    } else if (sender == self.hexaconDoneButton) {
        self.hexaconDoneButton.selected = !selected;
    } else {
        self.hexaconUndoneButton.selected = !selected;
    }
}

- (UIColor *)_colorForNumberOfSeguidos:(NSNumber *)seguidos {
    UIColor *barColor = nil;
    switch ([seguidos intValue]) {
        case 1:
            barColor = PNRed;
            break;
        case 2:
            barColor = PNLightBlue;
            break;
        case 3:
            barColor = PNBlue;
            break;
        case 4:
            barColor = PNYellow;
            break;
        case 5:
            barColor = PNFreshGreen;
            break;
        case 6:
            barColor = PNFreshGreen;
            break;
        case 7:
            barColor = PNGreen;
            break;
        default:
            barColor = PNFreshGreen;
            break;
    }
    
    return barColor;
}

- (void)_initStyle {
    [self.tableView setBackgroundColor:[UIColor sam_colorWithHex:@"#EFF2F5"]];
}

- (void)_presentNewReminderViewController {
    ADEditReminderViewController *newReminderViewController = [ADEditReminderViewController viewController];
    newReminderViewController.delegate = self;
    newReminderViewController.transitioningDelegate = self;
    newReminderViewController.modalPresentationStyle = UIModalPresentationCustom;
    newReminderViewController.actionMode = ADAddMode;
    
    [self presentViewController:newReminderViewController animated:YES completion:^{
        [self _showBlurViewWithAnimation];
    }];
}

- (void)_refreshTableView {
    [self.refreshControl beginRefreshing];
    [self _reloadData];
    [self.refreshControl endRefreshing];
}

- (void)_reloadData {
    [self _adjustHexaconSelect:self.hexaconAllButton];
    [self.viewModel executeFetchRequestForAll];
    [self.tableView reloadData];
}

- (void)_selectRowAtIndexPathForLembreteDescricao:(NSString *)descricao {
    NSIndexPath *indePath = [self.viewModel indexPathForLembreteWithDescricao:descricao];
    [self.tableView selectRowAtIndexPath:indePath
                                animated:NO
                          scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)_showBlurViewWithAnimation {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventAction value:@"addActivity"];
    [tracker set:kGAIEventCategory value:@"Action"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    self.blurView.alpha = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        self.blurView.alpha = 1.0f;
    }];
}

- (void)_fetchRequestForAll {
    [self.viewModel executeFetchRequestForAll];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)_fetchRequestForDoneReminders {
    [self.viewModel executeFetchRequestForDoneReminders];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)_fetchRequestForUndoneReminders {
    [self.viewModel executeFetchRequestForUndoneReminders];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
}

#pragma mark - UITableViewDataSource Methods -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfReminders = [self.viewModel numberOfItemsInSection:section];
    self.totalRemindersLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.viewModel.allReminders.count];
    self.doneRemindersLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.viewModel.doneReminders.count];
    self.undoneRemindersLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.viewModel.undoneReminders.count];
    
    if (numberOfReminders > 0) {
        self.emptyMessage.hidden = YES;
    } else {
        self.emptyMessage.hidden = NO;
    }
    
    return numberOfReminders;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderCell" forIndexPath:indexPath];
 
    [cell.badgeImageView centerYWith:cell.timelineContentView];
    cell.borderTimelineContentView.layer.cornerRadius = 5.f;
    cell.timelineContentView.layer.cornerRadius = 5.f;
    
    if ([tableView numberOfRowsInSection:indexPath.section] - 1 == indexPath.row) {
        cell.lineBottomView.hidden = YES;
    } else {
        cell.lineBottomView.hidden = NO;
    }
    
    [self.viewModel fetchObjectAtIndexPath:indexPath];
    
    cell.nomeLabel.text = self.viewModel.descricao;
    cell.nextReminderLabel.text = [NSString stringWithFormat:@"%@", [self.viewModel nextReminderFormated]];
    cell.badgeImageView.badgeIconImageView.image = self.viewModel.imagem;
    
    [cell initBarChartAlreadyCreated];
    cell.barChart.strokeColor = [self _colorForNumberOfSeguidos:self.viewModel.seguidos];
    cell.barChart.yValues = @[self.viewModel.seguidos];
    [cell.barChart strokeChart];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventAction value:@"DeleteInHomeActivity"];
    [tracker set:kGAIEventCategory value:@"Action"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [self.tableView beginUpdates];
    [self.viewModel deleteRow:indexPath];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.viewModel executeFetchRequestForAll];
    [self.tableView endUpdates];
}

#pragma mark - IBOutlet Methods -

- (IBAction)newReminderTouched:(id)sender {
    [self _presentNewReminderViewController];
}

- (IBAction)hexaconAllTouched:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventAction value:@"CheckAllActivity"];
    [tracker set:kGAIEventCategory value:@"Action"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [self _adjustHexaconSelect:sender];
    [self _fetchRequestForAll];
}

- (IBAction)hexaconDoneTouched:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventAction value:@"CheckCompleteActivity"];
    [tracker set:kGAIEventCategory value:@"Action"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [self _adjustHexaconSelect:sender];
    [self _fetchRequestForDoneReminders];
}

- (IBAction)hexaconUndoneTouched:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventAction value:@"CheckNoCompleteActivity"];
    [tracker set:kGAIEventCategory value:@"Action"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [self _adjustHexaconSelect:sender];
    [self _fetchRequestForUndoneReminders];
}

#pragma mark - UIViewControllerTransitioningDelegate Methods -

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [PresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    [self.view sendSubviewToBack:self.blurView];
    return [DismissingAnimator new];
}

#pragma mark - ADEditReminderViewControllerDelegate Methods -

- (void)newReminderViewController:(ADEditReminderViewController *)newReminderViewController
                  didSaveReminder:(ADLembrete *)reminder {
    [newReminderViewController dismissViewControllerAnimated:YES completion:^{
        [self.viewModel executeFetchRequestForAll];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
    }];
}

- (void)newReminderViewControllerDidCancelReminder:(ADEditReminderViewController *)newReminderViewController {
}

#pragma mark - UIAlertViewDelegate Methods -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            [self performSegueWithIdentifier:DETAIL_REMINDER_NAME_SEGUE sender:self];
            break;
        default:
            break;
    }
}

#pragma mark - UIStoryboard Methods -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:DETAIL_REMINDER_NAME_SEGUE]) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIEventAction value:@"DetailActivity"];
        [tracker set:kGAIEventCategory value:@"Screen"];
        [tracker send:[[GAIDictionaryBuilder createAppView] build]];
        
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
        ADDetailReminderViewController *detailViewController = (ADDetailReminderViewController *)[segue destinationViewController];
        [detailViewController.viewModel lembreteDetail:[self.viewModel lembreteAtIndexPath:indexPath]];
    }
}

@end