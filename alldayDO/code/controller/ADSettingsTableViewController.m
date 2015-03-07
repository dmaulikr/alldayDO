//
//  ADSettingsTableViewController.m
//  alldayDO
//
//  Created by Fábio Nogueira de Almeida on 05/03/15.
//  Copyright (c) 2015 Fábio Nogueira . All rights reserved.
//

#import "ADSettingsTableViewController.h"

@interface ADSettingsTableViewController ()

@property (nonatomic, strong) ADCategoria *categoriaOne;
@property (nonatomic, strong) ADCategoria *categoriaTwo;
@property (nonatomic, strong) ADCategoria *categoriaThree;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsControllerCategoria;

- (void)_addTextToCategoriaLabels;
- (void)_saveCategorias;

@end

@implementation ADSettingsTableViewController


#pragma mark - Getter Methods

- (NSFetchedResultsController *)fetchedResultsControllerCategoria {
    if (!_fetchedResultsControllerCategoria) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ADCategoria"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"descricao" ascending:YES]];
        
        _fetchedResultsControllerCategoria = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:[ADModel sharedInstance].managedObjectContext
                                                                                   sectionNameKeyPath:nil
                                                                                            cacheName:@"descricao_reminders_cache"];
    }
    return _fetchedResultsControllerCategoria;
}

#pragma mark - Private Methods

- (void)_addTextToCategoriaLabels {
    for (int i = 1; i <= 3; i++) {
        if (i == 1) {
            self.categoriaOne = [[self.fetchedResultsControllerCategoria fetchedObjects] objectAtIndex:0];
            self.categoriaOneText.text = self.categoriaOne.descricao;
        }
        if (i == 2) {
            self.categoriaTwo = [[self.fetchedResultsControllerCategoria fetchedObjects] objectAtIndex:1];
            self.categoriaTwoText.text = self.categoriaTwo.descricao;
        }
        if (i == 3) {
            self.categoriaThree = [[self.fetchedResultsControllerCategoria fetchedObjects] objectAtIndex:2];
            self.categoriaThreeText.text = self.categoriaThree.descricao;
        }
    }
}

- (void)_saveCategorias {
    self.categoriaOne.descricao = self.categoriaOneText.text;
    self.categoriaTwo.descricao = self.categoriaTwoText.text;
    self.categoriaThree.descricao = self.categoriaThreeText.text;
    
    [[ADModel sharedInstance] saveChanges];
}


#pragma mark - ViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_second_color_bg"]
                                                  forBarMetrics:UIBarMetricsDefault];

    self.title = NSLocalizedString(@"settings", nil);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.fetchedResultsControllerCategoria performFetch:nil];
    [self _addTextToCategoriaLabels];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self _saveCategorias];
}

@end
