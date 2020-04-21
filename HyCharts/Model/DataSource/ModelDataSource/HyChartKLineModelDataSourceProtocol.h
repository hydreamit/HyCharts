//
//  HyChartKLineModelDataSourceProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartKLineModelProtocol.h"
#import "HyChartModelDataSourceProtocol.h"
#import "HyChartsTypedef.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyChartKLineModelDataSourceProtocol <HyChartModelDataSourceProtocol>


- (instancetype)configModelForItemAtIndex:(void (^_Nullable)(id<HyChartKLineModelProtocol> model, NSInteger index))block;

@property (nonatomic, copy, readonly) void (^modelForItemAtIndexBlock)(id<HyChartKLineModelProtocol> model, NSInteger index);




@property (nonatomic, strong) NSMutableArray<id<HyChartKLineModelProtocol>> *models;

/// 可见跨度的模型数组
@property (nonatomic, strong) NSArray<id<HyChartKLineModelProtocol>> *visibleModels;
/// 可见跨度的靠近X轴点的模型数组
@property (nonatomic, strong) NSArray<id<HyChartKLineModelProtocol>> *visibleXAxisModels;


/// 可见最大值模型
@property (nonatomic, strong) id<HyChartKLineModelProtocol> visibleMaxPriceModel;
/// 可见最小值模型
@property (nonatomic, strong) id<HyChartKLineModelProtocol> visibleMinPriceModel;
/// 可见最大值模型
@property (nonatomic, strong) id<HyChartKLineModelProtocol> visibleMaxVolumeModel;
/// 可见最小值模型
@property (nonatomic, strong) id<HyChartKLineModelProtocol> visibleMinVolumeModel;



@property (nonatomic, strong) NSNumber *maxPrice;
@property (nonatomic, strong) NSNumber *minPrice;
@property (nonatomic, strong) NSNumber *maxVolume;
@property (nonatomic, strong) NSNumber *minVolume;
@property (nonatomic, strong) NSNumber *maxAuxiliary;
@property (nonatomic, strong) NSNumber *minAuxiliary;
@property (nonatomic, strong) NSNumberFormatter *priceNunmberFormatter;
@property (nonatomic, strong) NSNumberFormatter *volumeNunmberFormatter;
@property (nonatomic, copy, readonly) NSNumber *(^maxValueWithViewType)(HyChartKLineViewType type);
@property (nonatomic, copy, readonly) NSNumber *(^minValueWithViewType)(HyChartKLineViewType type);
@property (nonatomic, assign) HyChartKLineTechnicalType klineMianTechnicalType;
@property (nonatomic, assign) HyChartKLineTechnicalType klineVolumeTechnicalType;
@property (nonatomic, assign) HyChartKLineAuxiliaryType auxiliaryType;
@end

NS_ASSUME_NONNULL_END
