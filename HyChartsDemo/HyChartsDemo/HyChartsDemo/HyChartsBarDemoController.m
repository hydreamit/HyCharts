//
//  HyChartsBarDemoController.m
//  DemoCode
//
//  Created by Hy on 2018/4/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartsBarDemoController.h"
#import <HyCategoriess/HyCategories.h>
#import "HyChartsBarDemoCursor.h"
#import "HyChartsLineDemoCursor.h"
#import "HyCharts.h"


@implementation HyChartsBarDemoController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    
    UIView *oneChartView =  [self oneChartBarViewWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.view.bounds) - 20, 220)];
    [scrollView addSubview:oneChartView];
    
    UIView *twoChartView =  [self twoChartBarViewWithFrame:CGRectMake(10, CGRectGetMaxY(oneChartView.frame) + 10, CGRectGetWidth(self.view.bounds) - 20, 220)];
    [scrollView addSubview:twoChartView];
    
    UIView *threeChartView =  [self threeChartBarViewWithFrame:CGRectMake(10, CGRectGetMaxY(twoChartView.frame) + 10, CGRectGetWidth(self.view.bounds) - 20, 220)];
    [scrollView addSubview:threeChartView];
    
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(threeChartView.frame) + 50);
}

- (UIView *)oneChartBarViewWithFrame:(CGRect)frame {
    
    UIView *contentView = [[UIView alloc] initWithFrame:frame];
    contentView.backgroundColor = UIColor.whiteColor;
    contentView.layer.cornerRadius = 5;
    contentView.layer.borderWidth = 1.0;
    contentView.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
    contentView.clipsToBounds = NO;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(frame) - 20, 25)];
    titleLabel.text = @"24小时新增数国家Top10";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = UIColor.darkTextColor;
    [contentView addSubview:titleLabel];
    
    HyChartBarView *chartBarView =  [[HyChartBarView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 15, CGRectGetWidth(titleLabel.frame), CGRectGetHeight(frame) - CGRectGetMaxY(titleLabel.frame) - 25)];
    [contentView addSubview:chartBarView];
        
    chartBarView.contentEdgeInsets = UIEdgeInsetsMake(0, 35, 35, 10);
    chartBarView.pinchGestureDisabled = YES;
    
    // 自定义游标
    HyChartsBarDemoCursor *cursor = HyChartsBarDemoCursor.new;
    cursor.showView = chartBarView;
    [chartBarView resetChartCursor:cursor];
    
    // 配置坐标轴
    [[chartBarView.dataSource.axisDataSource configXAxisWithModel:^(id<HyChartXAxisModelProtocol>  _Nonnull xAxisModel) {
        xAxisModel.topXaxisDisabled = NO;
        [[[[xAxisModel configNumberOfIndexs:10] configAxisGridLineInfo:^(id<HyChartAxisGridLineInfoProtocol>  _Nonnull axisGridLineInfo) {
            axisGridLineInfo.axisGridLineType = HyChartAxisLineTypeNone;
        }] configBottomXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
            xAxisInfo.rotateAngle = - M_PI_4;
            xAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
            xAxisInfo.displayAxisZeroText = NO;
        }] configTopXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
            xAxisInfo.autoSetText = NO;
            xAxisInfo.axisLineWidth = 1;
            xAxisInfo.axisLineColor = UIColor.groupTableViewBackgroundColor;
        }];
    }] configYAxisWithModel:^(id<HyChartYAxisModelProtocol>  _Nonnull yAxisModel) {
        [[[yAxisModel configNumberOfIndexs:5] configYAxisMaxValue:^NSNumber * _Nonnull{
            return @50000;
        }] configLeftYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
            yAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
            yAxisInfo.axisTextPosition = HyChartAxisTextPositionBinus;
            yAxisInfo.axisLineType = HyChartAxisLineTypeNone;
            yAxisInfo.displayAxisZeroText = NO;
        }];
    }];
    
    // 配置图表信息
    [chartBarView.dataSource.configreDataSource configConfigure:^(id<HyChartBarConfigureProtocol>  _Nonnull configure) {
        configure.width = 10;
        configure.autoMargin = YES;
        [configure configBarConfigureAtIndex:^(NSInteger index, id<HyChartBarOneConfigureProtocol>  _Nonnull oneConfigure) {
            oneConfigure.fillColor = UIColor.redColor;
        }];
    }];
    
    NSArray<NSNumber *> *valus = @[@42256, @25550, @12345, @10000, @9854, @8883, @6588, @3589, @888];
    NSArray<NSString *> *titles = @[@"美国", @"英国", @"意大利", @"韩国", @"西班牙", @"日本", @"法国", @"德国", @"巴西"];
    
    // 配置数据
    [[chartBarView.dataSource.modelDataSource configNumberOfItems:^NSInteger{
        return valus.count;
    }] configModelForItemAtIndex:^(id<HyChartBarModelProtocol>  _Nonnull model, NSInteger index) {
        model.text = titles[index];
        model.values = @[valus[index]];
        // 自定义数据
        NSDictionary *dict = @{@"colors" : @[UIColor.redColor]};
        model.exData = dict;
    }];
    
    [chartBarView setNeedsRendering];
        
    return contentView;
}

