//
//  ADAboutViewController.h
//  alldayDO
//
//  Created by Fábio Almeida on 9/9/14.
//  Copyright (c) 2014 F√°bio Nogueira . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADAboutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *fabioButton;
@property (weak, nonatomic) IBOutlet UIButton *arthurButton;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (IBAction)fabioTwitterTouched:(id)sender;
- (IBAction)arthurTwitterTouched:(id)sender;

@end
