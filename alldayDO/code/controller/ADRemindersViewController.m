//
//  ADRemindersCollectionViewController.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 05/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADRemindersViewController.h"

#import "ADModel.h"
#import "ADReminderCell.h"

#import "ADEditReminderViewController.h"
#import "ADEditReminderViewControllerDelegate.h"

#import "ADDetailReminderViewController.h"

#import "ADAboutViewController.h"

#import "PNChart.h"

#import <NGAParallaxMotion.h>
#import <INSPullToRefresh/INSPullToRefreshBackgroundView.h>
#import <INSPullToRefresh/INSDefaultPullToRefresh.h>

#import "INSLabelPullToRefresh.h"

#define DETAIL_REMINDER_NAME_SEGUE @"detailReminderSegue"

@interface ADRemindersViewController () <UIViewControllerTransitioningDelegate, ADEditReminderViewControllerDelegate, UIAlertViewDelegate, INSPullToRefreshBackgroundViewDelegate, UITabBarDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) ADRemindersViewModel *viewModel;

@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UIView *blurView;
@property (nonatomic, strong) UITextView *emptyMessage;

- (void)_applicationDidReceiveLocalNotificationOnActive:(NSNotification *)notification;
- (void)_applicationDidReceiveLocalNotificationOnBackground:(NSNotification *)notification;

- (void)_addSubView;
- (void)_addNotificationCenter;
- (void)_addParallaxEffect;
- (void)_addRefreshControl;
- (void)_addTitleButton;
- (void)_addScopeTitlesToSearchBar;

- (void)_adjustHexaconSelect:(id)sender;

- (UIColor *)_colorForNumberOfSeguidos:(NSNumber *)seguidos;
- (void)_initStyle;
- (void)_presentNewReminderViewController;
- (void)_presentAboutViewController;
- (void)_reloadData;
- (void)_selectRowAtIndexPathForLembreteDescricao:(NSString *)descricao;
- (void)_searchBarLostFocus;
- (void)_showBlurViewWithAnimation;
- (void)_hideSearchBar;

- (void)_fetchRequestForAll;
- (void)_fetchRequestForDoneReminders;
- (void)_fetchRequestForUndoneReminders;

@end

@implementation ADRemindersViewController

#pragma mark - Getter Methods -

- (ADRemindersViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ADRemindersViewModel alloc] init];
    }
    return _viewModel;
}

- (UIAlertView *)alertView {
    if (!_alertView) {
        _alertView = [UIAlertView alertViewWithTitle:@""
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

#pragma mark - UIView Lifecycle Methods -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initStyle];
    [self _addSubView];
    [self _addNotificationCenter];
    [self _addParallaxEffect];
    [self _addRefreshControl];
    [self _addTitleButton];
    
    self.searchBar.delegate = self;
    self.tabBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GAI sharedInstance] sendScreen:@"RemindersScreen" withCategory:@"Screen"];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.tabBar setSelectedItem:nil];

    [self _addScopeTitlesToSearchBar];
    [self _hideSearchBar];
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

- (void)_addParallaxEffect {
    CGFloat parallaxIntensity = 4.f;
    self.hexaconAllButton.parallaxIntensity = parallaxIntensity;
    self.totalRemindersLabel.parallaxIntensity = parallaxIntensity;
    self.hexaconDoneButton.parallaxIntensity = parallaxIntensity;
    self.doneReminders.parallaxIntensity = parallaxIntensity;
    self.hexaconUndoneButton.parallaxIntensity = parallaxIntensity;
    self.undoneReminders.parallaxIntensity = parallaxIntensity;
}

- (void)_addRefreshControl {
    [self.tableView ins_addPullToRefreshWithHeight:60.0 handler:^(UIScrollView *scrollView) {
        int64_t delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self _reloadData];
            [scrollView ins_endPullToRefresh];
            
        });
    }];
    
    CGRect defaultFrame = CGRectMake(0, 0, self.tableView.width, 60.0);
    UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [[INSLabelPullToRefresh alloc] initWithFrame:defaultFrame
                                                                                                    noneStateText:NSLocalizedString(@"pullToRefresh", nil)
                                                                                               triggeredStateText:NSLocalizedString(@"releaseToRefresh", nil)
                                                                                                 loadingStateText:NSLocalizedString(@"loading", nil)];
    self.tableView.ins_pullToRefreshBackgroundView.dragToTriggerOffset = 60.0;
    self.tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
    [self.tableView.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
}

- (void)_addTitleButton {
    self.addButton.title = NSLocalizedString(@"addButton", nil);
    self.settingsButton.title = NSLocalizedString(@"settingsButton", nil);
    self.aboutButton.title = NSLocalizedString(@"aboutButton", nil);
}

