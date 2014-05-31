//
//  ADRemindersTableViewController.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADRemindersTableViewController.h"

#import "ADLembrete.h"
#import "ADModel.h"

#import "ADNewReminderViewController.h"

@interface ADRemindersTableViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)_executeFetchRequest;

@end

@implementation ADRemindersTableViewController

#pragma mark - Getter Methods

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

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _executeFetchRequest];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"reminderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    };
    
    cell.backgroundColor = [UIColor clearColor];
    
    ADLembrete *lembrete = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", lembrete.descricao];
    return cell;
}

#pragma mark - Private Interface

- (void)_executeFetchRequest {
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    [self.tableView reloadData];
}

- (IBAction)newReminderTouched:(id)sender {
    ADNewReminderViewController *newReminderViewController = [ADNewReminderViewController viewController];

    [self presentViewController:newReminderViewController animated:YES completion:nil];
    
//    newReminderViewController.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self.navigationController presentViewController:newReminderViewController
//                                            animated:YES
//                                          completion:NULL];
}
@end
