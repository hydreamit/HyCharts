//
//  HyChartKLineView.m
//  HyChartsDemo
//
//  Created by Hy on 2018/4/18.
//  Copyright © 2018 Hy. All rights reserved.
//


#import "HyChartKLineView.h"
#import "HyChartLayerProtocol.h"
#import "HyChartLayer.h"
#import "HyChartKLineDataSource.h"
#import "HyChartKLineModel.h"
#import "HyChartAlgorithmContext.h"
#import "HyChartKLineDataSourceProtocol.h"
#import "HyChartKLineMainLayer.h"
#import "HyChartKLineVolumeLayer.h"
#import "HyChartKLineAuxiliaryLayer.h"
#import "HyChartAxisLayer.h"
#import "HyChartsMethods.h"
#import <objc/message.h>



@interface HyChartKLineLayer : CALayer<HyChartLayerProtocol>
@property (nonatomic, strong) NSDictionary<NSNumber *, HyChartLayer *> *layersDict;
@end
@implementation HyChartKLineLayer
- (void)setNeedsRendering {
    [self.layersDict.allValues makeObjectsPerformSelector:@selector(setNeedsRendering)];
}
@end


@interface HyChartKLineAxisLayer : CALayer<HyChartLayerProtocol>
@property (nonatomic, strong) NSDictionary<NSNumber *, HyChartAxisLayer *> *layersDict;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@end
@implementation HyChartKLineAxisLayer
- (void)setNeedsRendering {
    [self.layersDict.allValues makeObjectsPerformSelector:@selector(setNeedsRendering)];
}
- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    _contentEdgeInsets = contentEdgeInsets;
    
    NSArray<HyChartAxisLayer *> *layers = self.sublayers;
    
    if (layers.count == 1) {
        layers.firstObject.contentEdgeInsets = self.contentEdgeInsets;
    } else if (layers.count == 2) {
        layers.firstObject.contentEdgeInsets = UIEdgeInsetsMake(self.contentEdgeInsets.top, self.contentEdgeInsets.left, 0, self.contentEdgeInsets.right);
        layers.lastObject.contentEdgeInsets = UIEdgeInsetsMake(0, self.contentEdgeInsets.left, self.contentEdgeInsets.bottom, self.contentEdgeInsets.right);
    } else {
        [layers enumerateObjectsUsingBlock:^(HyChartAxisLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                obj.contentEdgeInsets = UIEdgeInsetsMake(self.contentEdgeInsets.top, self.contentEdgeInsets.left, 0, self.contentEdgeInsets.right);
            } else if (idx == layers.count - 1) {
                obj.contentEdgeInsets = UIEdgeInsetsMake(0, self.contentEdgeInsets.left, self.contentEdgeInsets.bottom, self.contentEdgeInsets.right);
            } else {
               obj.contentEdgeInsets = UIEdgeInsetsMake(0, self.contentEdgeInsets.left, 0, self.contentEdgeInsets.right);
            }
        }];
    }
}
@end



@interface HyChartKLineView ()
@property (nonatomic, strong) HyChartKLineLayer *chartLayer;
@property (nonatomic, strong) HyChartKLineAxisLayer *axisLayer;
@property (nonatomic, assign) HyChartKLineTechnicalType technicalType;
@property (nonatomic, assign) HyChartKLineAuxiliaryType auxiliaryType;
@property (nonatomic, strong) HyChartKLineDataSource *dataSource;
@end


@implementation HyChartKLineView
@dynamic technicalType, auxiliaryType;

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger index = 0;
    CGFloat axisLayerY = 0;
    CGFloat chartLayerY = 0;
    NSDictionary *klineViewDict = self.dataSource.configreDataSource.configure.klineViewDict;
    for (NSNumber *type in self.klineViewTypes) {
        HyChartLayer *chartLayer = self.chartLayer.layersDict[type];
        HyChartAxisLayer *axisLayer = self.axisLayer.layersDict[type];
        if (chartLayer) {
            CGFloat height = [klineViewDict[type] floatValue] * CGRectGetHeight(self.bounds);
            axisLayer.frame = CGRectMake(0, axisLayerY, CGRectGetWidth(self.axisLayer.bounds), height);
            axisLayerY += height;
            
            if (index == 0) {
                height -= self.contentEdgeInsets.top;
            }
            if (index == self.chartLayer.layersDict.allValues.count - 1) {
                height -= self.contentEdgeInsets.bottom;
            }
            
            chartLayer.frame = CGRectMake(0, chartLayerY, CGRectGetWidth(self.chartLayer.bounds), height);
            chartLayerY += height;
            index += 1;
        }
    }
}

