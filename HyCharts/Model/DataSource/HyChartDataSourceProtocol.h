//
//  HyChartDataSourceProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartAxisDataSourceProtocol.h"
#import "HyChartConfigureDataSourceProtocol.h"
#import "HyChartModelDataSourceProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyChartDataSourceProtocol <NSObject>

/// 坐标轴数据
@property (nonatomic, strong, readonly) id<HyChartAxisDataSourceProtocol> axisDataSource;

/// view配置数据
- (id<HyChartConfigureDataSourceProtocol>)configreDataSource;
/// 模型数据
- (id<HyChartModelDataSourceProtocol>)modelDataSource;


@end

NS_ASSUME_NONNULL_END
