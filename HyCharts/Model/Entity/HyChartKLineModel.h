//
//  HyChartKLineModel.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartModel.h"
#import "HyChartKLineModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartKLineModel : HyChartModel<HyChartKLineModelProtocol>

@property (nonatomic, strong) NSNumber *maxPrice;
@property (nonatomic, strong) NSNumber *minPrice;
@property (nonatomic, strong) NSNumber *maxVolume;
@property (nonatomic, strong) NSNumber *minVolume;
@property (nonatomic, strong) NSNumber *maxAuxiliary;
@property (nonatomic, strong) NSNumber *minAuxiliary;
@property (nonatomic, strong) NSNumberFormatter *priceNunmberFormatter;
@property (nonatomic, strong) NSNumberFormatter *volumeNunmberFormatter;

@property (nonatomic,copy,readonly) void (^timeLineValuesBlock)(HyChartKLineModel *model);

@end

NS_ASSUME_NONNULL_END