- (void)handleVisibleModelsWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {

    __block double maxPrice = 0;
    __block double minPrice = 0;
    __block double maxVolume = 0;
    __block double maxAuxiliary = - MAXFLOAT;
    __block double minAuxiliary = MAXFLOAT;
    __block HyChartKLineModel *maxPriceModel = nil;
    __block HyChartKLineModel *minPriceModel = nil;
    __block HyChartKLineModel *maxVolumeModel = nil;
    __block HyChartKLineModel *minVolumeModel = nil;
    
    BOOL klineMain = [self containKLineViewWithType:HyChartKLineViewTypeMain];
    BOOL klineVolume = [self containKLineViewWithType:HyChartKLineViewTypeVolume];
    BOOL klineAuxiliary = [self containKLineViewWithType:HyChartKLineViewTypeAuxiliary];
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, endIndex - startIndex + 1)];
    self.dataSource.modelDataSource.visibleModels = [self.dataSource.modelDataSource.models objectsAtIndexes:indexSet];
    [self.dataSource.modelDataSource.visibleModels enumerateObjectsUsingBlock:^(HyChartKLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ((void(*)(id, SEL, HyChartModel *, NSUInteger))objc_msgSend)(self, sel_registerName("handlePositionWithModel:idx:"), obj, idx);
        
         if (!maxPriceModel || !minPriceModel) {
             if (klineMain) {
                maxPriceModel = obj;
                minPriceModel = obj;
                 if (!self.isTimeLine) {
                     maxPrice = obj.maxPrice.doubleValue;
                     minPrice = obj.minPrice.doubleValue;
                 } else {
                     maxPrice = obj.maxValue.doubleValue;
                     minPrice = obj.minValue.doubleValue;
                 }
             }
             if (klineVolume) {
                maxVolumeModel = obj;
                minVolumeModel = obj;
                maxVolume = obj.maxVolume.doubleValue;
             }
         } else {
             if (klineMain) {
                 if (self.isTimeLine) {
                     
                     if (obj.maxValue.doubleValue > maxPriceModel.maxValue.doubleValue) {
                         maxPriceModel = obj;
                     }
                     if (obj.minValue.doubleValue < minPriceModel.minValue.doubleValue) {
                         minPriceModel = obj;
                     }
                     maxPrice = MAX(maxPrice, obj.maxValue.doubleValue);
                     minPrice = MIN(minPrice, obj.minValue.doubleValue);
                     
                 } else {
                     if (obj.highPrice.doubleValue > maxPriceModel.highPrice.doubleValue) {
                         maxPriceModel = obj;
                     }
                     if (obj.lowPrice.doubleValue < minPriceModel.lowPrice.doubleValue) {
                         minPriceModel = obj;
                     }
                     maxPrice = MAX(maxPrice, obj.maxPrice.doubleValue);
                     minPrice = MIN(minPrice, obj.minPrice.doubleValue);
                 }

             }
             if (klineVolume) {
                 if (obj.volume.doubleValue > maxVolumeModel.volume.doubleValue) {
                     maxVolumeModel = obj;
                 } else
                 if (obj.volume.doubleValue < minVolumeModel.volume.doubleValue) {
                     minVolumeModel = obj;
                 }
                 maxVolume = MAX(maxVolume, obj.maxVolume.doubleValue);
             }
         }
        
        if (klineAuxiliary) {
            maxAuxiliary = MAX(maxAuxiliary, obj.maxAuxiliary.doubleValue);
            minAuxiliary = MIN(minAuxiliary, obj.minAuxiliary.doubleValue);
        }
    }];
    
    if (klineMain) {
        self.dataSource.modelDataSource.maxPrice = [NSNumber numberWithDouble:maxPrice];
        self.dataSource.modelDataSource.minPrice = [NSNumber numberWithDouble:minPrice];
        self.dataSource.modelDataSource.visibleMaxPriceModel = maxPriceModel;
        self.dataSource.modelDataSource.visibleMinPriceModel = minPriceModel;
        if (self.timeLine) {
            self.dataSource.modelDataSource.minValue = [NSNumber numberWithDouble:maxPrice];
            self.dataSource.modelDataSource.maxValue = [NSNumber numberWithDouble:minPrice];
            self.dataSource.modelDataSource.visibleMaxModel = maxPriceModel;
            self.dataSource.modelDataSource.visibleMinModel = maxPriceModel;
        }
    }
    
    if (klineVolume) {
        self.dataSource.modelDataSource.maxVolume = [NSNumber numberWithDouble:maxVolume];
        self.dataSource.modelDataSource.minVolume = @(0);
        self.dataSource.modelDataSource.visibleMaxVolumeModel = maxVolumeModel;
        self.dataSource.modelDataSource.visibleMinVolumeModel = minVolumeModel;
    }
    
    if (klineAuxiliary) {
        self.dataSource.modelDataSource.maxAuxiliary = [NSNumber numberWithDouble:maxAuxiliary];
        self.dataSource.modelDataSource.minAuxiliary = [NSNumber numberWithDouble:minAuxiliary];
    }
}

