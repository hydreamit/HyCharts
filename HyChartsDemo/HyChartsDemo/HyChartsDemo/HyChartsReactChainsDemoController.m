//
//  HyChartsReactChainsDemoController.m
//  HyChartsDemo
//
//  Created by Hy on 2018/4/20.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartsReactChainsDemoController.h"
#import "HyChartsBarDemoCursor.h"
#import "HyChartsLineDemoCursor.h"
#import <HyCategoriess/HyCategories.h>
#import <HyCycleView/HySegmentView.h>
#import "HyCharts.h"


@interface HyChartsReactChainsDemoController ()

@property (nonatomic,strong) HySegmentView *segmentView;
@property (nonatomic,strong) HySegmentView *technicalSegmentView;
@property (nonatomic,strong) HySegmentView *auxiliarySegmentView;
@property (nonatomic,strong) HyChartKLineMainView *klineMainView;
@property (nonatomic,strong) HyChartKLineVolumeView *volumeView;
@property (nonatomic,strong) HyChartKLineAuxiliaryView *auxiliaryView;

@property (nonatomic,strong) HyChartBarView *chartsBarView;
@property (nonatomic,strong) HyChartLineView *chartsLineView;
@end

@implementation HyChartsReactChainsDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    backV.backgroundColor = UIColor.blackColor;
    [scrollView insertSubview:backV atIndex:0];

    
    [scrollView addSubview:self.segmentView];
    [scrollView addSubview:self.technicalSegmentView];
    [scrollView addSubview:self.auxiliarySegmentView];
    [scrollView addSubview:self.klineMainView];
    [scrollView addSubview:self.volumeView];
    [scrollView addSubview:self.auxiliaryView];
    
    UIView *chartBarView =  [self threeChartBarViewWithFrame:CGRectMake(10, CGRectGetMaxY(self.auxiliaryView.frame) + 30, CGRectGetWidth(self.view.bounds) - 20, 220)];
    [scrollView addSubview:chartBarView];
    
    UIView *chartLineView =  [self threeChartLineViewWithFrame:CGRectMake(10, CGRectGetMaxY(chartBarView.frame) + 10, CGRectGetWidth(self.view.bounds) - 20, 220)];
    [scrollView addSubview:chartLineView];
    
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(chartLineView.frame) + 50);
    
    // 添加联动图表
    HyChartView.addReactChains(@[self.klineMainView, self.volumeView, self.auxiliaryView]);
    HyChartView.addReactChains(@[self.chartsBarView, self.chartsLineView]);

    
    [self requestDataWithType:@"201"];
}

- (void)requestDataWithType:(NSString *)type {
    
    __weak typeof(self) _self = self;
    
    NSString *string = [NSString stringWithFormat:@"https://api.idcs.io:8323/api/LineData/GetLineData?TradingConfigId=_DSQ3BmslE-cS-HP3POlnA&LineType=%@&PageIndex=1&PageSize=400&ClientType=2&LanguageCode=zh-CN", type];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.center = CGPointMake(self.klineMainView.width / 2, self.klineMainView.height / 2);
    [self.klineMainView addSubview:indicatorView];
    [indicatorView startAnimating];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    [[session dataTaskWithURL:[NSURL URLWithString:string] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        if (!error) {
            
            __strong typeof(_self) self = _self;
            NSDictionary *successObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *array = successObject[@"Data"];
            
            NSInteger (^itemsBlock)(void) = ^NSInteger {
                return array.count;
            };
            
            void (^ItemAtIndexBlock)(id<HyChartKLineModelProtocol>, NSInteger) =
            ^(id<HyChartKLineModelProtocol>  _Nonnull model, NSInteger index){
                
                NSDictionary *dict = array[index];
                model.closePrice = [NSNumber numberWithFloat:[dict[@"Closed"] floatValue]];
                model.openPrice = [NSNumber numberWithFloat:[dict[@"Opened"] floatValue]];
                model.highPrice = [NSNumber numberWithFloat:[dict[@"Highest"] floatValue]];
                model.lowPrice = [NSNumber numberWithFloat:[dict[@"Lowest"] floatValue]];
                model.volume = [NSNumber numberWithFloat:[dict[@"DNum"] floatValue]];

                time_t timeInterval = [dict[@"Timestamp"] doubleValue];
                struct tm *cTime = localtime(&timeInterval);
                NSString *string = [NSString stringWithFormat:@"%02d-%02d %02d:%02d", cTime->tm_mon + 1, cTime->tm_mday, cTime->tm_hour, cTime->tm_min];
                model.text = string;
                
            };
            
            [[self.klineMainView.dataSource.modelDataSource configNumberOfItems:itemsBlock] configModelForItemAtIndex:ItemAtIndexBlock];
            
            [[self.volumeView.dataSource.modelDataSource configNumberOfItems:itemsBlock] configModelForItemAtIndex:ItemAtIndexBlock];
            
            [[self.auxiliaryView.dataSource.modelDataSource configNumberOfItems:itemsBlock] configModelForItemAtIndex:ItemAtIndexBlock];
         
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [indicatorView stopAnimating];
                [indicatorView removeFromSuperview];
                self.klineMainView.timeLine = [type isEqualToString:@"101"];
                [self.klineMainView setNeedsRendering];
                [self.volumeView setNeedsRendering];
                [self.auxiliaryView setNeedsRendering];
            });
        }
    }] resume];
}

