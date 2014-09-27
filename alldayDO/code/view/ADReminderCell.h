//
//  ADReminderCell.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 07/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBadgeImageView.h"

#import "PNChart.h"

@interface ADReminderCell : UITableViewCell

@property (nonatomic, strong) ADBadgeImageView *badgeImageView;
@property (strong, nonatomic) IBOutlet UIView *borderTimelineContentView;

@property (weak, nonatomic) IBOutlet UIView *timelineContentView;

@property (strong, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *nomeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nextReminderLabel;

@property (weak, nonatomic) IBOutlet UIView *barChartContentView;

@property (nonatomic, strong) PNBarChart *barChart;

- (void)initBarChartAlreadyCreated;

@end