- (BOOL)containKLineViewWithType:(HyChartKLineViewType)type {
    if (self.chartLayer.layersDict[@(type)]) {
        return YES;
    }
    return NO;
}

- (void)handleTechnicalDataWithRangeIndex:(NSInteger)rangeIndex {
    
    HyChartKLineConfigure *configure = self.dataSource.configreDataSource.configure;
    
    if ([self containKLineViewWithType:HyChartKLineViewTypeMain] ||
        [self containKLineViewWithType:HyChartKLineViewTypeVolume]) {
        
        [configure.smaDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
            HyChartAlgorithmContext.handleSMA([key integerValue],
                                              self.dataSource.modelDataSource,
                                              rangeIndex);
        }];
        
        [configure.emaDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
            HyChartAlgorithmContext.handleEMA([key integerValue],
                                              self.dataSource.modelDataSource,
                                              rangeIndex);
        }];
        
        [configure.bollDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSArray<UIColor *> * _Nonnull obj, BOOL * _Nonnull stop) {
            HyChartAlgorithmContext.handleBOLL([key integerValue],
                                               self.dataSource.modelDataSource,
                                               rangeIndex);
        }];
    }
    
    if ([self containKLineViewWithType:HyChartKLineViewTypeAuxiliary]) {
        [configure.macdDict enumerateKeysAndObjectsUsingBlock:^(NSArray<NSNumber *> * _Nonnull key, NSArray<UIColor *> * _Nonnull obj, BOOL * _Nonnull stop) {
            HyChartAlgorithmContext.handleMACD([key.firstObject integerValue],
                                               [key[1] integerValue],
                                               [key.lastObject integerValue],
                                               self.dataSource.modelDataSource, rangeIndex);
        }];
        
        [configure.kdjDict enumerateKeysAndObjectsUsingBlock:^(NSArray<NSNumber *> * _Nonnull key, NSArray<UIColor *> * _Nonnull obj, BOOL * _Nonnull stop) {
            HyChartAlgorithmContext.handleKDJ([key.firstObject integerValue],
                                              [key[1] integerValue],
                                              [key.lastObject integerValue],
                                              self.dataSource.modelDataSource,
                                              rangeIndex);
        }];
        
        [configure.rsiDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
            HyChartAlgorithmContext.handleRSI([key integerValue],
                                              self.dataSource.modelDataSource,
                                              rangeIndex);
        }];
    }
}

