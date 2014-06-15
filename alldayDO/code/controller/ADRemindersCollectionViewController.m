//
//  ADRemindersCollectionViewController.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 05/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADRemindersCollectionViewController.h"

#import "ADLembrete.h"
#import "ADModel.h"
#import "ADReminderCell.h"

#import "ADNewReminderViewController.h"
#import "ADNewReminderViewControllerDelegate.h"

#import "PresentingAnimator.h"
#import "DismissingAnimator.h"

@interface ADRemindersCollectionViewController () <UIViewControllerTransitioningDelegate, ADNewReminderViewControllerDelegate>

@property (nonatomic, strong) ADRemindersViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation ADRemindersCollectionViewController

#pragma mark - Getter Methods -

- (ADRemindersViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ADRemindersViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - UIView Lifecycle Methods -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.toolbar setBackgroundImage:[UIImage imageNamed:@"navigation_bg"]
                  forToolbarPosition:UIBarPositionAny
                          barMetrics:UIBarMetricsDefault];
    
    [self.viewModel executeFetchRequest];    
    [self.collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

#pragma mark - Private Methods -

- (void)_presentNewReminderViewController {
    ADNewReminderViewController *newReminderViewController = [ADNewReminderViewController viewController];
    newReminderViewController.delegate = self;
    newReminderViewController.transitioningDelegate = self;
    newReminderViewController.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:newReminderViewController animated:YES completion:NULL];
}

#pragma mark - UICollectionViewDataSource Methods -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.viewModel numberOfSections];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADReminderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reminderCell" forIndexPath:indexPath];
    
    [self.viewModel fetchObjectAtIndexPath:indexPath];
    
    cell.badgeImageView.badgeIconImageView.image = self.viewModel.imagem;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods -


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
    [newReminderViewController dismissViewControllerAnimated:YES completion:^{
        [self.viewModel executeFetchRequest];
        [self.collectionView performBatchUpdates:^{
            int numberOfItems = [self.collectionView numberOfItemsInSection:0];
            
            NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
            NSArray *newReminder = @[reminder];
            
            for (int i = numberOfItems; i < numberOfItems + newReminder.count; i++) {
                [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            
            [self.collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
        } completion:nil];
    }];
}

@end