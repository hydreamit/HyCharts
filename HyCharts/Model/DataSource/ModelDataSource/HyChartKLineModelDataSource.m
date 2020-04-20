//
//  HyChartKLineModelDataSource.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartKLineModelDataSource.h"
#import "HyChartKLineModelProtocol.h"

@interface HyChartKLineModelDataSource ()
@property (nonatomic, copy) void (^modelForItemAtIndexBlock)(id<HyChartKLineModelProtocol> model, NSInteger index);
@end


@implementation HyChartKLineModelDataSource
@synthesize visibleModels = _visibleModels, visibleXAxisModels = _visibleXAxisModels, visibleMaxPriceModel = _visibleMaxPriceModel, visibleMinPriceModel = _visibleMinPriceModel, visibleMaxVolumeModel = _visibleMaxVolumeModel, visibleMinVolumeModel = _visibleMinVolumeModel, maxPrice = _maxPrice , minPrice = _minPrice, maxVolume = _maxVolume, minVolume = _minVolume, maxAuxiliary = _maxAuxiliary, minAuxiliary = _minAuxiliary, models = _models, priceNunmberFormatter = _priceNunmberFormatter, volumeNunmberFormatter = _volumeNunmberFormatter;

- (instancetype)configModelForItemAtIndex:(void (^_Nullable)(id<HyChartKLineModelProtocol> model, NSInteger index))block {
    
    self.modelForItemAtIndexBlock = [block copy];
    return self;
}

- (NSNumber * _Nonnull (^)(HyChartKLineViewType))maxValueWithViewType {
    return ^NSNumber *(HyChartKLineViewType type){
        NSNumber *number = 0;
        switch (type) {
            case HyChartKLineViewTypeMain: {
                number = self.maxPrice;
            }break;
            case HyChartKLineViewTypeVolume: {
                number = self.maxVolume;
            }break;
            case HyChartKLineViewTypeAuxiliary: {
                number = self.maxAuxiliary;
            }break;
            default:
            break;
        }
        return number;
    };
}

- (NSNumber * _Nonnull (^)(HyChartKLineViewType))minValueWithViewType {
    return ^NSNumber *(HyChartKLineViewType type){
        NSNumber *number = 0;
        switch (type) {
            case HyChartKLineViewTypeMain: {
                number = self.minPrice;
            }break;
            case HyChartKLineViewTypeVolume: {
                number = self.minVolume;
            }break;
            case HyChartKLineViewTypeAuxiliary: {
                number = self.minAuxiliary;
            }break;
            default:
            break;
        }
        return number;
    };
}

- (NSArray<id<HyChartKLineModelProtocol>> *)models {
    if (!_models){
        _models = @[].mutableCopy;
    }
    return _models;
}

@end