- (void)handleMaxMinValueWithRangeIndex:(NSUInteger)rangeIndex {
    
//    if (self.timeLine) { return;}
    
    if (rangeIndex == 0) {
        rangeIndex = self.dataSource.modelDataSource.models.count;
    }
    
    BOOL klineMain = [self containKLineViewWithType:HyChartKLineViewTypeMain];
    BOOL klineVolume = [self containKLineViewWithType:HyChartKLineViewTypeVolume];
    BOOL klineAuxiliary = [self containKLineViewWithType:HyChartKLineViewTypeAuxiliary];
    HyChartKLineConfigure *klineConfigure = self.dataSource.configreDataSource.configure;
    [self.dataSource.modelDataSource.models enumerateObjectsUsingBlock:^(HyChartKLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx < rangeIndex) {
            __block double maxPrice = obj.highPrice.doubleValue;
            __block double minPrice = obj.lowPrice.doubleValue;
            __block double maxVolume = obj.volume.doubleValue;
            __block double minVolume = 0;
            
            switch (self.technicalType) {
                case HyChartKLineTechnicalTypeSMA: {
                    [klineConfigure.smaDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull color, BOOL * _Nonnull stop) {
                        if (klineMain) {
                            maxPrice = MAX(obj.priceSMA([key integerValue]).doubleValue, maxPrice);
                            minPrice = MIN(obj.priceSMA([key integerValue]).doubleValue, minPrice);
                        }
                        if (klineVolume) {
                            maxVolume = MAX(obj.volumeSMA([key integerValue]).doubleValue, maxVolume);
                            minVolume = MIN(obj.volumeSMA([key integerValue]).doubleValue, minVolume);
                        }
                    }];
                } break;
                case HyChartKLineTechnicalTypeEMA: {
                    [klineConfigure.emaDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull color, BOOL * _Nonnull stop) {
                        if (klineMain) {
                            maxPrice = MAX(obj.priceEMA([key integerValue]).doubleValue, maxPrice);
                            minPrice = MIN(obj.priceEMA([key integerValue]).doubleValue, minPrice);
                        }
                        if (klineVolume) {
                            maxVolume = MAX(obj.volumeEMA([key integerValue]).doubleValue, maxVolume);
                            minVolume = MIN(obj.volumeEMA([key integerValue]).doubleValue, minVolume);
                        }
                    }];
                } break;
                case HyChartKLineTechnicalTypeBOLL: {
                    [klineConfigure.bollDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSArray<UIColor *> * _Nonnull colors, BOOL * _Nonnull stop) {
                        if (klineMain) {
                            maxPrice = MAX(obj.priceBoll([key integerValue], @"up").doubleValue, maxPrice);
                            minPrice = MIN(obj.priceBoll([key integerValue], @"dn").doubleValue, minPrice);
                        }
                        if (klineVolume) {
                            maxVolume = MAX(obj.volumeBoll([key integerValue], @"up").doubleValue, maxVolume);
                            minVolume = MIN(obj.volumeBoll([key integerValue], @"dn").doubleValue, minVolume);
                        }
                    }];
                } break;
                default:
                break;
            }

            if (klineMain) {
                obj.maxPrice = [NSNumber numberWithDouble:maxPrice];
                obj.minPrice = [NSNumber numberWithDouble:minPrice];
            }
            if (klineVolume && self.technicalType != HyChartKLineTechnicalTypeBOLL) {
                obj.maxVolume = [NSNumber numberWithDouble:maxVolume];
                obj.minVolume = [NSNumber numberWithDouble:minVolume];
            }
            
            if (klineAuxiliary) {
                __block double maxAuxiliary = - MAXFLOAT;
                __block double minAuxiliary = MAXFLOAT;
                switch (self.auxiliaryType) {
                    case HyChartKLineAuxiliaryTypeMACD: {
                        NSArray<NSNumber *> *macdParams = klineConfigure.macdDict.allKeys.firstObject;
                        double difValue = obj.priceDIF([macdParams.firstObject integerValue], [macdParams[1] integerValue]).doubleValue;
                        double demValue = obj.priceDEM([macdParams.firstObject integerValue], [macdParams[1] integerValue], [macdParams.lastObject integerValue]).doubleValue;
                        double macdValue = obj.priceMACD([macdParams.firstObject integerValue], [macdParams[1] integerValue], [macdParams.lastObject integerValue]).doubleValue;
                        maxAuxiliary = MAX(maxAuxiliary, MAX(MAX(difValue, demValue), macdValue));
                        minAuxiliary = MIN(minAuxiliary, MIN(MIN(difValue, demValue), macdValue));
                    } break;
                    case HyChartKLineAuxiliaryTypeKDJ: {
                        NSArray<NSNumber *> *kdjParams = klineConfigure.kdjDict.allKeys.firstObject;
                        double kValue = obj.priceK([kdjParams.firstObject integerValue], [kdjParams[1] integerValue]).doubleValue;
                        double dValue = obj.priceD([kdjParams.firstObject integerValue], [kdjParams[1] integerValue], [kdjParams.lastObject integerValue]).doubleValue;
                        double jValue = obj.priceJ([kdjParams.firstObject integerValue], [kdjParams[1] integerValue], [kdjParams.lastObject integerValue]).doubleValue;
                        maxAuxiliary = MAX(maxAuxiliary, MAX(MAX(kValue, dValue), jValue));
                        minAuxiliary = MIN(minAuxiliary, MIN(MIN(kValue, dValue), jValue));
                    } break;
                    case HyChartKLineAuxiliaryTypeRSI: {
                        [klineConfigure.rsiDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull color, BOOL * _Nonnull stop) {
                            double rsiValue =  obj.priceRSI([key integerValue]).doubleValue;
                            maxAuxiliary = MAX(maxAuxiliary, rsiValue);
                            minAuxiliary = MIN(minAuxiliary, rsiValue);;
                        }];
                    } break;
                    default:
                    break;
                }
                obj.maxAuxiliary = [NSNumber numberWithDouble:maxAuxiliary];
                obj.minAuxiliary = [NSNumber numberWithDouble:minAuxiliary];
            }
        }
    }];
}