- (HySegmentView *)segmentView {
    if (!_segmentView){

        NSArray<NSString *> *titleArray = @[@"Time", @"M5", @"M15", @"M30", @"H1", @"D1", @"W1", @"MN"];
        NSArray<NSString *> *typeArray = @[@"101", @"102", @"103", @"104", @"201", @"301", @"310", @"401"];
        __weak typeof(self) _self = self;
        _segmentView =
        [HySegmentView segmentViewWithFrame:CGRectMake(0, 0, self.view.width, 40)
                             configureBlock:^(HySegmentViewConfigure * _Nonnull configure) {
                        
            configure
            .numberOfItems(titleArray.count)
            .startIndex(4)
            .insetAndMarginRatio(.65)
            .viewForItemAtIndex(^UIView *(UIView *currentView,
                                          NSInteger currentIndex,
                                          CGFloat progress,
                                          HySegmentViewItemPosition position,
                                          NSArray<UIView *> *animationViews){

                UILabel *label = (UILabel *)currentView;
                if (!label) {
                    label = [UILabel new];
                    label.text = titleArray[currentIndex];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = UIColor.whiteColor;
                    label.font = [UIFont systemFontOfSize:15];
                    [label sizeToFit];
                    label.width += 10;
                }
                if (progress == 0 || progress == 1) {
                    label.textColor =  progress == 0 ? [UIColor hy_colorWithHexString:@"#3A5775"] : UIColor.whiteColor;
                }
                return label;
            })
            .animationViews(^NSArray<UIView *> *(NSArray<UIView *> *currentAnimations, UICollectionViewCell *fromCell, UICollectionViewCell *toCell, NSInteger fromIndex, NSInteger toIndex, CGFloat progress){
                
                NSArray<UIView *> *array = currentAnimations;
                
                if (!array.count) {
                    UIView *view = [UIView new];
                    view.backgroundColor = [UIColor hy_colorWithHexString:@"#2E7FD0"];
                    view.layer.cornerRadius = 1;
                    view.heightValue(24).topValue(8);
                    view.layer.cornerRadius = view.height / 2;
                    array = @[view];
                }
                
                CGFloat margin = toCell.centerX - fromCell.centerX;
                CGFloat widthMargin = (toCell.width - fromCell.width);
                array.firstObject
                .widthValue(fromCell.width + 15  + widthMargin * progress)
                .centerXValue(fromCell.centerX + margin * progress);
  
                return array;
            })
            .clickItemAtIndex(^BOOL(NSInteger currentIndex, BOOL isRepeat){
                 __weak typeof(_self) self = _self;
                if (!isRepeat) {
                    [self requestDataWithType:typeArray[currentIndex]];
                }
                return YES;
            });
        }];
        _segmentView.backgroundColor = [UIColor colorWithRed:14.0 / 255 green:33.0 / 255 blue:60.0 / 255 alpha:1];
    }
    return _segmentView;
}

