//
//  HyChartBarDataSourceProtocol.h
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartDataSourceProtocol.h"
#import "HyChartBarModelDataSourceProtocol.h"
#import "HyChartBarConfigureDataSourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyChartBarDataSourceProtocol <HyChartDataSourceProtocol>

/// 图表配置数据
@property (nonatomic, strong, readonly) id<HyChartBarConfigureDataSourceProtocol> configreDataSource;
/// 图表模型数据
@property (nonatomic, strong, readonly) id<HyChartBarModelDataSourceProtocol> modelDataSource;

@end

NS_ASSUME_NONNULL_END
