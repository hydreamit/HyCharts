//
//  HyChartsAnyReactChainsDemoController.m
//  HyChartsDemo
//
//  Created by Hy on 2018/4/22.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartsAnyReactChainsDemoController.h"
#import "HyChartsBarDemoCursor.h"
#import "HyChartsLineDemoCursor.h"
#import <HyCategoriess/HyCategories.h>
#import <HyCycleView/HySegmentView.h>
#import "HyCharts.h"


@interface HyChartsAnyReactChainsDemoController ()
@property (nonatomic, strong) HyChartBarView *chartBarView;
@property (nonatomic, strong) HyChartLineView *chartLineView;
@end


@implementation HyChartsAnyReactChainsDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    
    UIView *chartBarView =  [self chartBarViewWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.view.bounds) - 20, 220)];
    [scrollView addSubview:chartBarView];

    UIView *chartLineView =  [self chartLineViewWithFrame:CGRectMake(10, CGRectGetMaxY(chartBarView.frame) + 10, CGRectGetWidth(self.view.bounds) - 20, 220)];
    [scrollView addSubview:chartLineView];

    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(chartLineView.frame) + 50);
       
    // 添加联动图表
    HyChartView.addReactChains(@[self.chartBarView, self.chartLineView]);
}


- (UIView *)chartBarViewWithFrame:(CGRect)frame {
    
    UIView *contentView = [[UIView alloc] initWithFrame:frame];
    contentView.backgroundColor = UIColor.whiteColor;
    contentView.layer.cornerRadius = 5;
    contentView.layer.borderWidth = 1.0;
    contentView.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
    contentView.clipsToBounds = NO;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(frame) - 20, 25)];
    titleLabel.text = @"男女生产量数据对比";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = UIColor.darkTextColor;
    [titleLabel sizeToFit];
    [contentView addSubview:titleLabel];
    
    UIView *(^typeView)(UIColor *color , NSString *title) =
    ^UIView * (UIColor *color , NSString *title) {
        
        UIView *tView = UIView.new;
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        colorView.backgroundColor = color;
        colorView.layer.cornerRadius = 2;
        [tView addSubview:colorView];
        
        UILabel *tLable = UILabel.new;
        tLable.text = title;
        tLable.textColor = UIColor.darkTextColor;
        tLable.font = [UIFont systemFontOfSize:10];
        [tLable sizeToFit];
        tLable.left = colorView.right + 3;
        tLable.centerYIsEqualTo(colorView);
        [tView addSubview:tLable];
        
        tView.sizeValue(tLable.right, colorView.height);
        return tView;
    };
    
    NSArray<UIColor *> *colorArray = @[UIColor.redColor, UIColor.greenColor];
    UIView *yView = typeView(colorArray.firstObject, @"男");
    UIView *oView = typeView(colorArray.lastObject, @"女");
    [contentView addSubview:yView];
    [contentView addSubview:oView];
    yView.centerY = oView.centerY  = titleLabel.centerY;
    yView.left = titleLabel.right + 10;
    oView.left = yView.right + 5;
    
    
    HyChartBarView *chartBarView =  [[HyChartBarView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 15, CGRectGetWidth(contentView.frame) - 20, CGRectGetHeight(frame) - CGRectGetMaxY(titleLabel.frame) - 15)];
    [contentView addSubview:chartBarView];
    
    chartBarView.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 22, 10);
    
    HyChartsBarDemoCursor *cursor = HyChartsBarDemoCursor.new;
    cursor.showView = chartBarView;
    [chartBarView resetChartCursor:cursor];
    
    // 配置坐标轴
    [[chartBarView.dataSource.axisDataSource configXAxisWithModel:^(id<HyChartXAxisModelProtocol>  _Nonnull xAxisModel) {
        xAxisModel.topXaxisDisabled = NO;
        [[[xAxisModel configNumberOfIndexs:5] configBottomXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
            xAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
        }] configTopXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
            xAxisInfo.autoSetText = NO;
        }];
    }] configYAxisWithModel:^(id<HyChartYAxisModelProtocol>  _Nonnull yAxisModel) {
        yAxisModel.rightYAaxisDisabled = NO;
        yAxisModel.yAxisMaxValueExtraPrecent = @(.1);
        [[[yAxisModel configNumberOfIndexs:5] configLeftYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
            yAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
            yAxisInfo.axisTextPosition = HyChartAxisTextPositionBinus;
            yAxisInfo.displayAxisZeroText = NO;
        }] configRightYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
            yAxisInfo.autoSetText = NO;
        }];
    }];
    
    // 配置图表信息
    [chartBarView.dataSource.configreDataSource configConfigure:^(id<HyChartBarConfigureProtocol>  _Nonnull configure) {
        configure.width = 20;
        configure.margin = 10;
        configure.edgeInsetStart = 5;
        configure.edgeInsetEnd = 5;
        [configure configBarConfigureAtIndex:^(NSInteger index, id<HyChartBarOneConfigureProtocol>  _Nonnull oneConfigure) {
            oneConfigure.fillColor = colorArray[index];
        }];
    }];
    
    NSMutableArray<NSArray<NSNumber *> *> *valus = @[].mutableCopy;
    NSMutableArray<NSString *> *titles  = @[].mutableCopy;
    for (NSInteger i = 0; i < 200; i++) {
        [valus addObject:@[@((int)(arc4random() % 1000 + 30)), @((int)(arc4random() % 1000 + 30))]];
        [titles addObject:[NSString stringWithFormat:@"第%ld天", (long)(i + 1)]];
    }

    // 配置数据
    [[chartBarView.dataSource.modelDataSource configNumberOfItems:^NSInteger{
        return valus.count;
    }] configModelForItemAtIndex:^(id<HyChartBarModelProtocol>  _Nonnull model, NSInteger index) {
        model.text = titles[index];
        model.values = valus[index];
        // 自定义数据
        NSDictionary *dict = @{@"colors" : colorArray, @"texts" : @[@"男", @"女"]};
        model.exData = dict;
    }];
    
    [chartBarView setNeedsRendering];
    
    self.chartBarView = chartBarView;
    
    return contentView;
}