- (HySegmentView *)technicalSegmentView {
    if (!_technicalSegmentView){

        NSArray<NSString *> *titleArray = @[@"MA", @"EMA", @"BOLL"];
        __weak typeof(self) _self = self;
        _technicalSegmentView =
        [HySegmentView segmentViewWithFrame:CGRectMake(0, self.segmentView.bottom + 1, self.view.width, 40)
                             configureBlock:^(HySegmentViewConfigure * _Nonnull configure) {
                        
            configure
            .numberOfItems(titleArray.count)
            .itemMargin(20)
            .viewForItemAtIndex(^UIView *(UIView *currentView,
                                          NSInteger currentIndex,
                                          CGFloat progress,
                                          HySegmentViewItemPosition position,
                                          NSArray<UIView *> *animationViews){

                UILabel *label = (UILabel *)currentView;
                if (!label) {
                    label = [UILabel new];
                    label.text = titleArray[currentIndex];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = UIColor.whiteColor;
                    label.font = [UIFont systemFontOfSize:15];
                    [label sizeToFit];
                    label.width += 10;
                }
                if (progress == 0 || progress == 1) {
                    label.textColor =  progress == 0 ? [UIColor hy_colorWithHexString:@"#3A5775"] : UIColor.whiteColor;
                }
                return label;
            })
            .animationViews(^NSArray<UIView *> *(NSArray<UIView *> *currentAnimations, UICollectionViewCell *fromCell, UICollectionViewCell *toCell, NSInteger fromIndex, NSInteger toIndex, CGFloat progress){
                
                NSArray<UIView *> *array = currentAnimations;
                
                if (!array.count) {
                    UIView *view = [UIView new];
                    view.backgroundColor = [UIColor hy_colorWithHexString:@"#2E7FD0"];
                    view.layer.cornerRadius = 1;
                    view.heightValue(24).topValue(8);
                    view.layer.cornerRadius = view.height / 2;
                    array = @[view];
                }
                
                CGFloat margin = toCell.centerX - fromCell.centerX;
                CGFloat widthMargin = (toCell.width - fromCell.width);
                array.firstObject
                .widthValue(fromCell.width + 15  + widthMargin * progress)
                .centerXValue(fromCell.centerX + margin * progress);
  
                return array;
            })
            .clickItemAtIndex(^BOOL(NSInteger currentIndex, BOOL isRepeat){
                 __weak typeof(_self) self = _self;
                if (!isRepeat) {
                    [self.klineMainView switchKLineTechnicalType:currentIndex + 1];
                }
                return YES;
            });
        }];
        _technicalSegmentView.backgroundColor = [UIColor colorWithRed:14.0 / 255 green:33.0 / 255 blue:60.0 / 255 alpha:1];
    }
    return _technicalSegmentView;
}