- (void)handleOther {
    
    NSInteger indexs = self.dataSource.axisDataSource.xAxisModel.indexs;
    
    HyChartXAxisModel *xAxisModel = self.dataSource.axisDataSource.xAxisModel;
    HyChartAxisGridLineInfo *gridLineInfo = xAxisModel.axisGridLineInfo;
    HyChartXAxisInfo *topXAxisInfo = xAxisModel.topXAxisInfo;
    HyChartXAxisInfo *bottomXAxisInfo = xAxisModel.bottomXAxisInfo;
    NSDictionary *klineViewDict = self.dataSource.configreDataSource.configure.klineViewDict;
    for (NSNumber *key in klineViewDict.allKeys) {
        
        NSInteger index = [klineViewDict.allKeys indexOfObject:key];
        
        HyChartXAxisModel *xaxisModel = self.dataSource.axisDataSource.xAxisModelWityViewType([key integerValue]);
        [[xaxisModel configNumberOfIndexs:indexs] configAxisGridLineInfo:^(id<HyChartAxisGridLineInfoProtocol>  _Nonnull axisGridLineInfo) {
            axisGridLineInfo.axisGridLineColor = gridLineInfo.axisGridLineColor;
            axisGridLineInfo.axisGridLineWidth = gridLineInfo.axisGridLineWidth;
            axisGridLineInfo.axisGridLineDashPhase = gridLineInfo.axisGridLineDashPhase;
            axisGridLineInfo.axisGridLineDashPattern = gridLineInfo.axisGridLineDashPattern;
            axisGridLineInfo.axisGridLineType = gridLineInfo.axisGridLineType;
        }];
        if (index == 0 || index == klineViewDict.allKeys.count - 1) {
            if (index == 0) {
                xaxisModel.topXaxisDisabled = xAxisModel.topXaxisDisabled;
                [[xaxisModel configTopXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
                    self.copyXAxisInfo(xAxisInfo, topXAxisInfo);
                }] configBottomXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
                    xAxisInfo.autoSetText = NO;
                    xAxisInfo.axisLineColor = bottomXAxisInfo.axisLineColor;
                    xAxisInfo.axisLineWidth = bottomXAxisInfo.axisLineWidth < 1 ? 1 : bottomXAxisInfo.axisLineWidth;
                    xAxisInfo.axisLineDashPhase = bottomXAxisInfo.axisLineDashPhase;
                    xAxisInfo.axisLineDashPattern = bottomXAxisInfo.axisLineDashPattern;
                    xAxisInfo.axisLineType = bottomXAxisInfo.axisLineType;
                }];
            }
            if (index == klineViewDict.allKeys.count - 1) {
                [xaxisModel configBottomXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
                    self.copyXAxisInfo(xAxisInfo, bottomXAxisInfo);
                }];
            }
        }  else {
            [xaxisModel configBottomXAxisInfo:^(id<HyChartXAxisInfoProtocol>  _Nonnull xAxisInfo) {
                xAxisInfo.autoSetText = NO;
                xAxisInfo.axisLineColor = bottomXAxisInfo.axisLineColor;
                xAxisInfo.axisLineWidth = bottomXAxisInfo.axisLineWidth;
                xAxisInfo.axisLineDashPhase = bottomXAxisInfo.axisLineDashPhase;
                xAxisInfo.axisLineDashPattern = bottomXAxisInfo.axisLineDashPattern;
                xAxisInfo.axisLineType = bottomXAxisInfo.axisLineType;
            }];
        }
    }
}

