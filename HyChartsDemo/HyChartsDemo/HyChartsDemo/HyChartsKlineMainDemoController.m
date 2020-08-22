//
//  HyChartsKlineMainDemoController.m
//  HyChartsDemo
//
//  Created by Hy on 2018/4/20.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartsKlineMainDemoController.h"
#import "HyChartsKlineDemoController.h"
#import <HyCategoriess/HyCategories.h>
#import <HyCycleView/HySegmentView.h>
#import "HyCharts.h"
#import "HyChartsKLineDemoDataHandler.h"


@interface HyChartsKlineMainDemoController ()
@property (nonatomic, strong) HySegmentView *segmentView;
@property (nonatomic, strong) HySegmentView *technicalSegmentView;
@property (nonatomic, strong) HyChartKLineMainView *klineMainView;
@end


@implementation HyChartsKlineMainDemoController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
   
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    backV.backgroundColor = UIColor.blackColor;
    [scrollView insertSubview:backV atIndex:0];
    
    [scrollView addSubview:self.segmentView];
    [scrollView addSubview:self.technicalSegmentView];
    [scrollView addSubview:self.klineMainView];
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.klineMainView.frame) + 50);
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

        __strong typeof(_self) self = _self;
        if (!self) {return;}
        if (!error) {
            NSDictionary *successObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [HyChartsKLineDemoDataHandler handleWithArray:successObject[@"Data"] dataSorce:self.klineMainView.dataSource];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicatorView stopAnimating];
            [indicatorView removeFromSuperview];
            if (!error) {
                self.klineMainView.timeLine = [type isEqualToString:@"101"];
                [self.klineMainView setNeedsRendering];
            }
        });
    }] resume];
}

- (HyChartKLineMainView *)klineMainView {
    if (!_klineMainView){
        
        _klineMainView = HyChartKLineMainView.new;
        _klineMainView.frame = CGRectMake(0, self.technicalSegmentView.bottom + 2, self.view.bounds.size.width, self.view.bounds.size.width * 0.8);
        _klineMainView.backgroundColor = [UIColor colorWithRed:14.0 / 255 green:33.0 / 255 blue:60.0 / 255 alpha:1];
        _klineMainView.contentEdgeInsets = UIEdgeInsetsMake(1, 1, 20, 1);
        
        // 配置坐标轴
        [[_klineMainView.dataSource.axisDataSource configXAxisWithModel:^(id<HyChartXAxisModelProtocol>  _Nonnull xAxisModel) {
            xAxisModel.topXaxisDisabled = NO;
            [[[[xAxisModel configNumberOfIndexs:4] configBottomXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
                xAxisInfo.axisLineColor = [UIColor colorWithWhite:1 alpha:.25];
                xAxisInfo.axisTextColor = [UIColor hy_colorWithHexString:@"#3A5775"];
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
            
            configure.width = 8;
            configure.margin = 4;
            configure.edgeInsetStart = 4;
            configure.edgeInsetEnd = 4;
            configure.trendUpColor = [UIColor hy_colorWithHexString:@"#E97C5E"];
            configure.trendDownColor = [UIColor hy_colorWithHexString:@"#1ABD93"];
            configure.minScaleToLine = YES;
            configure.priceDecimal = 2;
            configure.volumeDecimal = 4;
            configure.newpriceColor = UIColor.whiteColor;
            configure.maxminPriceColor = UIColor.whiteColor;
                        
            UIColor *lineColor =   Hy_ColorWithRGBA(46, 127, 208, 1);
            NSArray<UIColor *> *colors = @[Hy_ColorWithRGBA(46, 127, 208, .2),
                                           Hy_ColorWithRGBA(46, 127, 208, .1),
                                           Hy_ColorWithRGBA(46, 127, 208, .05)];

            // 配置分时线
            configure.timeLineHandleTechnicalData = YES;
            [configure configLineConfigureAtIndex:^(NSInteger index, id<HyChartLineOneConfigureProtocol>  _Nonnull oneConfigure) {
                oneConfigure.lineColor = lineColor;
                oneConfigure.shadeColors = colors;
            }];
            configure.minScaleLineColor = lineColor;
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

- (HySegmentView *)segmentView {
    if (!_segmentView){

        NSArray<NSString *> *titleArray = @[@"Time", @"M5", @"M15", @"M30", @"H1", @"D1", @"W1", @"MN"];
        NSArray<NSString *> *typeArray = @[@"101", @"102", @"103", @"104", @"201", @"301", @"310", @"401"];
        __weak typeof(self) _self = self;
        _segmentView =
        [self segmentViewWithFrame:CGRectMake(0, 0, self.view.width, 40)
                        titleArray:titleArray
                       clickAction:^(NSInteger currentIndex) {
             __weak typeof(_self) self = _self;
            [self requestDataWithType:typeArray[currentIndex]];
        }];
    }
    return _segmentView;
}

- (HySegmentView *)technicalSegmentView {
    if (!_technicalSegmentView){
        NSArray<NSString *> *titleArray = @[@"MA", @"EMA", @"BOLL"];
        __weak typeof(self) _self = self;
        _technicalSegmentView =
        [self segmentViewWithFrame:CGRectMake(0, self.segmentView.bottom + 1, self.view.width, 40)
                        titleArray:titleArray
                       clickAction:^(NSInteger currentIndex) {
             __weak typeof(_self) self = _self;
            [self.klineMainView switchKLineTechnicalType:currentIndex + 1];
        }];
    }
    return _technicalSegmentView;
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
                  if (!isRepeat) {
                      !clickAction ?: clickAction(currentIndex);
                  }
                  return YES;
              });
          }];
    segmentView.backgroundColor = [UIColor colorWithRed:14.0 / 255 green:33.0 / 255 blue:60.0 / 255 alpha:1];
    return segmentView;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
