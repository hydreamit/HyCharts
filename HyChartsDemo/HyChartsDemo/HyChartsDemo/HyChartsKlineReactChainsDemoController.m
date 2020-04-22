//
//  HyChartsKlineReactChainsDemoController.m
//  HyChartsDemo
//
//  Created by Hy on 2018/4/22.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartsKlineReactChainsDemoController.h"
#import "HyChartsBarDemoCursor.h"
#import "HyChartsLineDemoCursor.h"
#import <HyCategoriess/HyCategories.h>
#import <HyCycleView/HySegmentView.h>
#import "HyCharts.h"
#import "HyChartsKLineDemoDataHandler.h"


@interface HyChartsKlineReactChainsDemoController ()
@property (nonatomic, strong) HyChartKLineMainView *klineMainView;
@property (nonatomic, strong) HyChartKLineVolumeView *volumeView;
@property (nonatomic, strong) HyChartKLineAuxiliaryView *auxiliaryView;
@property (nonatomic, strong) HyChartBarView *chartsBarView;
@property (nonatomic, strong) HyChartLineView *chartsLineView;

@property (nonatomic,strong) UIView *klineMainlTechnicView;
@property (nonatomic,strong) UIView *klineVolumTechnicView;
@property (nonatomic,strong) UIView *klineAuxiliaryView;
@property (nonatomic,strong) UIView *klineContentView;
@end


@implementation HyChartsKlineReactChainsDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    
    
    self.klineMainlTechnicView = UIView.new;
    self.klineMainlTechnicView.frame = CGRectMake(5, 10, self.view.width - 10, 15);
    [scrollView addSubview:self.klineMainlTechnicView];
    
    
    UIView *klineContentView = UIView.new;
    klineContentView.backgroundColor = UIColor.whiteColor;
    klineContentView.frame = CGRectMake(5, self.klineMainlTechnicView.bottom, self.view.width - 10, self.view.width * (0.6 + 0.25 + 0.25) + 30 + 20);
    [scrollView addSubview:klineContentView];
    self.klineContentView = klineContentView;
    
    [klineContentView addSubview:self.klineMainView];
    [klineContentView addSubview:self.volumeView];
    [klineContentView addSubview:self.auxiliaryView];
    HyChartView.addReactChains(@[self.klineMainView, self.volumeView, self.auxiliaryView]);
    
    self.klineVolumTechnicView = UIView.new;
    self.klineVolumTechnicView.top = self.klineMainView.bottom;
    [klineContentView addSubview:self.klineVolumTechnicView];
   
    self.klineAuxiliaryView = UIView.new;
    self.klineAuxiliaryView.top = self.volumeView.bottom;
    [klineContentView addSubview:self.klineAuxiliaryView];
    
    [self requestDataWithType:@"201"];
}

- (void)requestDataWithType:(NSString *)type {
    
    __weak typeof(self) _self = self;
    
    NSString *string = [NSString stringWithFormat:@"https://api.idcs.io:8323/api/LineData/GetLineData?TradingConfigId=_DSQ3BmslE-cS-HP3POlnA&LineType=%@&PageIndex=1&PageSize=400&ClientType=2&LanguageCode=zh-CN", type];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.center = CGPointMake(self.klineContentView.width / 2, self.klineContentView.height / 2);
    [self.klineContentView addSubview:indicatorView];
    [indicatorView startAnimating];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    [[session dataTaskWithURL:[NSURL URLWithString:string] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        if (!error) {
            __strong typeof(_self) self = _self;
            NSDictionary *successObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [HyChartsKLineDemoDataHandler handleWithArray:successObject[@"Data"] dataSorce:self.klineMainView.dataSource];
            [HyChartsKLineDemoDataHandler handleWithArray:successObject[@"Data"] dataSorce:self.volumeView.dataSource];
            [HyChartsKLineDemoDataHandler handleWithArray:successObject[@"Data"] dataSorce:self.auxiliaryView.dataSource];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [indicatorView stopAnimating];
                [indicatorView removeFromSuperview];
                self.klineMainView.timeLine = [type isEqualToString:@"101"];
                [self.klineMainView setNeedsRendering];
                [self.volumeView setNeedsRendering];
                [self.auxiliaryView setNeedsRendering];
                
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   
                    CALayer *klineMainlTechnicalayer = [HyChartsKLineDemoDataHandler technicalLayerWithDataSorce:self.klineMainView.dataSource];
                    [self.klineMainlTechnicView.layer addSublayer:klineMainlTechnicalayer];

                    CALayer *klineVolumTechnicalayer = [HyChartsKLineDemoDataHandler volumTechnicalLayerWithDataSorce:self.volumeView.dataSource];
                    [self.klineVolumTechnicView.layer addSublayer:klineVolumTechnicalayer];

                   CALayer *klineAuxiliarylayer = [HyChartsKLineDemoDataHandler auxiliaryLayerWithDataSorce:self.auxiliaryView.dataSource];
                   [self.klineAuxiliaryView.layer addSublayer:klineAuxiliarylayer];
                });
            });
        }
    }] resume];
}

