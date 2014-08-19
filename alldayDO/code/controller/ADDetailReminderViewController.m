//
//  ADDetailReminderViewController.m
//  alldayDO
//
//  Created by Fábio Almeida on 8/13/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADDetailReminderViewController.h"
#import "ADNewReminderViewController.h"
#import "PNChart.h"

@interface ADDetailReminderViewController ()

@property (nonatomic, strong) PNLineChart *lineChart;

- (void)_animationToPortraitRotationChartView;
- (void)_animationToLandscapeRotationChartView;
- (void)_updateInterface;
- (void)_updateChart;

@end

@implementation ADDetailReminderViewController

#pragma mark - UIView Lifecycle Methods -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.lineChart];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_second_color_bg"] forBarMetrics:UIBarMetricsDefault];
    
    [self _updateInterface];
}

#pragma mark - Getter Methods -

- (ADDetailReminderViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ADDetailReminderViewModel alloc] init];
    }
    return _viewModel;
}

- (PNLineChart *)lineChart {
    if (!_lineChart) {
        _lineChart = [[PNLineChart alloc] initWithFrame:self.chartContentView.frame];
    }
    return _lineChart;
}

#pragma mark - Private Methods -

- (void)_animationToPortraitRotationChartView {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.lineChart.center = self.view.center;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.lineChart.bounds = self.chartContentView.bounds;
        [self _updateChart];
    }];
}

- (void)_animationToLandscapeRotationChartView {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.lineChart.center = self.view.center;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.lineChart.bounds = self.view.bounds;
        [self.lineChart setX:0.f andY:0.f];
        [self _updateChart];
    }];
}

- (void)_updateInterface {
    self.monthLabel.text = [NSString stringWithFormat:@"%ld", (long)self.viewModel.quantidadeConfirmacaoPorMes];
    self.weekLabel.text = [NSString stringWithFormat:@"%ld", (long)self.viewModel.quantidadeConfirmacaoPorSemama];
    self.inLineLabel.text = [NSString stringWithFormat:@"%ld", (long)self.viewModel.quantidadeConfirmacaoSeguidos];
    [self.doneButton setSelected:self.viewModel.isLembreteConfirmated];
    [self _updateChart];
}

- (void)_updateChart {
    PNLineChartData *chartData = [PNLineChartData new];
    chartData.color = PNFreshGreen;
    chartData.itemCount = [self.viewModel chartDataItemCount];
    chartData.getData = ^(NSUInteger index) {
        NSUInteger valorY = 1;
    
        NSDate *data = [self.viewModel.calendario objectAtIndex:index];
        if ([self.viewModel.dataLembretesConfirmados containsObject:data]) {
            valorY = 0;
        }
    
        return [PNLineChartDataItem dataItemWithY:valorY];
    };
    
    self.lineChart.showLabel = NO;
    self.lineChart.chartData = @[chartData];
    [self.lineChart setXLabels:[self.viewModel chartDataXLabels]];
    [self.lineChart strokeChart];
}

#pragma mark - IBAction Methods -

- (IBAction)editButtonTouched:(id)sender {
}

- (IBAction)doneButtonTouched:(id)sender {
    if (self.doneButton.selected) {
        [self.viewModel removeLembreteConfirmado];
    } else {
        [self.viewModel addLembreteConfirmado];
    }
    
    [self _updateInterface];
}


#pragma mark - UIInterfaceOrientation Methods

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
//        [self performSelector:@selector(_animationToPortraitRotationChartView) withObject:self afterDelay:duration];
//    } else {
//        [self performSelector:@selector(_animationToLandscapeRotationChartView) withObject:self afterDelay:duration];
//    }
//}
//

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

- (BOOL)shouldAutorotate{
    return YES;
}

@end
