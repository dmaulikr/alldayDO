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

- (void)willRotateToInterfaceOrientation:(NSNotification *)notification;

@end

@implementation ADDetailReminderViewController

#pragma mark - UIView Lifecycle Methods -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.lineChart];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willRotateToInterfaceOrientation:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_second_color_bg"]
                                                  forBarMetrics:UIBarMetricsDefault];
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
        _lineChart.showLabel = NO;
    }
    return _lineChart;
}

#pragma mark - Private Methods -

- (void)_animationToPortraitRotationChartView {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.lineChart.center = self.view.center;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.lineChart.bounds = self.chartContentView.bounds;
        self.lineChart.showLabel = NO;
        [self _updateChart];
    }];
}

- (void)_animationToLandscapeRotationChartView {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.lineChart.center = self.view.center;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.lineChart.bounds = self.view.bounds;
        [self.lineChart setX:0.f andY:0.f];
        self.lineChart.showLabel = YES;
        [self _updateChart];
    }];
}

- (void)_updateInterface {
    self.title = self.viewModel.title;
    self.monthLabel.text = [NSString stringWithFormat:@"%ld", (long)self.viewModel.quantidadeConfirmacaoPorMes];
    self.weekLabel.text = [NSString stringWithFormat:@"%ld", (long)self.viewModel.quantidadeConfirmacaoPorSemama];
    self.inLineLabel.text = [NSString stringWithFormat:@"%ld", (long)self.viewModel.quantidadeConfirmacaoSeguidos];
    [self.doneButton setSelected:self.viewModel.isLembreteConfirmated];
    [self _updateChart];
}

- (void)_updateChart {
    PNLineChartData *lineChartData = [PNLineChartData new];
    lineChartData.color = PNFreshGreen;
    lineChartData.itemCount = [self.viewModel chartDataItemCount];
    
    NSArray *calendario = self.viewModel.calendario;
    NSArray *lembretesConfirmados = self.viewModel.dataLembretesConfirmados;
    
    lineChartData.getData = ^(NSUInteger index) {
        NSUInteger valorY = 1;
        
        NSDate *data = [calendario objectAtIndex:index];
        if ([lembretesConfirmados containsObject:data]) {
            valorY = 0;
        }
        
        return [PNLineChartDataItem dataItemWithY:valorY];
    };
    
    self.lineChart.chartData = @[lineChartData];
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

- (void)willRotateToInterfaceOrientation:(NSNotification *)notification {
    UIDevice *device = notification.object;
    
    if (device.orientation == UIInterfaceOrientationPortrait ||
        device.orientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self performSelector:@selector(_animationToPortraitRotationChartView) withObject:self];
    } else {
        [self performSelector:@selector(_animationToLandscapeRotationChartView) withObject:self];
    }
}

@end