- (HyChartKLineMainView *)klineMainView {
    if (!_klineMainView){
        
        _klineMainView = HyChartKLineMainView.new;
        _klineMainView.frame = CGRectMake(0, 0, self.view.bounds.size.width - 10, self.view.bounds.size.width * .6);
        _klineMainView.backgroundColor = UIColor.whiteColor;
        
        // 配置坐标轴
        [[_klineMainView.dataSource.axisDataSource configXAxisWithModel:^(id<HyChartXAxisModelProtocol>  _Nonnull xAxisModel) {
            xAxisModel.topXaxisDisabled = NO;
            [[[xAxisModel configNumberOfIndexs:4] configBottomXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
                xAxisInfo.autoSetText = NO;
            }] configTopXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
                xAxisInfo.autoSetText = NO;
            }];
        }] configYAxisWithModel:^(id<HyChartYAxisModelProtocol>  _Nonnull yAxisModel) {
            yAxisModel.yAxisMaxValueExtraPrecent = @(0.12);
            yAxisModel.yAxisMinValueExtraPrecent = @(0.12);
            yAxisModel.rightYAaxisDisabled = NO;
            [[[yAxisModel configNumberOfIndexs:4] configLeftYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
                yAxisInfo.axisTextColor = [UIColor darkTextColor];
                yAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
            }] configRightYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
                yAxisInfo.autoSetText = NO;
            }];
        }];
        
        __weak typeof(self) _self = self;
        // 配置图表信息
        [_klineMainView.dataSource.configreDataSource configConfigure:^(id<HyChartKLineConfigureProtocol>  _Nonnull configure) {
            
            __strong typeof(_self) self = _self;
            
            [self configConfigure:configure];
            
            configure.minScaleToLine = YES;
            
            configure.newpriceColor = UIColor.darkTextColor;
            configure.newpriceFont = [UIFont systemFontOfSize:8];
            configure.maxminPriceColor = UIColor.darkTextColor;
            configure.maxminPriceFont = [UIFont systemFontOfSize:8];
            configure.trendUpKlineType = HyChartKLineTypeStroke;
            
            UIColor *lineColor =   Hy_ColorWithRGBA(46, 127, 208, 1);
            NSArray<UIColor *> *colors = @[Hy_ColorWithRGBA(46, 127, 208, .2),
                                           Hy_ColorWithRGBA(46, 127, 208, .1),
                                           Hy_ColorWithRGBA(46, 127, 208, .05)];
            
            configure.timeLineColor =
            configure.minScaleLineColor = lineColor;
            
            configure.timeLineShadeColors =
            configure.minScaleLineShadeColors = colors;
            
            
            configure.smaDict = @{@(5)  : UIColor.yellowColor,
                                  @(10) : UIColor.orangeColor,
                                  @(30) : UIColor.purpleColor};
            
            configure.emaDict = @{@(5)  : UIColor.yellowColor,
                                  @(10) : UIColor.orangeColor,
                                  @(30) : UIColor.purpleColor};
            
            configure.bollDict = @{@"20" : @[UIColor.yellowColor,
                                             UIColor.orangeColor,
                                             UIColor.purpleColor]};
        }];
        _klineMainView.tapGestureDisabled = YES;
        _klineMainView.longPressGestureDisabled = YES;
        [_klineMainView switchKLineTechnicalType:HyChartKLineTechnicalTypeSMA];
    }
    return _klineMainView;
}

