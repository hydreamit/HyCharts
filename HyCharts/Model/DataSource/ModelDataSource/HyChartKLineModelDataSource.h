//
//  HyChartKLineModelDataSource.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartModelDataSource.h"
#import "HyChartKLineModelDataSourceProtocol.h"
#import "HyChartKLineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartKLineModelDataSource : HyChartModelDataSource<HyChartKLineModel *><HyChartKLineModelDataSourceProtocol>

@property (nonatomic, strong) HyChartKLineModel *visibleMaxPriceModel;
@property (nonatomic, strong) HyChartKLineModel *visibleMinPriceModel;
@property (nonatomic, strong) HyChartKLineModel *visibleMaxVolumeModel;
@property (nonatomic, strong) HyChartKLineModel *visibleMinVolumeModel;

@property (nonatomic, strong) NSNumber *maxPrice;
@property (nonatomic, strong) NSNumber *minPrice;
@property (nonatomic, strong) NSNumber *maxVolume;
@property (nonatomic, strong) NSNumber *minVolume;
@property (nonatomic, strong) NSNumber *maxAuxiliary;
@property (nonatomic, strong) NSNumber *minAuxiliary;
@property (nonatomic, strong) NSArray<NSMutableArray<NSNumber *> *> *valuesArray;
@property (nonatomic, strong) NSNumberFormatter *priceNunmberFormatter;
@property (nonatomic, strong) NSNumberFormatter *volumeNunmberFormatter;
@property (nonatomic, copy, readonly) NSNumber *(^maxValueWithViewType)(HyChartKLineViewType type);
@property (nonatomic, copy, readonly) NSNumber *(^minValueWithViewType)(HyChartKLineViewType type);
@property (nonatomic, assign) HyChartKLineTechnicalType klineMianTechnicalType;
@property (nonatomic, assign) HyChartKLineTechnicalType klineVolumeTechnicalType;
@property (nonatomic, assign) HyChartKLineAuxiliaryType auxiliaryType;

@end

NS_ASSUME_NONNULL_END