- (void(^)(id<HyChartXAxisInfoProtocol>, id<HyChartXAxisInfoProtocol>))copyXAxisInfo {
    return ^(id<HyChartXAxisInfoProtocol> one, id<HyChartXAxisInfoProtocol> two){
        one.axisTextColor = two.axisTextColor;
        one.axisTextOffset = two.axisTextOffset;
        one.rotateAngle = two.rotateAngle;
        one.axisTextPosition = two.axisTextPosition;
        one.autoSetText = two.autoSetText;
        one.displayAxisZeroText = two.displayAxisZeroText;
        one.axisLineColor = two.axisLineColor;
        one.axisLineWidth = two.axisLineWidth;
        one.axisLineDashPhase = two.axisLineDashPhase;
        one.axisLineDashPattern = two.axisLineDashPattern;
        one.axisLineType = two.axisLineType;
    };
}

- (void)handleXAxis {
    
    NSDictionary *klineViewDict = self.dataSource.configreDataSource.configure.klineViewDict;
    
    NSInteger indexs = self.dataSource.axisDataSource.xAxisModelWityViewType([klineViewDict.allKeys.firstObject integerValue]).indexs;
    if (indexs) {
        NSArray *models = self.dataSource.modelDataSource.models;
        CGFloat xAxisWidth = self.chartLayer.bounds.size.width / indexs;
        NSMutableArray<id<HyChartModelProtocol>> *xAxisModels = @[].mutableCopy;
        for (NSInteger ind = 0; ind < indexs + 1; ind ++) {
            CGFloat absolutePosition = self.dataSource.configreDataSource.configure.trans + xAxisWidth * ind;
            NSInteger absoluteIndex = ((NSInteger (*)(id, SEL, CGFloat))objc_msgSend)(self, sel_registerName("absoluteIndexWithPosition:"), absolutePosition);
           if (absoluteIndex < models.count) {
               [xAxisModels addObject:models[absoluteIndex]];
           }
        }
        self.dataSource.modelDataSource.visibleXAxisModels = xAxisModels.copy;
        
        [klineViewDict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HyChartXAxisModel *currentXAxisModel = self.dataSource.axisDataSource.xAxisModelWityViewType([obj integerValue]);
            typeof(id(^)(NSInteger, id<HyChartModelProtocol>)) (^textBlock)(BOOL) = ^(BOOL displayAxisZeroText){
                return ^id(NSInteger index, id<HyChartModelProtocol> model){
                    if (!displayAxisZeroText && !index) {
                        return @"";
                    }
                    if (index < xAxisModels.count) {
                        return xAxisModels[index].text;
                    }
                    return @"";
                };
            };

            if (!currentXAxisModel.topXaxisDisabled && currentXAxisModel.topXAxisInfo.autoSetText) {
               [currentXAxisModel.topXAxisInfo configTextAtIndex:textBlock(currentXAxisModel.topXAxisInfo.displayAxisZeroText)];
            }
            if (!currentXAxisModel.bottomXaxisDisabled && currentXAxisModel.bottomXAxisInfo.autoSetText) {
                [currentXAxisModel.bottomXAxisInfo configTextAtIndex:textBlock(currentXAxisModel.bottomXAxisInfo.displayAxisZeroText)];
            }
        }];
    }
}

