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
#import "HyChartsKLineDemoCursor.h"



@interface HyChartsKlineReactChainsDemoController ()

@property (nonatomic, strong) HySegmentView *segmentView;
@property (nonatomic, strong) HyChartKLineMainView *klineMainView;
@property (nonatomic, strong) HyChartKLineVolumeView *volumeView;
@property (nonatomic, strong) HyChartKLineAuxiliaryView *auxiliaryView;
@property (nonatomic, strong) HyChartBarView *chartsBarView;
@property (nonatomic, strong) HyChartLineView *chartsLineView;

@property (nonatomic,strong) UIView *klineMainlTechnicView;
@property (nonatomic,strong) UIView *klineVolumTechnicView;
@property (nonatomic,strong) UIView *klineAuxiliaryView;
@property (nonatomic,strong) UIView *klineContentView;

@property (nonatomic,strong) HyChartsKLineDemoCursor *klineCursor;
@end



@implementation HyChartsKlineReactChainsDemoController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    
    
    [scrollView addSubview:self.segmentView];
    
    
    self.klineMainlTechnicView = UIView.new;
    self.klineMainlTechnicView.frame = CGRectMake(0, self.segmentView.bottom + 2, self.view.width, 15);
    [scrollView addSubview:self.klineMainlTechnicView];
    
    
    UIView *klineContentView = UIView.new;
    klineContentView.backgroundColor = UIColor.whiteColor;
    klineContentView.frame = CGRectMake(5, self.klineMainlTechnicView.bottom, self.view.width - 10, self.view.width * (0.6 + 0.25 + 0.25) + 30 + 10);
    [scrollView addSubview:klineContentView];
    self.klineContentView = klineContentView;
    
    [klineContentView addSubview:self.klineMainView];
    [klineContentView addSubview:self.volumeView];
    [klineContentView addSubview:self.auxiliaryView];
    // 添加图表联动
    HyChartView.addReactChains(@[self.klineMainView, self.volumeView, self.auxiliaryView]);
    
    self.klineVolumTechnicView = UIView.new;
    self.klineVolumTechnicView.left = -5;
    self.klineVolumTechnicView.top = self.klineMainView.bottom;
    [klineContentView addSubview:self.klineVolumTechnicView];
   
    self.klineAuxiliaryView = UIView.new;
    self.klineAuxiliaryView.left = -5;
    self.klineAuxiliaryView.top = self.volumeView.bottom;
    [klineContentView addSubview:self.klineAuxiliaryView];
    
    [self requestDataWithType:@"201"];
}

