//
//  HyChartKLineMainView.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartKLineMainView.h"
#import "HyChartKLineMainLayer.h"
#import "HyChartKLineDataSource.h"
#import "HyChartKLineModel.h"
#import "HyChartAlgorithmContext.h"
#import "HyChartsMethods.h"


@interface HyChartKLineMainView ()
@property (nonatomic, assign) CGFloat chartWidth;
@property (nonatomic, strong) HyChartKLineMainLayer *chartLayer;
@property (nonatomic, assign) HyChartKLineTechnicalType technicalType;
@property (nonatomic, strong) id<HyChartKLineDataSourceProtocol> dataSource;
@end


@implementation HyChartKLineMainView
@dynamic technicalType;

- (void)handleVisibleModelsWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {

    __block double maxValue = 0;
    __block double minValue = 0;
    __block id<HyChartKLineModelProtocol> maxModel = nil;
    __block id<HyChartKLineModelProtocol> minModel = nil;
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
        
         if (!maxModel || !minModel) {
             maxModel = obj;
             minModel = obj;
             maxValue = obj.maxPrice.doubleValue;
             minValue = obj.minPrice.doubleValue;
         } else {
             if (obj.highPrice.doubleValue > maxModel.highPrice.doubleValue) {
                 maxModel = obj;
             }
             if (obj.lowPrice.doubleValue < minModel.lowPrice.doubleValue) {
                 minModel = obj;
             }
             maxValue = MAX(maxValue, obj.maxPrice.doubleValue);
             minValue = MIN(minValue, obj.minPrice.doubleValue);
         }
    }];
    
    self.dataSource.modelDataSource.maxValue = [NSNumber numberWithDouble:maxValue];
    self.dataSource.modelDataSource.minValue = [NSNumber numberWithDouble:minValue];
    self.dataSource.modelDataSource.visibleMaxPriceModel = maxModel;
    self.dataSource.modelDataSource.visibleMinPriceModel = minModel;
}

- (void)handleTechnicalData {
    
     id<HyChartKLineConfigureProtocol> configure = (id)self.dataSource.configreDataSource.configure;
    
    [configure.smaDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
        HyChartAlgorithmContext.handleSMA([key integerValue], (id<HyChartKLineModelDataSourceProtocol>)self.dataSource.modelDataSource);
    }];
    
    [configure.emaDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
        HyChartAlgorithmContext.handleEMA([key integerValue], (id<HyChartKLineModelDataSourceProtocol>)self.dataSource.modelDataSource);
    }];
    
    [configure.bollDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSArray<UIColor *> * _Nonnull obj, BOOL * _Nonnull stop) {
        HyChartAlgorithmContext.handleBOLL([key integerValue], (id<HyChartKLineModelDataSourceProtocol>)self.dataSource.modelDataSource);
    }];
}

- (void)handleMaxMinValue {
    
    id<HyChartKLineConfigureProtocol> klineConfigure = self.dataSource.configreDataSource.configure;
    [self.dataSource.modelDataSource.models enumerateObjectsUsingBlock:^(id<HyChartKLineModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        __block double maxPrice = obj.highPrice.doubleValue;
        __block double minPrice = obj.lowPrice.doubleValue;
        
        switch (self.technicalType) {
            case HyChartKLineTechnicalTypeSMA: {
                [klineConfigure.smaDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull color, BOOL * _Nonnull stop) {
                    maxPrice = MAX(obj.priceSMA([key integerValue]).doubleValue, maxPrice);
                    minPrice = MIN(obj.priceSMA([key integerValue]).doubleValue, minPrice);
                }];
            } break;
            case HyChartKLineTechnicalTypeEMA: {
                [klineConfigure.emaDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull color, BOOL * _Nonnull stop) {
                    maxPrice = MAX(obj.priceEMA([key integerValue]).doubleValue, maxPrice);
                    minPrice = MIN(obj.priceEMA([key integerValue]).doubleValue, minPrice);
                }];
            } break;
            case HyChartKLineTechnicalTypeBOLL: {
                [klineConfigure.bollDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSArray<UIColor *> * _Nonnull colors, BOOL * _Nonnull stop) {
                    maxPrice = MAX(obj.priceBoll([key integerValue], @"up").doubleValue, maxPrice);
                    minPrice = MIN(obj.priceBoll([key integerValue], @"dn").doubleValue, minPrice);
                }];
            } break;
            default:
            break;
        }

        obj.maxPrice = [NSNumber numberWithDouble:maxPrice];
        obj.minPrice = [NSNumber numberWithDouble:minPrice];
    }];
}

- (HyChartKLineMainLayer *)chartLayer {
    if (!_chartLayer){
        _chartLayer = [HyChartKLineMainLayer layerWithDataSource:self.dataSource];
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

- (void)switchKLineTechnicalType:(HyChartKLineTechnicalType)type {
    
    
    self.technicalType = type;
    self.chartLayer.technicalType = type;
    self.dataSource.modelDataSource.klineMianTechnicalType = type;
}

- (void)setTimeLine:(BOOL)timeLine {
    _timeLine = timeLine;
    self.chartLayer.timeLine = timeLine;
}

- (NSNumberFormatter *)yAxisNunmberFormatter {
    return self.dataSource.configreDataSource.configure.priceNunmberFormatter;
}

@end
