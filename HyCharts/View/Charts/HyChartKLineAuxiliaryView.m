//
//  HyChartKLineAuxiliaryView.m
//  DemoCode
//
//  Created by Hy on 2018/4/1.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartKLineAuxiliaryView.h"
#import "HyChartKLineDataSource.h"
#import "HyChartKLineModel.h"
#import "HyChartKLineAuxiliaryLayer.h"
#import "HyChartAlgorithmContext.h"
#import "HyChartsMethods.h"
#import <objc/message.h>


@interface HyChartKLineAuxiliaryView ()
@property (nonatomic, assign) HyChartKLineAuxiliaryType auxiliaryType;
@property (nonatomic, strong) HyChartKLineAuxiliaryLayer *chartLayer;
@property (nonatomic, strong) HyChartKLineDataSource *dataSource;
@end


@implementation HyChartKLineAuxiliaryView
@dynamic auxiliaryType;

- (void)handleVisibleModelsWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    
    __block double maxValue = - MAXFLOAT;
    __block double minValue = MAXFLOAT;

    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, endIndex - startIndex + 1)];
    self.dataSource.modelDataSource.visibleModels = [self.dataSource.modelDataSource.models objectsAtIndexes:indexSet];
    [self.dataSource.modelDataSource.visibleModels enumerateObjectsUsingBlock:^(HyChartKLineModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ((void(*)(id, SEL, HyChartModel *, NSUInteger))objc_msgSend)(self, sel_registerName("handlePositionWithModel:idx:"), obj, idx);

        maxValue = MAX(maxValue, obj.maxAuxiliary.doubleValue);
        minValue = MIN(minValue, obj.minAuxiliary.doubleValue);
    }];
        
    self.dataSource.modelDataSource.maxValue = [NSNumber numberWithDouble:maxValue];
    self.dataSource.modelDataSource.minValue = [NSNumber numberWithDouble:minValue];
}

- (void)handleTechnicalDataWithRangeIndex:(NSInteger)rangeIndex {
    
    HyChartKLineConfigure * configure = (id)self.dataSource.configreDataSource.configure;
        
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
                                          self.dataSource.modelDataSource, rangeIndex);
    }];
    
    [configure.rsiDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
        HyChartAlgorithmContext.handleRSI([key integerValue],
                                          self.dataSource.modelDataSource,
                                          rangeIndex);
    }];
}

- (void)handleMaxMinValueWithRangeIndex:(NSUInteger)rangeIndex {
    
    if (rangeIndex == 0) {
        rangeIndex = self.dataSource.modelDataSource.models.count;
    }
    
    HyChartKLineConfigure *configure = self.dataSource.configreDataSource.configure;
    [self.dataSource.modelDataSource.models enumerateObjectsUsingBlock:^(HyChartKLineModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx < rangeIndex) {
            __block double maxValue = - MAXFLOAT;
            __block double minValue = MAXFLOAT;
            switch (self.auxiliaryType) {
                case HyChartKLineAuxiliaryTypeMACD: {
                    NSArray<NSNumber *> *macdParams = configure.macdDict.allKeys.firstObject;
                    double difValue = obj.priceDIF([macdParams.firstObject integerValue], [macdParams[1] integerValue]).doubleValue;
                    double demValue = obj.priceDEM([macdParams.firstObject integerValue], [macdParams[1] integerValue], [macdParams.lastObject integerValue]).doubleValue;
                    double macdValue = obj.priceMACD([macdParams.firstObject integerValue], [macdParams[1] integerValue], [macdParams.lastObject integerValue]).doubleValue;
                    maxValue = MAX(maxValue, MAX(MAX(difValue, demValue), macdValue));
                    minValue = MIN(minValue, MIN(MIN(difValue, demValue), macdValue));
                } break;
                case HyChartKLineAuxiliaryTypeKDJ: {
                    NSArray<NSNumber *> *kdjParams = configure.kdjDict.allKeys.firstObject;
                    double kValue = obj.priceK([kdjParams.firstObject integerValue], [kdjParams[1] integerValue]).doubleValue;
                    double dValue = obj.priceD([kdjParams.firstObject integerValue], [kdjParams[1] integerValue], [kdjParams.lastObject integerValue]).doubleValue;
                    double jValue = obj.priceJ([kdjParams.firstObject integerValue], [kdjParams[1] integerValue], [kdjParams.lastObject integerValue]).doubleValue;
                    maxValue = MAX(maxValue, MAX(MAX(kValue, dValue), jValue));
                    minValue = MIN(minValue, MIN(MIN(kValue, dValue), jValue));
                } break;
                case HyChartKLineAuxiliaryTypeRSI: {
                    [configure.rsiDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull color, BOOL * _Nonnull stop) {
                        double rsiValue =  obj.priceRSI([key integerValue]).doubleValue;
                        maxValue = MAX(maxValue, rsiValue);
                        minValue = MIN(minValue, rsiValue);;
                    }];
                } break;
                default:
                break;
            }
            obj.maxAuxiliary = [NSNumber numberWithDouble:maxValue];
            obj.minAuxiliary = [NSNumber numberWithDouble:minValue];
        }        
    }];
}

- (HyChartKLineAuxiliaryLayer *)chartLayer {
    if (!_chartLayer){
        _chartLayer = [HyChartKLineAuxiliaryLayer layerWithDataSource:self.dataSource];
    }
    return _chartLayer;
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

- (void)switchKLineAuxiliaryType:(HyChartKLineAuxiliaryType)type {
    
    self.chartLayer.auxiliaryType = type;
    self.dataSource.modelDataSource.auxiliaryType = type;
    self.auxiliaryType = type;
}

- (NSNumberFormatter *)yAxisNunmberFormatter {
    return self.dataSource.configreDataSource.configure.volumeNunmberFormatter;
}

@end
