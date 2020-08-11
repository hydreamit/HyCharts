//
//  HyChartAxisDataSource.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartAxisDataSourceProtocol.h"
#import "HyChartXAxisModel.h"
#import "HyChartYAxisModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 坐标轴数据源
@interface HyChartAxisDataSource : NSObject<HyChartAxisDataSourceProtocol>

@property (nonatomic, strong, readonly) HyChartXAxisModel *xAxisModel;
@property (nonatomic, strong, readonly) HyChartYAxisModel *yAxisModel;

@property (nonatomic, strong, readonly) HyChartXAxisModel *(^xAxisModelWityViewType)(HyChartKLineViewType type);
@property (nonatomic, strong, readonly) HyChartYAxisModel *(^yAxisModelWityViewType)(HyChartKLineViewType type);

@end

NS_ASSUME_NONNULL_END