- (void)handleYAxis {
    
    NSDictionary *klineViewDict = self.dataSource.configreDataSource.configure.klineViewDict;
    [klineViewDict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        double maxValue = self.dataSource.modelDataSource.maxValueWithViewType([obj intValue]).doubleValue;
        double minValue = self.dataSource.modelDataSource.minValueWithViewType([obj intValue]).doubleValue;
        double subValue  = (maxValue - minValue);
        
        HyChartYAxisModel *yAxisModel = self.dataSource.axisDataSource.yAxisModelWityViewType([obj intValue]);
        
        if (yAxisModel.yAxisMinValueBlock) {
            yAxisModel.yAxisMinValue = yAxisModel.yAxisMinValueBlock();
            minValue = yAxisModel.yAxisMinValue.doubleValue;
        } else {
            if ([obj integerValue] != 1) {
                NSNumber *yAxisMinValueExtraPrecent = yAxisModel.yAxisMinValueExtraPrecent;
                if (yAxisMinValueExtraPrecent) {
                    minValue = minValue - subValue * yAxisMinValueExtraPrecent.doubleValue;
                }
            }
           yAxisModel.yAxisMinValue = [NSNumber numberWithDouble:minValue];
        }

        if (yAxisModel.yAxisMaxValueBlock) {
            yAxisModel.yAxisMaxValue = yAxisModel.yAxisMaxValueBlock();
            maxValue = yAxisModel.yAxisMaxValue.doubleValue;
        } else {
            NSNumber *yAxisMaxValueExtraPrecent = yAxisModel.yAxisMaxValueExtraPrecent;
            if (yAxisMaxValueExtraPrecent) {
                maxValue = maxValue + subValue * yAxisMaxValueExtraPrecent.doubleValue;
            }
            yAxisModel.yAxisMaxValue = [NSNumber numberWithDouble:maxValue];
        }

        if (yAxisModel.indexs) {
            NSNumberFormatter *formatter = [obj intValue] == HyChartKLineViewTypeVolume ? self.dataSource.modelDataSource.volumeNunmberFormatter : self.dataSource.modelDataSource.priceNunmberFormatter;
            CGFloat averageMargin = (maxValue - minValue) / yAxisModel.indexs;            
            typeof(id(^)(NSInteger, NSNumber *, NSNumber *)) (^textBlock)(BOOL) = ^(BOOL displayAxisZeroText){
                return ^id(NSInteger index, NSNumber * _Nonnull maxV, NSNumber * _Nonnull minV){
                    if (!displayAxisZeroText && !index) {
                        return @"";
                    }
                    double current = minValue + averageMargin * index;
                    return [formatter stringFromNumber:[NSNumber numberWithDouble:current]];
                };
            };

            if (!yAxisModel.leftYAxisDisabled && yAxisModel.leftYAxisInfo.autoSetText) {
                [yAxisModel.leftYAxisInfo configTextAtIndex:textBlock(yAxisModel.leftYAxisInfo.displayAxisZeroText)];
            }
            if (!yAxisModel.rightYAaxisDisabled && yAxisModel.rightYAxisInfo.autoSetText) {
                [yAxisModel.rightYAxisInfo configTextAtIndex:textBlock(yAxisModel.rightYAxisInfo.displayAxisZeroText)];
            }
        }
    }];
}

- (HyChartKLineDataSource *)dataSource {
    if (!_dataSource){
        _dataSource = [[HyChartKLineDataSource alloc] init];
    }
    return _dataSource;
}

- (HyChartKLineModel *)model {
    return HyChartKLineModel.new;
}

- (HyChartKLineLayer *)chartLayer {
    if (!_chartLayer){
        _chartLayer = [HyChartKLineLayer layer];
        NSDictionary *dict = @{@(HyChartKLineViewTypeMain) : @"HyChartKLineMainLayer",
                               @(HyChartKLineViewTypeVolume) : @"HyChartKLineVolumeLayer",
                               @(HyChartKLineViewTypeAuxiliary) : @"HyChartKLineAuxiliaryLayer",
                            };
        NSMutableDictionary *mDict = @{}.mutableCopy;
        for (NSNumber *type in self.klineViewTypes) {
            NSNumber *viewNumber = self.dataSource.configreDataSource.configure.klineViewDict[type];
            if (viewNumber && [viewNumber floatValue] > 0) {
               HyChartLayer *layer = [NSClassFromString(dict[type]) layerWithDataSource:self.dataSource];
                [_chartLayer addSublayer:layer];
                [mDict setObject:layer forKey:type];
            }
        }
        _chartLayer.layersDict = mDict.copy;
    }
    return _chartLayer;
}

