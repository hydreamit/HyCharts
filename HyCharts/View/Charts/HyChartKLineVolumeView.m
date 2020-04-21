//
//  HyChartKLineVolumeView.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartKLineVolumeView.h"
#import "HyChartKLineVolumeLayer.h"
#import "HyChartKLineDataSource.h"
#import "HyChartKLineModel.h"
#import "HyChartAlgorithmContext.h"
#import "HyChartsMethods.h"


@interface HyChartKLineVolumeView ()
@property (nonatomic, assign) CGFloat chartWidth;
@property (nonatomic, strong) HyChartKLineVolumeLayer *chartLayer;
@property (nonatomic, assign) HyChartKLineTechnicalType technicalType;
@property (nonatomic, strong) id<HyChartKLineDataSourceProtocol> dataSource;
@end


@implementation HyChartKLineVolumeView
@dynamic technicalType;

- (void)handleVisibleModelsWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    
    __block double maxValue = 0;
    __block double minValue = 0;
    __block id<HyChartKLineModelProtocol> maxModel = nil;
    __block id<HyChartKLineModelProtocol> minModel = nil;
    id<HyChartKLineConfigureProtocol> configure = self.dataSource.configreDataSource.configure;
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
             maxValue = obj.maxVolume.doubleValue;
             minValue = MIN(0, obj.minVolume.doubleValue);
         } else {
             if (obj.volume.doubleValue > maxModel.volume.doubleValue) {
                 maxModel = obj;
             } else
             if (obj.volume.doubleValue < maxModel.volume.doubleValue) {
                 minModel = obj;
             }
             maxValue = MAX(maxValue, obj.maxVolume.doubleValue);
             minValue = MIN(minValue, obj.minVolume.doubleValue);
         }
    }];
    
    self.dataSource.modelDataSource.maxValue = [NSNumber numberWithDouble:maxValue];
    self.dataSource.modelDataSource.minValue = @(0);
    self.dataSource.modelDataSource.visibleMaxVolumeModel = maxModel;
    self.dataSource.modelDataSource.visibleMinVolumeModel = minModel;
}

- (void)handleTechnicalData {
    
     id<HyChartKLineConfigureProtocol> configure = self.dataSource.configreDataSource.configure;
    
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
        
        __block double maxVolume = obj.volume.doubleValue;
        __block double minVolume = 0;
        
        switch (self.technicalType) {
            case HyChartKLineTechnicalTypeSMA: {
                [klineConfigure.smaDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull color, BOOL * _Nonnull stop) {
                    maxVolume = MAX(obj.volumeSMA([key integerValue]).doubleValue, maxVolume);
                    minVolume = MIN(obj.volumeSMA([key integerValue]).doubleValue, minVolume);
                }];
            } break;
            case HyChartKLineTechnicalTypeEMA: {
                [klineConfigure.emaDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull color, BOOL * _Nonnull stop) {
                    maxVolume = MAX(obj.volumeEMA([key integerValue]).doubleValue, maxVolume);
                    minVolume = MIN(obj.volumeEMA([key integerValue]).doubleValue, minVolume);
                }];
            } break;
            case HyChartKLineTechnicalTypeBOLL: {
                [klineConfigure.bollDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSArray<UIColor *> * _Nonnull colors, BOOL * _Nonnull stop) {
                    maxVolume = MAX(obj.volumeBoll([key integerValue], @"up").doubleValue, maxVolume);
                    minVolume = MIN(obj.volumeBoll([key integerValue], @"dn").doubleValue, minVolume);
                }];
            } break;
            default:
            break;
        }
        obj.maxVolume = [NSNumber numberWithDouble:maxVolume];
        obj.minVolume = [NSNumber numberWithDouble:minVolume];
    }];
}

- (HyChartKLineVolumeLayer *)chartLayer {
    if (!_chartLayer){
        _chartLayer = [HyChartKLineVolumeLayer layerWithDataSource:self.dataSource];
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
    if (type != HyChartKLineTechnicalTypeBOLL) {
        self.technicalType = type;
        self.chartLayer.technicalType = type;
        self.dataSource.modelDataSource.klineVolumeTechnicalType = type;
    }
}

- (NSNumberFormatter *)yAxisNunmberFormatter {
    return self.dataSource.configreDataSource.configure.volumeNunmberFormatter;
}

@end