- (void)requestDataWithType:(NSString *)type {
    
    __weak typeof(self) _self = self;
    
    NSString *string = [NSString stringWithFormat:@"https://api.idcs.io:8323/api/LineData/GetLineData?TradingConfigId=_DSQ3BmslE-cS-HP3POlnA&LineType=%@&PageIndex=1&PageSize=400&ClientType=2&LanguageCode=zh-CN", type];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.color = UIColor.orangeColor;
    indicatorView.center = CGPointMake(self.klineContentView.width / 2, self.klineContentView.height / 2);
    [self.klineContentView addSubview:indicatorView];
    [indicatorView startAnimating];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    [[session dataTaskWithURL:[NSURL URLWithString:string] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        __strong typeof(_self) self = _self;
        if (!self) {return;}
        if (!error) {
            NSDictionary *successObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSArray *array = successObject[@"Data"];
//            array = [array objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 50)]];
            
            [HyChartsKLineDemoDataHandler handleWithArray:array dataSorce:self.klineMainView.dataSource];
            [HyChartsKLineDemoDataHandler handleWithArray:array dataSorce:self.volumeView.dataSource];
            [HyChartsKLineDemoDataHandler handleWithArray:array dataSorce:self.auxiliaryView.dataSource];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicatorView stopAnimating];
            [indicatorView removeFromSuperview];
            if (error) { return; }
            
            self.klineMainView.timeLine = [type isEqualToString:@"101"];
            [self.klineMainView setNeedsRendering];
            [self.volumeView setNeedsRendering];
            [self.auxiliaryView setNeedsRendering];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               
               [self.klineMainlTechnicView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
               [self.klineVolumTechnicView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
               [self.klineAuxiliaryView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
               
                CALayer *klineMainlTechnicalayer = [HyChartsKLineDemoDataHandler technicalLayerWithDataSorce:self.klineMainView.dataSource];
                [self.klineMainlTechnicView.layer addSublayer:klineMainlTechnicalayer];

                CALayer *klineVolumTechnicalayer = [HyChartsKLineDemoDataHandler volumTechnicalLayerWithDataSorce:self.volumeView.dataSource];
                [self.klineVolumTechnicView.layer addSublayer:klineVolumTechnicalayer];

               CALayer *klineAuxiliarylayer = [HyChartsKLineDemoDataHandler auxiliaryLayerWithDataSorce:self.auxiliaryView.dataSource];
               [self.klineAuxiliaryView.layer addSublayer:klineAuxiliarylayer];
            });
        });
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
            
            // 配置分时线
            configure.timeLineHandleTechnicalData = YES;
            [configure configLineConfigureAtIndex:^(NSInteger index, id<HyChartLineOneConfigureProtocol>  _Nonnull oneConfigure) {
                
                oneConfigure.lineColor = lineColor;
                oneConfigure.shadeColors = colors;
                
//                if (index == 0) {
//                    oneConfigure.lineColor = lineColor;
//                    oneConfigure.shadeColors = colors;
//                } else {
//                    oneConfigure.lineColor = UIColor.orangeColor;
//                    oneConfigure.disPlayNewvalue = NO;
//                    oneConfigure.disPlayMaxMinValue = NO;
////                    oneConfigure.shadeColors = colors;
//                }
               
            }];
            
            configure.minScaleLineColor = lineColor;
            configure.minScaleLineShadeColors = colors;
            
            configure.smaDict = @{@(5)  : Hy_ColorWithRGB(246, 164, 84),
                                  @(10) : Hy_ColorWithRGB(105, 140, 180),
                                  @(30) : Hy_ColorWithRGB(179, 90, 142)};
            
            configure.emaDict = @{@(5)  : Hy_ColorWithRGB(246, 164, 84),
                                  @(10) : Hy_ColorWithRGB(105, 140, 180),
                                  @(30) : Hy_ColorWithRGB(179, 90, 142)};
            
            configure.bollDict = @{@"20" : @[Hy_ColorWithRGB(246, 164, 84),
                                             Hy_ColorWithRGB(105, 140, 180),
                                             Hy_ColorWithRGB(179, 90, 142)]};
        }];

        self.klineCursor = HyChartsKLineDemoCursor.new;
        self.klineCursor.showView = self.klineContentView;
        [_klineMainView resetChartCursor:self.klineCursor];
        
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
            
            configure.smaDict = @{@(5)  : Hy_ColorWithRGB(246, 164, 84),
                                  @(10) : Hy_ColorWithRGB(105, 140, 180),
                                  @(30) : Hy_ColorWithRGB(179, 90, 142)};
            
            configure.emaDict = @{@(5)  : Hy_ColorWithRGB(246, 164, 84),
                                  @(10) : Hy_ColorWithRGB(105, 140, 180),
                                  @(30) : Hy_ColorWithRGB(179, 90, 142)};

        }];
        
//        _volumeView.tapGestureDisabled = YES;
        [_volumeView resetChartCursor:nil];
        _volumeView.tapGestureAction = ^(HyChartView * _Nonnull chartView, id<HyChartModelProtocol>  _Nonnull model, NSUInteger index, CGPoint point) {
            __strong typeof(_self) self = _self;
            [self.klineCursor dismiss];
        };
        _volumeView.longPressGestureDisabled = YES;
        [_volumeView switchKLineTechnicalType:HyChartKLineTechnicalTypeSMA];
    }
    return _volumeView;
}


- (HyChartKLineAuxiliaryView *)auxiliaryView {
    if (!_auxiliaryView){
        _auxiliaryView = HyChartKLineAuxiliaryView.new;
        _auxiliaryView.frame = CGRectMake(0, self.volumeView.bottom + 15, self.view.bounds.size.width - 10, self.view.bounds.size.width * .25 + 20);
        _auxiliaryView.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
        _auxiliaryView.backgroundColor = UIColor.whiteColor;
        
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
           
            configure.macdDict = @{@[@12, @26, @9] : @[Hy_ColorWithRGB(246, 164, 84), Hy_ColorWithRGB(165, 83, 127), Hy_ColorWithRGB(225, 82, 71), Hy_ColorWithRGB(79, 184, 126)]};
            configure.kdjDict = @{@[@9, @3, @3] : @[Hy_ColorWithRGB(246, 164, 84), Hy_ColorWithRGB(165, 83, 127), Hy_ColorWithRGB(105, 140, 180)]};
           configure.rsiDict = @{@6 : UIColor.orangeColor};
//            configure.rsiDict = @{@6 : UIColor.orangeColor, @12 : UIColor.redColor, @24 : UIColor.greenColor};
        }];
