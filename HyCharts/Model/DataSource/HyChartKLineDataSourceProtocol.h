//
//  HyChartKLineDataSourceProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartDataSourceProtocol.h"
#import "HyChartKLineConfigureDataSourceProtocol.h"
#import "HyChartKLineModelDataSourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyChartKLineDataSourceProtocol <HyChartDataSourceProtocol>

/// view配置数据
@property (nonatomic, strong, readonly) id<HyChartKLineConfigureDataSourceProtocol> configreDataSource;
/// 模型数据
@property (nonatomic, strong, readonly) id<HyChartKLineModelDataSourceProtocol> modelDataSource;


@end

NS_ASSUME_NONNULL_END
