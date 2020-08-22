//
//  HyChartsLineDemoController.m
//  DemoCode
//
//  Created by Hy on 2018/4/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartsLineDemoController.h"
#import <HyCategoriess/HyCategories.h>
#import "HyChartsLineDemoCursor.h"
#import "HyCharts.h"


@implementation HyChartsLineDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    
    UIView *oneChartView =  [self oneChartLinViewWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.view.bounds) - 20, 220)];
    [scrollView addSubview:oneChartView];
    
    UIView *twoChartView =  [self twoChartLinViewWithFrame:CGRectMake(10, CGRectGetMaxY(oneChartView.frame) + 10, CGRectGetWidth(self.view.bounds) - 20, 250)];
    [scrollView addSubview:twoChartView];

    UIView *threeChartView =  [self threeChartLineViewWithFrame:CGRectMake(10, CGRectGetMaxY(twoChartView.frame) + 10, CGRectGetWidth(self.view.bounds) - 20, 220)];
    [scrollView addSubview:threeChartView];

    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(threeChartView.frame) + 50);
}

- (UIView *)oneChartLinViewWithFrame:(CGRect)frame {
    
    UIView *contentView = [[UIView alloc] initWithFrame:frame];
    contentView.backgroundColor = UIColor.whiteColor;
    contentView.layer.cornerRadius = 5;
    contentView.layer.borderWidth = 1.0;
    contentView.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
    contentView.clipsToBounds = NO;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(frame) - 20, 25)];
    titleLabel.text = @"单一折/曲线图";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = UIColor.darkTextColor;
    [contentView addSubview:titleLabel];
    
    HyChartLineView *chartLineView =  [[HyChartLineView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 15, CGRectGetWidth(titleLabel.frame), CGRectGetHeight(frame) - CGRectGetMaxY(titleLabel.frame) - 25)];
    [contentView addSubview:chartLineView];
    
    chartLineView.contentEdgeInsets = UIEdgeInsetsMake(0, 35, 35, 10);
    chartLineView.pinchGestureDisabled = YES;
    
    // 自定义游标
    HyChartsLineDemoCursor *cursor = HyChartsLineDemoCursor.new;
    cursor.showView = chartLineView;
    [chartLineView resetChartCursor:cursor];
    
    // 配置坐标轴
    [[chartLineView.dataSource.axisDataSource configXAxisWithModel:^(id<HyChartXAxisModelProtocol>  _Nonnull xAxisModel) {
        xAxisModel.topXaxisDisabled = NO;
        [[[xAxisModel configNumberOfIndexs:10] configBottomXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
            xAxisInfo.rotateAngle = - M_PI_4;
            xAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
            xAxisInfo.displayAxisZeroText = NO;
        }] configTopXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
            xAxisInfo.autoSetText = NO;
            xAxisInfo.axisLineWidth = 1;
            xAxisInfo.axisLineColor = UIColor.groupTableViewBackgroundColor;
        }];
    }] configYAxisWithModel:^(id<HyChartYAxisModelProtocol>  _Nonnull yAxisModel) {
        [[[[yAxisModel configNumberOfIndexs:5] configYAxisMaxValue:^NSNumber * _Nonnull{
            return @10000;
        }] configLeftYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
            yAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
            yAxisInfo.axisTextPosition = HyChartAxisTextPositionBinus;
            yAxisInfo.axisLineType = HyChartAxisLineTypeNone;
            yAxisInfo.displayAxisZeroText = NO;
        }] configYAxisMinValue:^NSNumber * _Nonnull{
            return @(0);
        }];
    }];
    
    // 配置图表信息
    [chartLineView.dataSource.configreDataSource configConfigure:^(id<HyChartLineConfigureProtocol>  _Nonnull configure) {
        configure.width = 0;
        configure.autoMargin = YES;
        [configure configLineConfigureAtIndex:^(NSInteger index, id<HyChartLineOneConfigureProtocol>  _Nonnull oneConfigure) {
            
            oneConfigure.lineWidth = 2;
            oneConfigure.lineColor = UIColor.orangeColor;
            oneConfigure.lineType = HyChartLineTypeCurve;
            
            oneConfigure.linePointWidth = .5;
            oneConfigure.linePointSize = CGSizeMake(5, 5);
            oneConfigure.linePointType = HyChartLinePointTypeRing;
            oneConfigure.linePointFillColor = UIColor.whiteColor;
            oneConfigure.shadeColors = @[[UIColor colorWithRed:255.0/255 green:165.0/255 blue:0.0/255 alpha:.8], [UIColor colorWithRed:255.0/255 green:165.0/255 blue:0.0/255 alpha:.6], [UIColor colorWithRed:255.0/255 green:165.0/255 blue:0.0/255 alpha:.4] ,[UIColor colorWithRed:255.0/255 green:165.0/255 blue:0.0/255 alpha:.2], [UIColor colorWithRed:255.0/255 green:165.0/255 blue:0.0/255 alpha:.1]];
        }];
    }];
    
   NSArray<NSString *> *titles = @[@"03-08", @"03-09", @"03-10", @"03-11", @"03-12", @"03-13", @"03-14", @"03-18", @"03-19"];
    NSMutableArray<NSNumber *> *values = @[].mutableCopy;
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [values addObject:@((int)(arc4random() % 10000))];
    }];
    
    // 配置数据
    [[chartLineView.dataSource.modelDataSource configNumberOfItems:^NSInteger{
        return values.count;
    }] configModelForItemAtIndex:^(id<HyChartLineModelProtocol>  _Nonnull model, NSInteger index) {
        model.text = titles[index];
        model.values = @[values[index]];
        // 自定义数据
        NSDictionary *dict = @{@"colors" : @[[UIColor orangeColor]]};
        model.exData = dict;
    }];
    

    [chartLineView setNeedsRendering];
    
    return contentView;
}


