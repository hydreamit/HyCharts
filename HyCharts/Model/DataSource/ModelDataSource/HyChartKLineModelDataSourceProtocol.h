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

/// 模型数组
@property (nonatomic, strong, readonly) NSMutableArray<id<HyChartKLineModelProtocol>> *models;
/// 可见跨度的模型数组
@property (nonatomic, strong, readonly) NSArray<id<HyChartKLineModelProtocol>> *visibleModels;
/// 可见跨度的靠近X轴点的模型数组
@property (nonatomic, strong, readonly) NSArray<id<HyChartKLineModelProtocol>> *visibleXAxisModels;

/// 可见最大值模型
@property (nonatomic, strong, readonly) id<HyChartKLineModelProtocol> visibleMaxPriceModel;
/// 可见最小值模型
@property (nonatomic, strong, readonly) id<HyChartKLineModelProtocol> visibleMinPriceModel;
/// 可见最大值模型
@property (nonatomic, strong, readonly) id<HyChartKLineModelProtocol> visibleMaxVolumeModel;
/// 可见最小值模型
@property (nonatomic, strong, readonly) id<HyChartKLineModelProtocol> visibleMinVolumeModel;

@property (nonatomic, assign, readonly) HyChartKLineTechnicalType klineMianTechnicalType;
@property (nonatomic, assign, readonly) HyChartKLineTechnicalType klineVolumeTechnicalType;
@property (nonatomic, assign, readonly) HyChartKLineAuxiliaryType auxiliaryType;
@property (nonatomic, strong, readonly) NSNumberFormatter *priceNunmberFormatter;
@property (nonatomic, strong, readonly) NSNumberFormatter *volumeNunmberFormatter;

@end

NS_ASSUME_NONNULL_END