- (HySegmentView *)auxiliarySegmentView {
    if (!_auxiliarySegmentView){
        
        NSArray<NSString *> *titleArray = @[@"MCAD", @"KDJ", @"RSI"];
        __weak typeof(self) _self = self;
        _auxiliarySegmentView =
        [HySegmentView segmentViewWithFrame:CGRectMake(0, self.technicalSegmentView.bottom + 1, self.view.width, 40)
                             configureBlock:^(HySegmentViewConfigure * _Nonnull configure) {
                        
            configure
            .numberOfItems(titleArray.count)
            .itemMargin(20)
            .viewForItemAtIndex(^UIView *(UIView *currentView,
                                          NSInteger currentIndex,
                                          CGFloat progress,
                                          HySegmentViewItemPosition position,
                                          NSArray<UIView *> *animationViews){

                UILabel *label = (UILabel *)currentView;
                if (!label) {
                    label = [UILabel new];
                    label.text = titleArray[currentIndex];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = UIColor.whiteColor;
                    label.font = [UIFont systemFontOfSize:15];
                    [label sizeToFit];
                    label.width += 10;
                }
                if (progress == 0 || progress == 1) {
                    label.textColor =  progress == 0 ? [UIColor hy_colorWithHexString:@"#3A5775"] : UIColor.whiteColor;
                }
                return label;
            })
            .animationViews(^NSArray<UIView *> *(NSArray<UIView *> *currentAnimations, UICollectionViewCell *fromCell, UICollectionViewCell *toCell, NSInteger fromIndex, NSInteger toIndex, CGFloat progress){
                
                NSArray<UIView *> *array = currentAnimations;
                
                if (!array.count) {
                    UIView *view = [UIView new];
                    view.backgroundColor = [UIColor hy_colorWithHexString:@"#2E7FD0"];
                    view.layer.cornerRadius = 1;
                    view.heightValue(24).topValue(8);
                    view.layer.cornerRadius = view.height / 2;
                    array = @[view];
                }
                
                CGFloat margin = toCell.centerX - fromCell.centerX;
                CGFloat widthMargin = (toCell.width - fromCell.width);
                array.firstObject
                .widthValue(fromCell.width + 15  + widthMargin * progress)
                .centerXValue(fromCell.centerX + margin * progress);
  
                return array;
            })
            .clickItemAtIndex(^BOOL(NSInteger currentIndex, BOOL isRepeat){
                 __weak typeof(_self) self = _self;
                if (!isRepeat) {
                    [self.auxiliaryView switchKLineAuxiliaryType:currentIndex];
                }
                return YES;
            });
        }];
        _auxiliarySegmentView.backgroundColor = [UIColor colorWithRed:14.0 / 255 green:33.0 / 255 blue:60.0 / 255 alpha:1];
    }
    return _auxiliarySegmentView;
}

- (HyChartKLineMainView *)klineMainView {
    if (!_klineMainView){
        
        _klineMainView = HyChartKLineMainView.new;
        _klineMainView.frame = CGRectMake(0, self.auxiliarySegmentView.bottom + 2, self.view.bounds.size.width, self.view.bounds.size.width * 0.8);
        _klineMainView.backgroundColor = [UIColor colorWithRed:14.0 / 255 green:33.0 / 255 blue:60.0 / 255 alpha:1];
        
        // 配置坐标轴
        [[_klineMainView.dataSource.axisDataSource configXAxisWithModel:^(id<HyChartXAxisModelProtocol>  _Nonnull xAxisModel) {
            xAxisModel.topXaxisDisabled = NO;
            [[[[xAxisModel configNumberOfIndexs:4] configBottomXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
                xAxisInfo.autoSetText = NO;
                xAxisInfo.axisLineColor = [UIColor colorWithWhite:1 alpha:.25];
                xAxisInfo.axisLineWidth = 1.0;
            }] configAxisGridLineInfo:^(id<HyChartAxisGridLineInfoProtocol>  _Nonnull axisGridLineModel) {
                axisGridLineModel.axisGridLineColor = [UIColor colorWithWhite:1 alpha:.25];
            }] configTopXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
                xAxisInfo.autoSetText = NO;
                xAxisInfo.axisLineColor = [UIColor colorWithWhite:1 alpha:.25];
            }];
            
        }] configYAxisWithModel:^(id<HyChartYAxisModelProtocol>  _Nonnull yAxisModel) {
            yAxisModel.yAxisMaxValueExtraPrecent = @(0.1);
            yAxisModel.yAxisMinValueExtraPrecent = @(0.1);
            yAxisModel.rightYAaxisDisabled = NO;
            [[[[yAxisModel configNumberOfIndexs:4] configLeftYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
                yAxisInfo.axisLineColor = [UIColor colorWithWhite:1 alpha:.25];
                yAxisInfo.autoSetText = NO;
            }] configAxisGridLineInfo:^(id<HyChartAxisGridLineInfoProtocol>  _Nonnull axisGridLineModel) {
                axisGridLineModel.axisGridLineColor = [UIColor colorWithWhite:1 alpha:.25];
            }] configRightYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
                yAxisInfo.axisLineColor = [UIColor colorWithWhite:1 alpha:.25];
                yAxisInfo.axisTextColor = UIColor.whiteColor;
                yAxisInfo.axisTextPosition = HyChartAxisTextPositionBinus;
            }];
        }];
        
        // 配置图表信息
        [_klineMainView.dataSource.configreDataSource configConfigure:^(id<HyChartKLineConfigureProtocol>  _Nonnull configure) {
            
            configure.width = 6;
            configure.margin = 3;
            configure.edgeInsetStart = 3;
            configure.edgeInsetEnd = 3;
            configure.trendUpColor = [UIColor hy_colorWithHexString:@"#E97C5E"];
            configure.trendDownColor = [UIColor hy_colorWithHexString:@"#1ABD93"];
            configure.minScaleToLine = YES;
            configure.priceDecimal = 4;
//            configure.trendUpKlineType = HyChartKLineTypeStroke;
            
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
        
        [_klineMainView switchKLineTechnicalType:HyChartKLineTechnicalTypeSMA];
    }
    return _klineMainView;
}

