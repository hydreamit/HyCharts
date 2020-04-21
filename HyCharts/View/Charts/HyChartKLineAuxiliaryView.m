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


@interface HyChartKLineAuxiliaryView ()
@property (nonatomic, assign) CGFloat chartWidth;
@property (nonatomic, assign) HyChartKLineAuxiliaryType auxiliaryType;
@property (nonatomic, strong) HyChartKLineAuxiliaryLayer *chartLayer;
@property (nonatomic, strong) id<HyChartKLineDataSourceProtocol> dataSource;
@end


@implementation HyChartKLineAuxiliaryView
@dynamic auxiliaryType;

- (void)handleVisibleModelsWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    
    __block double maxValue = - MAXFLOAT;
    __block double minValue = MAXFLOAT;
    id<HyChartKLineConfigureProtocol> configure =  self.dataSource.configreDataSource.configure;
    HyChartDataDirection dataDirection =  self.dataSource.configreDataSource.configure.dataDirection;
        
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, endIndex - startIndex + 1)];
    self.dataSource.modelDataSource.visibleModels = [self.dataSource.modelDataSource.models objectsAtIndexes:indexSet];
    [self.dataSource.modelDataSource.visibleModels enumerateObjectsUsingBlock:^(id<HyChartKLineModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.visibleIndex = idx;
        if (dataDirection == HyChartDataDirectionForward) {
            obj.position = configure.scaleEdgeInsetStart + obj.index * configure.scaleItemWidth ;
            obj.visiblePosition = obj.position - configure.trans;
        } else {
            obj.position = configure.scaleEdgeInsetStart + obj.index * configure.scaleItemWidth + configure.scaleWidth;
            obj.visiblePosition = self.chartWidth - (obj.position - configure.trans);
        }
        
        maxValue = MAX(maxValue, obj.maxAuxiliary.doubleValue);
        minValue = MIN(minValue, obj.minAuxiliary.doubleValue);
    }];
        
    self.dataSource.modelDataSource.maxValue = [NSNumber numberWithDouble:maxValue];
    self.dataSource.modelDataSource.minValue = [NSNumber numberWithDouble:minValue];
}

- (void)handleTechnicalData {
    
     id<HyChartKLineConfigureProtocol> configure = (id)self.dataSource.configreDataSource.configure;
        
    [configure.macdDict enumerateKeysAndObjectsUsingBlock:^(NSArray<NSNumber *> * _Nonnull key, NSArray<UIColor *> * _Nonnull obj, BOOL * _Nonnull stop) {
        HyChartAlgorithmContext.handleMACD([key.firstObject integerValue], [key[1] integerValue], [key.lastObject integerValue], (id<HyChartKLineModelDataSourceProtocol>)self.dataSource.modelDataSource);
    }];
    
    [configure.kdjDict enumerateKeysAndObjectsUsingBlock:^(NSArray<NSNumber *> * _Nonnull key, NSArray<UIColor *> * _Nonnull obj, BOOL * _Nonnull stop) {
        HyChartAlgorithmContext.handleKDJ([key.firstObject integerValue], [key[1] integerValue], [key.lastObject integerValue], (id<HyChartKLineModelDataSourceProtocol>)self.dataSource.modelDataSource);
    }];
    
    [configure.rsiDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
        HyChartAlgorithmContext.handleRSI([key integerValue], (id<HyChartKLineModelDataSourceProtocol>)self.dataSource.modelDataSource);
    }];
}

- (void)handleMaxMinValue {
    
    id<HyChartKLineConfigureProtocol> configure = (id)self.dataSource.configreDataSource.configure;
    [self.dataSource.modelDataSource.models enumerateObjectsUsingBlock:^(id<HyChartKLineModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
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
                NSNumber *rsiParams = configure.rsiDict.allKeys.firstObject;
                double rsiValue =  obj.priceRSI([rsiParams integerValue]).doubleValue;
                maxValue = rsiValue;
                minValue = rsiValue;
            } break;
            default:
            break;
        }
        obj.maxAuxiliary = [NSNumber numberWithDouble:maxValue];
        obj.minAuxiliary = [NSNumber numberWithDouble:minValue];
    }];
}

- (HyChartKLineAuxiliaryLayer *)chartLayer {
    if (!_chartLayer){
        _chartLayer = [HyChartKLineAuxiliaryLayer layerWithDataSource:self.dataSource];
    }
    return _chartLayer;
}

- (id<HyChartKLineDataSourceProtocol>)dataSource {
    if (!_dataSource){
        _dataSource = [[HyChartKLineDataSource alloc] init];
    }
    return _dataSource;
}

- (id<HyChartKLineModelProtocol>)model {
    return HyChartKLineModel.new;
}

- (void)switchKLineAuxiliaryType:(HyChartKLineAuxiliaryType)type {
    
    self.auxiliaryType = type;
    self.chartLayer.auxiliaryType = type;
    self.dataSource.modelDataSource.auxiliaryType = type;
}

- (NSNumberFormatter *)yAxisNunmberFormatter {
    return self.dataSource.configreDataSource.configure.volumeNunmberFormatter;
}

@end
