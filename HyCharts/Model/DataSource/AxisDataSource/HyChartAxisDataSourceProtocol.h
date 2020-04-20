//
//  HyChartAxisDataSourceProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartXAxisModelProtocol.h"
#import "HyChartYAxisModelProtocol.h"
#import "HyChartAxisGridLineInfoProtocol.h"
#import "HyChartsTypedef.h"


NS_ASSUME_NONNULL_BEGIN

/// 坐标轴数据源
@protocol HyChartAxisDataSourceProtocol <NSObject>


/// 配置X轴数据
- (id<HyChartAxisDataSourceProtocol>)configXAxisWithModel:(void(^)(id<HyChartXAxisModelProtocol> xAxisModel))block;

/// 配置Y轴数据
- (id<HyChartAxisDataSourceProtocol>)configYAxisWithModel:(void(^)(id<HyChartYAxisModelProtocol> yAxisModel))block;


/// X轴数据
@property (nonatomic, strong, readonly) id<HyChartXAxisModelProtocol> xAxisModel;
/// X轴数据
@property (nonatomic, strong, readonly) id<HyChartYAxisModelProtocol> yAxisModel;


/// 使用HyChartKlineView 需要配置对应视图的Y轴数据
- (id<HyChartAxisDataSourceProtocol>)configYAxisWithModelAndViewType:(void(^)(id<HyChartYAxisModelProtocol> yAxisModel, HyChartKLineViewType type))block;
@property (nonatomic, strong, readonly) id<HyChartYAxisModelProtocol>(^yAxisModelWityViewType)(HyChartKLineViewType type);
@property (nonatomic, strong, readonly) id<HyChartXAxisModelProtocol>(^xAxisModelWityViewType)(HyChartKLineViewType type);

@end

NS_ASSUME_NONNULL_END