- (HyChartKLineVolumeView *)volumeView {
    if (!_volumeView){
        _volumeView = HyChartKLineVolumeView.new;
        _volumeView.frame = CGRectMake(0, self.klineMainView.bottom , self.view.bounds.size.width, self.view.bounds.size.width * .25);
        _volumeView.backgroundColor = [UIColor colorWithRed:14.0 / 255 green:33.0 / 255 blue:60.0 / 255 alpha:1];
        
        // 配置坐标轴
        [[_volumeView.dataSource.axisDataSource configXAxisWithModel:^(id<HyChartXAxisModelProtocol>  _Nonnull xAxisModel) {
            [[[xAxisModel configNumberOfIndexs:4] configBottomXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
                xAxisInfo.autoSetText = NO;
                xAxisInfo.axisLineColor = [UIColor colorWithWhite:1 alpha:.25];
            }] configAxisGridLineInfo:^(id<HyChartAxisGridLineInfoProtocol>  _Nonnull axisGridLineModel) {
                axisGridLineModel.axisGridLineColor = [UIColor colorWithWhite:1 alpha:.25];
            }];
        }] configYAxisWithModel:^(id<HyChartYAxisModelProtocol>  _Nonnull yAxisModel) {
            yAxisModel.yAxisMaxValueExtraPrecent = @(0.1);
            yAxisModel.rightYAaxisDisabled = NO;
            [[[[yAxisModel configNumberOfIndexs:1] configLeftYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
                yAxisInfo.axisLineColor = [UIColor colorWithWhite:1 alpha:.25];
                yAxisInfo.autoSetText = NO;
            }] configAxisGridLineInfo:^(id<HyChartAxisGridLineInfoProtocol>  _Nonnull axisGridLineModel) {
                axisGridLineModel.axisGridLineColor = [UIColor colorWithWhite:1 alpha:.25];
            }] configRightYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
                yAxisInfo.axisLineColor = [UIColor colorWithWhite:1 alpha:.25];
                yAxisInfo.axisTextColor = UIColor.whiteColor;
                yAxisInfo.axisTextPosition = HyChartAxisTextPositionBinus;
            }];
        }];
        
        // 配置图表信息
        [_volumeView.dataSource.configreDataSource configConfigure:^(id<HyChartKLineConfigureProtocol>  _Nonnull configure) {
            
            configure.width = 6;
            configure.margin = 3;
            configure.edgeInsetStart = 3;
            configure.edgeInsetEnd = 3;
            configure.trendUpColor = [UIColor hy_colorWithHexString:@"#E97C5E"];
            configure.trendDownColor = [UIColor hy_colorWithHexString:@"#1ABD93"];
//            configure.trendUpKlineType = HyChartKLineTypeStroke;
            
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
        
        [_volumeView switchKLineTechnicalType:HyChartKLineTechnicalTypeSMA];
    }
    return _volumeView;
}