- (HyChartKLineAxisLayer *)axisLayer {
    if (!_axisLayer) {
        _axisLayer = [HyChartKLineAxisLayer layer];
        NSMutableDictionary *mDict = @{}.mutableCopy;
        for (NSNumber *type in self.klineViewTypes) {
            NSNumber *viewNumber = self.dataSource.configreDataSource.configure.klineViewDict[type];
            if (viewNumber && [viewNumber floatValue] > 0) {
               HyChartAxisLayer *layer = [HyChartAxisLayer layerWithDataSource:self.dataSource xAxisModel:self.dataSource.axisDataSource.xAxisModelWityViewType([type integerValue]) yAxisModel:self.dataSource.axisDataSource.yAxisModelWityViewType([type integerValue])];
               [_axisLayer addSublayer:layer];
               [mDict setObject:layer forKey:type];
            }
        }
        _axisLayer.layersDict = mDict.copy;
    }
    return _axisLayer;
}

- (NSArray<NSNumber *> *)klineViewTypes {
    return @[@(HyChartKLineViewTypeMain),
             @(HyChartKLineViewTypeVolume),
             @(HyChartKLineViewTypeAuxiliary)];
}

- (void)switchKLineTechnicalType:(HyChartKLineTechnicalType)type {
    NSMutableArray<HyChartLayer *> *klineLayers = @[].mutableCopy;
    
    [self.chartLayer.layersDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, HyChartLayer * _Nonnull obj, BOOL * _Nonnull stop) {
        NSInteger keyValue = [key integerValue];
        if (keyValue == HyChartKLineViewTypeMain ||
            (keyValue == HyChartKLineViewTypeVolume && type != HyChartKLineTechnicalTypeBOLL)) {
            [klineLayers addObject:obj];
            ((HyChartKLineMainLayer *)obj).technicalType = type;
        }
    }];
    if (klineLayers.count) {
        self.dataSource.modelDataSource.klineMianTechnicalType = type;
        if (type != HyChartKLineTechnicalTypeBOLL) {
            self.dataSource.modelDataSource.klineVolumeTechnicalType = type;
        }
        self.technicalType = type;
    }
}

- (void)switchKLineAuxiliaryType:(HyChartKLineAuxiliaryType)type {
    HyChartKLineAuxiliaryLayer *klineAuxiliaryLayer = (id)self.chartLayer.layersDict[@(HyChartKLineViewTypeAuxiliary)];
    if (klineAuxiliaryLayer) {
        klineAuxiliaryLayer.auxiliaryType = type;
        self.dataSource.modelDataSource.auxiliaryType = type;
        self.auxiliaryType = type;
    }
}

- (void)setTimeLine:(BOOL)timeLine {
    _timeLine = timeLine;
    HyChartKLineMainLayer *klineMainLayer = (id)self.chartLayer.layersDict[@(HyChartKLineViewTypeMain)];
    if (klineMainLayer) {
        klineMainLayer.timeLine = timeLine;
    }
}

- (void)showCursorWithPoint:(CGPoint)point {
    HyChartKLineMainLayer *klineMainLayer = (id)self.chartLayer.layersDict[@(HyChartKLineViewTypeMain)];
    if (!klineMainLayer || point.y > CGRectGetMaxY(klineMainLayer.frame)) {
        return;
    }
    
    struct objc_super _super = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(struct objc_super *, SEL, CGPoint))objc_msgSendSuper)(&_super, sel_registerName("showCursorWithPoint:"), point);
}

- (NSNumberFormatter *)yAxisNunmberFormatter {
    return self.dataSource.configreDataSource.configure.priceNunmberFormatter;
}

@end