//        _auxiliaryView.tapGestureDisabled = YES;
        [_auxiliaryView resetChartCursor:nil];
        _auxiliaryView.tapGestureAction = ^(HyChartView * _Nonnull chartView, id<HyChartModelProtocol>  _Nonnull model, NSUInteger index, CGPoint point) {
            __strong typeof(_self) self = _self;
            [self.klineCursor dismiss];
        };
        _auxiliaryView.longPressGestureDisabled = YES;
        
    }
    return _auxiliaryView;
}

- (void)configConfigure:(id<HyChartKLineConfigureProtocol>)configure {
    configure.width = 4;
    configure.margin = 2;
    configure.edgeInsetStart = 2;
    configure.edgeInsetEnd = 2;
    configure.trendUpColor = Hy_ColorWithRGB(225, 82, 71);
    configure.trendDownColor = Hy_ColorWithRGB(79, 184, 126);
    configure.trendDownKlineType =
    configure.trendUpKlineType = HyChartKLineTypeFill;
    configure.priceDecimal = 2;
    configure.volumeDecimal = 4;
    configure.minScale = .5;
//    configure.renderingDirection = HyChartRenderingDirectionReverse;
//    configure.notEnoughSide = HyChartNotEnoughSideRight;
//    configure.lineWidth = .5;
//    configure.minScaleLineWidth = .5;
}

- (HySegmentView *)segmentView {
    if (!_segmentView){

        NSArray<NSString *> *titleArray = @[@"Time", @"M5", @"M15", @"M30", @"H1", @"D1", @"W1", @"MN"];
        NSArray<NSString *> *typeArray = @[@"101", @"102", @"103", @"104", @"201", @"301", @"310", @"401"];
        __weak typeof(self) _self = self;
        _segmentView =
        [self segmentViewWithFrame:CGRectMake(0, 0, self.view.width, 35)
                        titleArray:titleArray
                       clickAction:^(NSInteger currentIndex) {
             __weak typeof(_self) self = _self;
            [self requestDataWithType:typeArray[currentIndex]];
        }];
        
        UIView *line = UIView.new;
        line.backgroundColor = UIColor.groupTableViewBackgroundColor;
        line.frame = CGRectMake(0, _segmentView.height - 1, _segmentView.width, 1);
        [_segmentView addSubview:line];
    }
    return _segmentView;
}


- (HySegmentView *)segmentViewWithFrame:(CGRect)frame
                             titleArray:(NSArray<NSString *> *)titleArray
                                clickAction:(void(^)(NSInteger currentIndex))clickAction {
    NSInteger startIndex = titleArray.count > 3 ? 4 : 0;
    HySegmentView *segmentView =
    [HySegmentView segmentViewWithFrame:frame
                         configureBlock:^(HySegmentViewConfigure * _Nonnull configure) {
                          
              configure
              .numberOfItems(titleArray.count)
              .startIndex(startIndex)
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
                      label.font = [UIFont systemFontOfSize:15];
                      [label sizeToFit];
                  }
                  if (progress == 0 || progress == 1) {
                      label.textColor =  progress == 0 ?  UIColor.grayColor : UIColor.darkTextColor;
                  }
                  label.transform =  CGAffineTransformMakeScale(1 + 0.1 * progress, 1 + 0.1 * progress);
                  return label;
              })
               .animationViews(^NSArray<UIView *> *(NSArray<UIView *> *currentAnimations, UICollectionViewCell *fromCell, UICollectionViewCell *toCell, NSInteger fromIndex, NSInteger toIndex, CGFloat progress){
                   
                   NSArray<UIView *> *array = currentAnimations;
                   if (!array.count) {
                       UIView *line = [UIView new];
                       line.backgroundColor = UIColor.darkTextColor;
                       line.layer.cornerRadius = 1.5;
                       line.heightValue(3).bottomValue(34).widthValue(15);
                       array = @[line];
                   }
                  array.firstObject.centerXValue((1 - progress) * fromCell.centerX + progress * toCell.centerX);
                  return array;
               })
              .clickItemAtIndex(^BOOL(NSInteger currentIndex, BOOL isRepeat){
                  if (!isRepeat) {
                      !clickAction ?: clickAction(currentIndex);
                  }
                  return YES;
              });
          }];
    segmentView.backgroundColor = UIColor.whiteColor;
    return segmentView;
}

@end