- (HyChartKLineAuxiliaryView *)auxiliaryView {
    if (!_auxiliaryView){
        _auxiliaryView = HyChartKLineAuxiliaryView.new;
        _auxiliaryView.frame = CGRectMake(0, self.volumeView.bottom, self.view.bounds.size.width, self.view.bounds.size.width * .25 + 20);
        _auxiliaryView.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
        _auxiliaryView.backgroundColor = [UIColor colorWithRed:14.0 / 255 green:33.0 / 255 blue:60.0 / 255 alpha:1];
        
        // 配置坐标轴
        [[_auxiliaryView.dataSource.axisDataSource configXAxisWithModel:^(id<HyChartXAxisModelProtocol>  _Nonnull xAxisModel) {
            [[[xAxisModel configNumberOfIndexs:4] configBottomXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
                xAxisInfo.axisLineColor = [UIColor colorWithWhite:1 alpha:.25];
                xAxisInfo.axisTextColor = [UIColor hy_colorWithHexString:@"#3A5775"];
            }] configAxisGridLineInfo:^(id<HyChartAxisGridLineInfoProtocol>  _Nonnull axisGridLineModel) {
                axisGridLineModel.axisGridLineColor = [UIColor colorWithWhite:1 alpha:.25];
            }];
        }] configYAxisWithModel:^(id<HyChartYAxisModelProtocol>  _Nonnull yAxisModel) {
            yAxisModel.yAxisMaxValueExtraPrecent = @(0.1);
            yAxisModel.yAxisMinValueExtraPrecent = @(0.1);
            yAxisModel.rightYAaxisDisabled = NO;
            [[[[yAxisModel configNumberOfIndexs:1] configLeftYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
                yAxisInfo.axisLineColor = [UIColor colorWithWhite:1 alpha:.25];
                yAxisInfo.autoSetText = NO;
            }] configAxisGridLineInfo:^(id<HyChartAxisGridLineInfoProtocol>  _Nonnull axisGridLineModel) {
                axisGridLineModel.axisGridLineColor = [UIColor colorWithWhite:1 alpha:.25];
            }] configRightYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
                yAxisInfo.axisLineColor = [UIColor colorWithWhite:1 alpha:.25];
                yAxisInfo.axisTextColor = UIColor.whiteColor;
                yAxisInfo.axisTextPosition = HyChartAxisTextPositionBinus;
            }];
        }];
        
        // 配置图表信息
       [_auxiliaryView.dataSource.configreDataSource configConfigure:^(id<HyChartKLineConfigureProtocol>  _Nonnull configure) {
           
            configure.width = 6;
            configure.margin = 3;
            configure.edgeInsetStart = 3;
            configure.edgeInsetEnd = 3;
            configure.trendUpColor = [UIColor hy_colorWithHexString:@"#E97C5E"];
            configure.trendDownColor = [UIColor hy_colorWithHexString:@"#1ABD93"];
//            configure.trendUpKlineType = HyChartKLineTypeStroke;
           
            configure.macdDict = @{@[@12, @26, @9] : @[UIColor.orangeColor, UIColor.blueColor, [UIColor hy_colorWithHexString:@"#E97C5E"], [UIColor hy_colorWithHexString:@"#1ABD93"]]};
            configure.kdjDict = @{@[@9, @3, @3] : @[UIColor.orangeColor, UIColor.blueColor, UIColor.redColor]};
            configure.rsiDict = @{@6 : UIColor.orangeColor};
        }];
    }
    return _auxiliaryView;
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
    
    self.chartsBarView = chartBarView;
    
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
        [[[yAxisModel configNumberOfIndexs:5] configLeftYAxisInfo:^(id<HyChartYAxisInfoProtocol>  _Nonnull yAxisInfo) {
            yAxisInfo.axisTextFont = [UIFont systemFontOfSize:10];
            yAxisInfo.axisTextPosition = HyChartAxisTextPositionBinus;
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
    
    self.chartsLineView = chartLineView;

    return contentView;
}

@end