- (UIView *)chartLineViewWithFrame:(CGRect)frame {
    
    UIView *contentView = [[UIView alloc] initWithFrame:frame];
    contentView.backgroundColor = UIColor.whiteColor;
    contentView.layer.cornerRadius = 5;
    contentView.layer.borderWidth = 1.0;
    contentView.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
    contentView.clipsToBounds = NO;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(frame) - 20, 25)];
    titleLabel.text = @"男女生产量数据对比";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = UIColor.darkTextColor;
    [titleLabel sizeToFit];
    [contentView addSubview:titleLabel];
    
    UIView *(^typeView)(UIColor *color , NSString *title) =
    ^UIView * (UIColor *color , NSString *title) {
        
        UIView *tView = UIView.new;
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        colorView.backgroundColor = color;
        colorView.layer.cornerRadius = 2;
        [tView addSubview:colorView];
        
        UILabel *tLable = UILabel.new;
        tLable.text = title;
        tLable.textColor = UIColor.darkTextColor;
        tLable.font = [UIFont systemFontOfSize:10];
        [tLable sizeToFit];
        tLable.left = colorView.right + 3;
        tLable.centerYIsEqualTo(colorView);
        [tView addSubview:tLable];
        
        tView.sizeValue(tLable.right, colorView.height);
        return tView;
    };
    
    NSArray<UIColor *> *colorArray = @[UIColor.redColor, UIColor.greenColor];
    UIView *yView = typeView(colorArray.firstObject, @"男");
    UIView *oView = typeView(colorArray.lastObject, @"女");
    [contentView addSubview:yView];
    [contentView addSubview:oView];
    yView.centerY = oView.centerY  = titleLabel.centerY;
    yView.left = titleLabel.right + 10;
    oView.left = yView.right + 5;
    
    
    HyChartLineView *chartLineView =  [[HyChartLineView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 15, CGRectGetWidth(contentView.frame) - 20, CGRectGetHeight(frame) - CGRectGetMaxY(titleLabel.frame) - 15)];
    [contentView addSubview:chartLineView];
    
    chartLineView.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 22, 10);
    
    // 自定义游标
    HyChartsLineDemoCursor *cursor = HyChartsLineDemoCursor.new;
    cursor.showView = chartLineView;
    [chartLineView resetChartCursor:cursor];
    
    // 配置坐标轴
    [[chartLineView.dataSource.axisDataSource configXAxisWithModel:^(id<HyChartXAxisModelProtocol>  _Nonnull xAxisModel) {
        xAxisModel.topXaxisDisabled = NO;
        [[[xAxisModel configNumberOfIndexs:5] configBottomXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
            xAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
        }] configTopXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
            xAxisInfo.autoSetText = NO;
        }];
    }] configYAxisWithModel:^(id<HyChartYAxisModelProtocol>  _Nonnull yAxisModel) {
        yAxisModel.rightYAaxisDisabled = NO;
        yAxisModel.yAxisMaxValueExtraPrecent = @(.1);
        [[[yAxisModel configNumberOfIndexs:5] configLeftYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
            yAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
            yAxisInfo.axisTextPosition = HyChartAxisTextPositionBinus;
            yAxisInfo.displayAxisZeroText = NO;
        }] configRightYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
            yAxisInfo.autoSetText = NO;
        }];
    }];
    
    // 配置图表信息
    [chartLineView.dataSource.configreDataSource configConfigure:^(id<HyChartLineConfigureProtocol>  _Nonnull configure) {
        configure.width = 20;
        configure.margin = 10;
        configure.edgeInsetStart = 5;
        configure.edgeInsetEnd = 5;
        [configure configLineConfigureAtIndex:^(NSInteger index, id<HyChartLineOneConfigureProtocol>  _Nonnull oneConfigure) {
            oneConfigure.lineWidth = 2;
            oneConfigure.lineColor = colorArray[index];
            oneConfigure.lineType = HyChartLineTypeCurve;
        }];
    }];
    
    NSMutableArray<NSArray<NSNumber *> *> *valus = @[].mutableCopy;
    NSMutableArray<NSString *> *titles  = @[].mutableCopy;
    for (NSInteger i = 0; i < 200; i++) {
        [valus addObject:@[@((int)(arc4random() % 1000 + 30)), @((int)(arc4random() % 1000 + 30))]];
        [titles addObject:[NSString stringWithFormat:@"第%ld天", (long)(i + 1)]];
    }

    // 配置数据
    [[chartLineView.dataSource.modelDataSource configNumberOfItems:^NSInteger{
        return valus.count;
    }] configModelForItemAtIndex:^(id<HyChartLineModelProtocol>  _Nonnull model, NSInteger index) {
        model.text = titles[index];
        model.values = valus[index];
        // 自定义数据
        NSDictionary *dict = @{@"colors" : colorArray, @"texts" : @[@"男", @"女"]};
        model.exData = dict;
    }];
    
    [chartLineView setNeedsRendering];
    
    self.chartLineView = chartLineView;

    return contentView;
}

@end