- (void)_addScopeTitlesToSearchBar {
    self.searchBar.scopeButtonTitles = self.viewModel.searchBarScopesTitles;
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
    [self _searchBarLostFocus];
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

- (void)_presentAboutViewController {
    ADAboutViewController *aboutViewController = (ADAboutViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"aboutViewController"];
    [self.navigationController pushViewController:aboutViewController animated:YES];
}

- (void)_reloadData {
    [self _adjustHexaconSelect:self.hexaconAllButton];
    self.searchBar.selectedScopeButtonIndex = 0;
    [self.viewModel executeFetchRequestForAll];
    [self.tableView reloadData];
}

- (void)_selectRowAtIndexPathForLembreteDescricao:(NSString *)descricao {
    NSIndexPath *indePath = [self.viewModel indexPathForLembreteWithDescricao:descricao];
    [self.tableView selectRowAtIndexPath:indePath
                                animated:NO
                          scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)_searchBarLostFocus {
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

- (void)_showBlurViewWithAnimation {
    [[GAI sharedInstance] sendAction:@"addActivity" withCategory:@"Action"];
    
    self.blurView.alpha = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        self.blurView.alpha = 1.0f;
    }];
}

- (void)_hideSearchBar {
    [self.tableView setContentOffset:CGPointMake(0, 44) animated:YES];
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
    self.doneReminders.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.viewModel.doneReminders.count];
    self.undoneReminders.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.viewModel.undoneReminders.count];
    if (numberOfReminders > 0) {
        self.emptyMessage.hidden = YES;
    } else {
        self.emptyMessage.hidden = NO;
    }
    return numberOfReminders;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.lineTopView.hidden = YES;
        
    } else {
        cell.lineBottomView.hidden = NO;
    }
    if ([tableView numberOfRowsInSection:indexPath.section] - 1 == indexPath.row) {
        cell.lineBottomView.hidden = YES;
        
    } else {
        cell.lineBottomView.hidden = NO;
    }
    
    [self.viewModel fetchObjectAtIndexPath:indexPath];
    if (self.viewModel.hasNoReminderAlert) {
        cell.nextReminderLabel.text = NSLocalizedString(@"noReminderAlert", nil);
    } else {
        cell.nextReminderLabel.text = [NSString stringWithFormat:@"%@", [self.viewModel nextReminderFormated]];
    }
    
    cell.nomeLabel.text = self.viewModel.descricao;
    
    cell.badgeImageView.badgeIconImageView.image = self.viewModel.imagem;
    
    [cell initBarChartAlreadyCreated];
    cell.barChart.strokeColor = [self _colorForNumberOfSeguidos:self.viewModel.seguidos];
    cell.barChart.yValues = @[self.viewModel.seguidos];
    [cell.barChart strokeChart];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[GAI sharedInstance] sendAction:@"DeleteInHomeActivity" withCategory:@"Action"];
    
    [self.tableView beginUpdates];
    [self.viewModel deleteRow:indexPath];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.viewModel executeFetchRequestForAll];
    [self.tableView endUpdates];
}

#pragma mark - IBOutlet Methods -

- (IBAction)hexaconAllTouched:(id)sender {
    [[GAI sharedInstance] sendAction:@"CheckAllActivity" withCategory:@"Action"];

    self.searchBar.selectedScopeButtonIndex = 0;
    [self _adjustHexaconSelect:sender];
    [self _fetchRequestForAll];
}

- (IBAction)hexaconDoneTouched:(id)sender {
    [[GAI sharedInstance] sendAction:@"CheckCompleteActivity" withCategory:@"Action"];
    
    [self _adjustHexaconSelect:sender];
    [self _fetchRequestForDoneReminders];
}

- (IBAction)hexaconUndoneTouched:(id)sender {
    [[GAI sharedInstance] sendAction:@"CheckNoCompleteActivity" withCategory:@"Action"];

    [self _adjustHexaconSelect:sender];
    [self _fetchRequestForUndoneReminders];
}

#pragma mark - ADEditReminderViewControllerDelegate Methods -

- (void)newReminderViewController:(ADEditReminderViewController *)newReminderViewController
                  didSaveReminder:(ADLembrete *)reminder {
    [newReminderViewController dismissViewControllerAnimated:YES completion:^{
        [self.viewModel executeFetchRequestForAll];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tabBar setSelectedItem:nil];
    }];
}

- (void)newReminderViewControllerDidCancelReminder:(ADEditReminderViewController *)newReminderViewController {
    [self.tabBar setSelectedItem:nil];
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

#pragma mark - UITabBarDelegate Methods -

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item == self.addButton) {
        [self _presentNewReminderViewController];
    } else if (item == self.aboutButton) {
        [self _presentAboutViewController];
    }
}

#pragma mark - UISearchBarDelegate Methods -

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.viewModel searchBarWithText:searchText];
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self _searchBarLostFocus];
    
    if (selectedScope == 0) {
        [self _reloadData];
    } else {
        if (selectedScope == 1) {
            [self.viewModel executeFetchRequestForAllWithCategoria:self.viewModel.categorias.firstObject];
        } else if (selectedScope == 2) {
            [self.viewModel executeFetchRequestForAllWithCategoria:[self.viewModel.categorias objectAtIndex:1]];
        } else if (selectedScope == 3) {
            [self.viewModel executeFetchRequestForAllWithCategoria:self.viewModel.categorias.lastObject];
        }
        [self.tableView reloadData];
    }
}

#pragma mark - UIStoryboard Methods -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:DETAIL_REMINDER_NAME_SEGUE]) {
        [[GAI sharedInstance] sendAction:@"DetailActivity" withCategory:@"Screen"];
        
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
        ADDetailReminderViewController *detailViewController = (ADDetailReminderViewController *)[segue destinationViewController];
        [detailViewController.viewModel setLembreteDetail:[self.viewModel modelAtIndexPath:indexPath]];
    }
}

#pragma mark - UIResponder Methods -

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (UIEventSubtypeMotionShake) {
        [[GAI sharedInstance] sendAction:@"ShakeActivity" withCategory:@"Action"];
        [self _presentNewReminderViewController];
    }
}

#pragma mark - UIScrollViewDelegate Methods -

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

@end