- (HyChartKLineVolumeView *)volumeView {
    if (!_volumeView){
        _volumeView = HyChartKLineVolumeView.new;
        _volumeView.frame = CGRectMake(0, self.klineMainView.bottom + 15 , self.view.bounds.size.width - 10, self.view.bounds.size.width * .25);
        _volumeView.backgroundColor = UIColor.whiteColor;
        
        // 配置坐标轴
        [[_volumeView.dataSource.axisDataSource configXAxisWithModel:^(id<HyChartXAxisModelProtocol>  _Nonnull xAxisModel) {
            
            xAxisModel.topXaxisDisabled = NO;
            [[[xAxisModel configNumberOfIndexs:4] configBottomXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
                xAxisInfo.autoSetText = NO;
            }] configTopXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
                xAxisInfo.autoSetText = NO;
            }];
            
        }] configYAxisWithModel:^(id<HyChartYAxisModelProtocol>  _Nonnull yAxisModel) {
            yAxisModel.yAxisMaxValueExtraPrecent = @(0.12);
            yAxisModel.rightYAaxisDisabled = NO;
            [[[yAxisModel configNumberOfIndexs:1] configLeftYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
                yAxisInfo.axisTextColor = [UIColor darkTextColor];
                yAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
                yAxisInfo.displayAxisZeroText = NO;
            }] configRightYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
                yAxisInfo.autoSetText = NO;
            }];
        }];
        
        __weak typeof(self) _self = self;
        
        // 配置图表信息
        [_volumeView.dataSource.configreDataSource configConfigure:^(id<HyChartKLineConfigureProtocol>  _Nonnull configure) {
            
            __strong typeof(_self) self = _self;
            
            [self configConfigure:configure];
                        
            configure.trendUpKlineType = HyChartKLineTypeStroke;
            
            configure.smaDict = @{@(5)  : UIColor.yellowColor,
                                  @(10) : UIColor.orangeColor,
                                  @(30) : UIColor.purpleColor};
            configure.emaDict = @{@(5)  : UIColor.yellowColor,
                                  @(10) : UIColor.orangeColor,
                                  @(30) : UIColor.purpleColor};
            
            configure.bollDict = @{@"20" : @[UIColor.yellowColor,
                                             UIColor.orangeColor,
                                             UIColor.purpleColor]};
        }];
        
        _volumeView.tapGestureDisabled = YES;
        _volumeView.longPressGestureDisabled = YES;
        [_volumeView switchKLineTechnicalType:HyChartKLineTechnicalTypeSMA];
    }
    return _volumeView;
}

- (HyChartKLineAuxiliaryView *)auxiliaryView {
    if (!_auxiliaryView){
        _auxiliaryView = HyChartKLineAuxiliaryView.new;
        _auxiliaryView.frame = CGRectMake(0, self.volumeView.bottom + 15, self.view.bounds.size.width - 10, self.view.bounds.size.width * .25 + 20);
        _auxiliaryView.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
        _auxiliaryView.backgroundColor = UIColor.whiteColor;
//        _auxiliaryView.backgroundColor = [UIColor colorWithRed:14.0 / 255 green:33.0 / 255 blue:60.0 / 255 alpha:1];
        
        // 配置坐标轴
        [[_auxiliaryView.dataSource.axisDataSource configXAxisWithModel:^(id<HyChartXAxisModelProtocol>  _Nonnull xAxisModel) {
            xAxisModel.topXaxisDisabled = NO;
            [[[xAxisModel configNumberOfIndexs:4] configBottomXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
                xAxisInfo.axisTextColor = [UIColor darkTextColor];
                xAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
            }] configTopXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
                xAxisInfo.autoSetText = NO;
            }];
        }] configYAxisWithModel:^(id<HyChartYAxisModelProtocol>  _Nonnull yAxisModel) {
            yAxisModel.yAxisMaxValueExtraPrecent = @(0.12);
            yAxisModel.yAxisMinValueExtraPrecent = @(0.12);
            yAxisModel.rightYAaxisDisabled = NO;
            [[[yAxisModel configNumberOfIndexs:1] configLeftYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
                yAxisInfo.axisTextColor = [UIColor darkTextColor];
                yAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
                yAxisInfo.displayAxisZeroText = NO;
            }] configRightYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
                yAxisInfo.autoSetText = NO;
            }];
        }];
        
        __weak typeof(self) _self = self;
        
        // 配置图表信息
       [_auxiliaryView.dataSource.configreDataSource configConfigure:^(id<HyChartKLineConfigureProtocol>  _Nonnull configure) {
           
           __strong typeof(_self) self = _self;
           
           [self configConfigure:configure];
           configure.width = 2;
           configure.margin = 4;
           
            configure.macdDict = @{@[@12, @26, @9] : @[UIColor.orangeColor, UIColor.blueColor, [UIColor hy_colorWithHexString:@"#E97C5E"], [UIColor hy_colorWithHexString:@"#1ABD93"]]};
            configure.kdjDict = @{@[@9, @3, @3] : @[UIColor.orangeColor, UIColor.blueColor, UIColor.redColor]};
            configure.rsiDict = @{@6 : UIColor.orangeColor};
        }];
        _auxiliaryView.tapGestureDisabled = YES;
        _auxiliaryView.longPressGestureDisabled = YES;
    }
    return _auxiliaryView;
}

- (void)configConfigure:(id<HyChartKLineConfigureProtocol>)configure {
    configure.width = 4;
    configure.margin = 2;
    configure.edgeInsetStart = 2;
    configure.edgeInsetEnd = 2;
    configure.trendUpColor = [UIColor hy_colorWithHexString:@"#E97C5E"];
    configure.trendDownColor = [UIColor hy_colorWithHexString:@"#1ABD93"];
    configure.priceDecimal = 2;
    configure.volumeDecimal = 4;
}

@end
