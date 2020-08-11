//
//  HyChartBarDataSource.h
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartDataSource.h"
#import "HyChartBarDataSourceProtocol.h"
#import "HyChartBarModelDataSource.h"
#import "HyChartBarConfigureDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartBarDataSource : HyChartDataSource<HyChartBarDataSourceProtocol>

@property (nonatomic, strong, readonly) HyChartAxisDataSource *axisDataSource;
@property (nonatomic, strong, readonly) HyChartBarModelDataSource *modelDataSource;
@property (nonatomic, strong, readonly) HyChartBarConfigureDataSource *configreDataSource;

@end

NS_ASSUME_NONNULL_END
