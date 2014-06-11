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

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)_executeFetchRequest;

@end

@implementation ADRemindersCollectionViewController

#pragma mark - Getter Methods -

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ADLembrete"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"descricao" ascending:YES]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[ADModel sharedInstance].managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:@"reminders_cache"];
    }
    
    return _fetchedResultsController;
}


#pragma mark - UIView Lifecycle Methods -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.toolbar setBackgroundImage:[UIImage imageNamed:@"navigation_bg"]
                  forToolbarPosition:UIBarPositionAny
                          barMetrics:UIBarMetricsDefault];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self _executeFetchRequest];
    [self.collectionView reloadData];
}

#pragma mark - Private Interface -

- (void)_executeFetchRequest {
    [self.fetchedResultsController performFetch:nil];
}

#pragma mark - UICollectionViewDataSource Methods -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return sectionInfo.numberOfObjects;

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADReminderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reminderCell" forIndexPath:indexPath];
    ADLembrete *lembrete = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.iconImageView.image = [UIImage imageWithData:lembrete.imagem];
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods -


#pragma mark - IBOutlet Methods -

- (IBAction)newReminderTouched:(id)sender {
    ADNewReminderViewController *newReminderViewController = [ADNewReminderViewController viewController];
    newReminderViewController.delegate = self;
    newReminderViewController.transitioningDelegate = self;
    newReminderViewController.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:newReminderViewController animated:YES completion:NULL];
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
        [self _executeFetchRequest];
        
#warning ARRUMAR ESSA PORRA DE ANIMAÇÃO - CODIGO COPIADO
        NSArray *newData = [[NSArray alloc] initWithObjects:reminder, nil];
        [self.collectionView performBatchUpdates:^{
            int resultsSize = [self.collectionView numberOfItemsInSection:0]; 
            NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
            for (int i = resultsSize; i < resultsSize + newData.count; i++)
            {
                [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            [self.collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
        }
                                        completion:nil];
        
        
    }];

}

@end