- (UIView *)twoChartBarViewWithFrame:(CGRect)frame {
    
    UIView *contentView = [[UIView alloc] initWithFrame:frame];
    contentView.backgroundColor = UIColor.whiteColor;
    contentView.layer.cornerRadius = 5;
    contentView.layer.borderWidth = 1.0;
    contentView.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
    contentView.clipsToBounds = NO;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(frame) - 20, 25)];
    titleLabel.text = @"世界几大洲数据对比";
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
    
    NSArray<UIColor *> *colorArray = @[UIColor.redColor, UIColor.greenColor, UIColor.purpleColor];
    UIView *yView = typeView(colorArray.firstObject, @"亚洲");
    UIView *oView = typeView(colorArray[1], @"欧洲");
    UIView *mView = typeView(colorArray.lastObject, @"美洲");
    [contentView addSubview:yView];
    [contentView addSubview:oView];
    [contentView addSubview:mView];
    yView.centerY = oView.centerY = mView.centerY = titleLabel.centerY;
    yView.left = titleLabel.right + 10;
    oView.left = yView.right + 5;
    mView.left = oView.right + 5;
    
    HyChartBarView *chartBarView =  [[HyChartBarView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 15, CGRectGetWidth(contentView.frame) - 20, CGRectGetHeight(frame) - CGRectGetMaxY(titleLabel.frame) - 25)];
    [contentView addSubview:chartBarView];
    
    chartBarView.contentEdgeInsets = UIEdgeInsetsMake(0, 35, 35, 10);
    chartBarView.pinchGestureDisabled = YES;
    
    HyChartsBarDemoCursor *cursor = HyChartsBarDemoCursor.new;
    cursor.showView = chartBarView;
    [chartBarView resetChartCursor:cursor];
    
    // 配置坐标轴
    [[chartBarView.dataSource.axisDataSource configXAxisWithModel:^(id<HyChartXAxisModelProtocol>  _Nonnull xAxisModel) {
        xAxisModel.topXaxisDisabled = NO;
        [[[[xAxisModel configNumberOfIndexs:8] configAxisGridLineInfo:^(id<HyChartAxisGridLineInfoProtocol>  _Nonnull axisGridLineInfo) {
            axisGridLineInfo.axisGridLineType = HyChartAxisLineTypeNone;
        }] configBottomXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
            xAxisInfo.rotateAngle = - M_PI_4;
            xAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
            xAxisInfo.displayAxisZeroText = NO;
        }] configTopXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
            xAxisInfo.autoSetText = NO;
            xAxisInfo.axisLineWidth = 1;
            xAxisInfo.axisLineColor = UIColor.groupTableViewBackgroundColor;
        }];
    }] configYAxisWithModel:^(id<HyChartYAxisModelProtocol>  _Nonnull yAxisModel) {
        
        [[[yAxisModel configNumberOfIndexs:5] configYAxisMaxValue:^NSNumber * _Nonnull{
            return @100000;
        }] configLeftYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
            yAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
            yAxisInfo.axisTextPosition = HyChartAxisTextPositionBinus;
            yAxisInfo.axisLineType = HyChartAxisLineTypeNone;
            yAxisInfo.displayAxisZeroText = NO;
        }];
    }];
    
    // 配置图表信息
    [chartBarView.dataSource.configreDataSource configConfigure:^(id<HyChartBarConfigureProtocol>  _Nonnull configure) {
        configure.width = 24;
        configure.autoMargin = YES;
        [configure configBarConfigureAtIndex:^(NSInteger index, id<HyChartBarOneConfigureProtocol>  _Nonnull oneConfigure) {
            oneConfigure.fillColor = colorArray[index];
        }];
    }];
    
    NSArray<NSArray<NSNumber *> *> *valus = @[@[@2000, @10000, @5000], @[@22000, @60000, @8000], @[@32000, @65000, @80000], @[@26000, @30000, @6500], @[@23500, @10000, @4500], @[@6000, @80000, @4500], @[@60000, @88000, @90000]];
    NSArray<NSString *> *titles = @[@"03-08", @"03-09", @"03-10", @"03-11", @"03-12", @"03-13", @"03-14"];
    
    // 配置数据
    [[chartBarView.dataSource.modelDataSource configNumberOfItems:^NSInteger{
        return valus.count;
    }] configModelForItemAtIndex:^(id<HyChartBarModelProtocol>  _Nonnull model, NSInteger index) {
        model.text = titles[index];
        model.values = valus[index];
        // 自定义数据
        NSDictionary *dict = @{@"colors" : colorArray, @"texts" : @[@"亚洲", @"欧洲", @"美洲"]};
        model.exData = dict;
    }];
    
    [chartBarView setNeedsRendering];
    
    return contentView;
}

- (UIView *)threeChartBarViewWithFrame:(CGRect)frame {
    
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
        
    return contentView;
}


- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