- (UIView *)twoChartLinViewWithFrame:(CGRect)frame {
    
    UIView *contentView = [[UIView alloc] initWithFrame:frame];
    contentView.backgroundColor = UIColor.whiteColor;
    contentView.layer.cornerRadius = 5;
    contentView.layer.borderWidth = 1.0;
    contentView.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
    contentView.clipsToBounds = NO;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(frame) - 20, 25)];
    titleLabel.text = @"多国家数据趋势对比图";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = UIColor.darkTextColor;
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
    
    NSArray<UIColor *> *colorArray = @[UIColor.redColor, UIColor.greenColor, UIColor.purpleColor, UIColor.orangeColor, UIColor.blueColor, UIColor.cyanColor, UIColor.yellowColor, UIColor.brownColor];
    NSArray<NSString *> *countrys = @[@"美国", @"英国", @"意大利", @"韩国",  @"日本", @"法国", @"德国", @"巴西"];
    
    UIView *lastView = nil;
    for (NSString *country in countrys) {
        NSInteger index = [countrys indexOfObject:country];
        UIView *countryView = typeView(colorArray[index], country);
        countryView.left = lastView ? lastView.right + 5 : 10;
        countryView.top = titleLabel.bottom + 5;
        [contentView addSubview:countryView];
        lastView = countryView;
    }
    
    HyChartLineView *chartLineView =  [[HyChartLineView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lastView.frame) + 15, CGRectGetWidth(titleLabel.frame), CGRectGetHeight(frame) - CGRectGetMaxY(lastView.frame) - 25)];
    [contentView addSubview:chartLineView];
    
    chartLineView.contentEdgeInsets = UIEdgeInsetsMake(0, 35, 35, 10);
    chartLineView.pinchGestureDisabled = YES;
    
    // 自定义游标
    HyChartsLineDemoCursor *cursor = HyChartsLineDemoCursor.new;
    cursor.showView = chartLineView;
    [chartLineView resetChartCursor:cursor];
    
    // 配置坐标轴
    [[chartLineView.dataSource.axisDataSource configXAxisWithModel:^(id<HyChartXAxisModelProtocol>  _Nonnull xAxisModel) {
        xAxisModel.topXaxisDisabled = NO;
        [[[[xAxisModel configNumberOfIndexs:10] configAxisGridLineInfo:^(id<HyChartAxisGridLineInfoProtocol>  _Nonnull axisGridLineInfo) {
            axisGridLineInfo.axisGridLineType = HyChartAxisLineTypeNone;
        }] configBottomXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
            xAxisInfo.rotateAngle = - M_PI_4;
            xAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
            xAxisInfo.axisLineWidth = .5;
            xAxisInfo.displayAxisZeroText = NO;
        }] configTopXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
            xAxisInfo.autoSetText = NO;
            xAxisInfo.axisLineWidth = 1;
            xAxisInfo.axisLineColor = UIColor.groupTableViewBackgroundColor;
        }];
    }] configYAxisWithModel:^(id<HyChartYAxisModelProtocol>  _Nonnull yAxisModel) {
        
        [[[[[yAxisModel configNumberOfIndexs:5] configYAxisMaxValue:^NSNumber * _Nonnull{
            return @10000;
        }] configAxisGridLineInfo:^(id<HyChartAxisGridLineInfoProtocol>  _Nonnull axisGridLineInfo) {
            axisGridLineInfo.axisGridLineColor = UIColor.groupTableViewBackgroundColor;
            axisGridLineInfo.axisGridLineWidth = .5;
        }] configLeftYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
            yAxisInfo.axisTextColor = UIColor.grayColor;
            yAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
            yAxisInfo.axisTextPosition = HyChartAxisTextPositionBinus;
            yAxisInfo.axisLineType = HyChartAxisLineTypeNone;
            yAxisInfo.displayAxisZeroText = NO;
        }] configYAxisMinValue:^NSNumber * _Nonnull{
            return @(0);
        }];
    }];
    
    // 配置图表信息
    [chartLineView.dataSource.configreDataSource configConfigure:^(id<HyChartLineConfigureProtocol>  _Nonnull configure) {
        configure.width = 0;
        configure.autoMargin = YES;
        [configure configLineConfigureAtIndex:^(NSInteger index, id<HyChartLineOneConfigureProtocol>  _Nonnull oneConfigure) {
            
            oneConfigure.lineWidth = 2;
            oneConfigure.lineColor = colorArray[index];
            oneConfigure.lineType = HyChartLineTypeCurve;
//            oneConfigure.lineType = HyChartLineTypeStraight;
            
            oneConfigure.linePointWidth = .5;
            oneConfigure.linePointSize = CGSizeMake(5, 5);
            oneConfigure.linePointType = HyChartLinePointTypeRing;
//            oneConfigure.linePointType = HyChartLinePointTypeCircel;
            oneConfigure.linePointFillColor = UIColor.whiteColor;
        }];
    }];
    

    NSArray<NSString *> *titles = @[@"03-08", @"03-09", @"03-10", @"03-11", @"03-12", @"03-13", @"03-14", @"03-18", @"03-19"];
    NSMutableArray<NSArray<NSNumber *> *> *values = @[].mutableCopy;
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray<NSNumber *> *vals = @[].mutableCopy;
        [countrys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
            [vals addObject:@((int)(arc4random() % (5000) + 500 * idx + 300))];
        }];
        [values addObject:vals];
    }];
    
    // 配置数据
    [[chartLineView.dataSource.modelDataSource configNumberOfItems:^NSInteger{
        return values.count;
    }] configModelForItemAtIndex:^(id<HyChartLineModelProtocol>  _Nonnull model, NSInteger index) {
        model.text = titles[index];
        model.values = values[index];
        // 自定义数据
        NSDictionary *dict = @{@"colors" : colorArray, @"texts" : countrys};
        model.exData = dict;
    }];
    
    [chartLineView setNeedsRendering];
    
    return contentView;
}

- (UIView *)threeChartLineViewWithFrame:(CGRect)frame {
    
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
        [[[[yAxisModel configNumberOfIndexs:5] configLeftYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
            yAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
            yAxisInfo.axisTextPosition = HyChartAxisTextPositionBinus;
            yAxisInfo.displayAxisZeroText = NO;
        }] configRightYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
            yAxisInfo.autoSetText = NO;
        }] configYAxisMinValue:^NSNumber * _Nonnull{
            return @(0);
        }];
    }];
    
    // 配置图表信息
    [chartLineView.dataSource.configreDataSource configConfigure:^(id<HyChartLineConfigureProtocol>  _Nonnull configure) {
        configure.width = 0;
        configure.margin = 20;
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

    return contentView;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end
