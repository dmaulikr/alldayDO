//
//  ADSettingsTableViewController.h
//  alldayDO
//
//  Created by Fábio Nogueira de Almeida on 05/03/15.
//  Copyright (c) 2015 Fábio Nogueira . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADSettingsTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *categoriaOneText;
@property (weak, nonatomic) IBOutlet UITextField *categoriaTwoText;
@property (weak, nonatomic) IBOutlet UITextField *categoriaThreeText;
@property (weak, nonatomic) IBOutlet UITableViewRowAction *CategoriasTableViewSection;

@end
