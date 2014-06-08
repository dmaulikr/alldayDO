//
//  ADRemindersCollectionViewController.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 05/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADRemindersCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UINavigationBar *nagivationBar;

- (IBAction)newReminderTouched:(id)sender;

@end
