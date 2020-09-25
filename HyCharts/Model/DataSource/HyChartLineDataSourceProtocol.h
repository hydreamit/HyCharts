//
//  HyChartLineDataSourceProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartDataSourceProtocol.h"
#import "HyChartLineModelDataSourceProtocol.h"
#import "HyChartLineConfigureDataSourceProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyChartLineDataSourceProtocol <HyChartDataSourceProtocol>

/// 图表配置数据
@property (nonatomic, strong, readonly) id<HyChartLineConfigureDataSourceProtocol> configreDataSource;
/// 图表模型数据
@property (nonatomic, strong, readonly) id<HyChartLineModelDataSourceProtocol> modelDataSource;

@end

NS_ASSUME_NONNULL_END
