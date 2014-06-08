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

#import "PresentingAnimator.h"
#import "DismissingAnimator.h"

@interface ADRemindersCollectionViewController () <UIViewControllerTransitioningDelegate>

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
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self _executeFetchRequest];
}

#pragma mark - Private Interface -

- (void)_executeFetchRequest {
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    [self.collectionView reloadData];
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
    
//    ADLembrete *lembrete = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    UILabel *descriptionLabel = [UILabel labelWithFrame:cell.bounds];
//    descriptionLabel.numberOfLines = 0;
//    descriptionLabel.text = [NSString stringWithFormat:@"%@", lembrete.descricao];
//    [cell addSubview:descriptionLabel];

    return cell;
}

#pragma mark - UICollectionViewDelegate Methods -


#pragma mark - IBOutlet Methods -

- (IBAction)newReminderTouched:(id)sender {
    ADNewReminderViewController *newReminderViewController = [ADNewReminderViewController viewController];
    
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

@end