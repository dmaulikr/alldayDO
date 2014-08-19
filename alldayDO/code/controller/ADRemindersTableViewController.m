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

#import "ADNewReminderViewController.h"
#import "ADNewReminderViewControllerDelegate.h"

#import "ADDetailReminderViewController.h"

#import "PresentingAnimator.h"
#import "DismissingAnimator.h"

#define DETAIL_REMINDER_NAME_SEGUE @"detailReminderSegue"

@interface ADRemindersTableViewController () <UIViewControllerTransitioningDelegate, ADNewReminderViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) ADRemindersViewModel *viewModel;

@property (nonatomic, strong) UIView *blurView;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (void)_addSubView;
- (void)_applicationDidReceiveLocalNotificationOnActive:(NSNotification *)notification;
- (void)_applicationDidReceiveLocalNotificationOnBackground:(NSNotification *)notification;
- (void)_initStyle;
- (void)_presentNewReminderViewController;
- (void)_refreshTableView;
- (void)_reloadData;
- (void)_selectRowAtIndexPathForLembreteDescricao:(NSString *)descricao;
- (void)_showBlurViewWithAnimation;

@end

@implementation ADRemindersTableViewController

#pragma mark - Getter Methods -

- (ADRemindersViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ADRemindersViewModel alloc] init];
    }
    return _viewModel;
}

- (UIView *)blurView {
    if (!_blurView) {
        _blurView = [UIView viewWithFrame:self.view.frame];
        _blurView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.300];
    }
    
    return _blurView;
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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self _initStyle];
    [self _addSubView];
    
    [self _reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self _reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_applicationDidReceiveLocalNotificationOnActive:)
                                                 name:APPLICATION_DID_RECEIVE_LOCAL_NOTIFICATION_ACTIVE
                                               object:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_applicationDidReceiveLocalNotificationOnBackground:)
                                                 name:APPLICATION_DID_RECEIVE_LOCAL_NOTIFICATION_BACKGROUND
                                               object:NULL];
}

- (void)viewDidDisappear:(BOOL)animated {
    #warning verificar se precisa cancelar as notificações
}

#pragma mark - Private Methods -

- (void)_addSubView {
    [self.view addSubview:self.blurView];
    [self.view sendSubviewToBack:self.blurView];
    [self.tableView addSubview:self.refreshControl];
}

- (void)_applicationDidReceiveLocalNotificationOnActive:(NSNotification *)notification {
    UILocalNotification *localNotification = notification.object;

    NSString *descricaoLembrete = [localNotification.userInfo objectForKey:LOCAL_NOTIFICATION_DOMAIN];
    [self _selectRowAtIndexPathForLembreteDescricao:descricaoLembrete];
    
    [[UIAlertView alertViewWithTitle:@"Não esqueça sua atividade!"
                             message:localNotification.alertBody
                            delegate:self
                   cancelButtonTitle:@"Não"
                   otherButtonTitles:@"Sim", nil] show];

}

- (void)_applicationDidReceiveLocalNotificationOnBackground:(NSNotification *)notification {
    UILocalNotification *localNotification = notification.object;
    
    NSString *descricaoLembrete = [localNotification.userInfo objectForKey:LOCAL_NOTIFICATION_DOMAIN];
    [self _selectRowAtIndexPathForLembreteDescricao:descricaoLembrete];
    
    [self performSegueWithIdentifier:DETAIL_REMINDER_NAME_SEGUE sender:nil];
}

- (void)_initStyle {
    [self.tableView setBackgroundColor:[UIColor sam_colorWithHex:@"#EFF2F5"]];
}

- (void)_presentNewReminderViewController {
    ADNewReminderViewController *newReminderViewController = [ADNewReminderViewController viewController];
    newReminderViewController.delegate = self;
    newReminderViewController.transitioningDelegate = self;
    newReminderViewController.modalPresentationStyle = UIModalPresentationCustom;

//    [self _showBlurViewWithAnimation];
    
    [self presentViewController:newReminderViewController animated:YES completion:NULL];
}

- (void)_refreshTableView {
    [self.refreshControl beginRefreshing];
    [self _reloadData];
    [self.refreshControl endRefreshing];
}

- (void)_reloadData {
    [self.viewModel executeFetchRequest];
    [self.tableView reloadData];
}

- (void)_selectRowAtIndexPathForLembreteDescricao:(NSString *)descricao {
    NSIndexPath *indePath = [self.viewModel indexPathForLembreteWithDescricao:descricao];
    [self.tableView selectRowAtIndexPath:indePath
                                animated:YES
                          scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)_showBlurViewWithAnimation {
    [self.view bringSubviewToFront:self.blurView];
    
    self.blurView.alpha = 0.0f;
    [UIView animateWithDuration:0.5f animations:^{
        self.blurView.alpha = 1.0f;
    }];
}

#pragma mark - UITableViewDataSource Methods -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfReminders = [self.viewModel numberOfItemsInSection:section];
    self.totalRemindersLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfReminders];
    return numberOfReminders;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderCell"];
 
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel deleteRow:indexPath];
    [self.viewModel executeFetchRequest];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - IBOutlet Methods -

- (IBAction)newReminderTouched:(id)sender {
    [self _presentNewReminderViewController];
}

#pragma mark - UIViewControllerTransitioningDelegate Methods -

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [PresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [DismissingAnimator new];
}

#pragma mark - ADNewReminderViewControllerDelegate Methods -

- (void)newReminderViewController:(ADNewReminderViewController *)newReminderViewController
                  didSaveReminder:(ADLembrete *)reminder {
    [self.view sendSubviewToBack:self.blurView];
    [newReminderViewController dismissViewControllerAnimated:YES completion:^{
        [self.viewModel executeFetchRequest];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
    }];
}

- (void)newReminderViewControllerDidCancelReminder:(ADNewReminderViewController *)newReminderViewController {
        [self.view sendSubviewToBack:self.blurView];
}

#pragma mark - UIAlertViewDelegate Methods -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            [self performSegueWithIdentifier:DETAIL_REMINDER_NAME_SEGUE sender:nil];
            break;
        default:
            break;
    }
}

#pragma mark - UIStoryboard Methods -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:DETAIL_REMINDER_NAME_SEGUE]) {
        
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
        ADDetailReminderViewController *detailViewController = (ADDetailReminderViewController *)[segue destinationViewController];
        [detailViewController.viewModel lembreteDetail:[self.viewModel lembreteAtIndexPath:indexPath]];
    }
}

@end