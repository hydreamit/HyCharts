//
//  HyChartLineDataSource.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartDataSource.h"
#import "HyChartLineDataSourceProtocol.h"
#import "HyChartLineModelDataSource.h"
#import "HyChartLineConfigureDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartLineDataSource : HyChartDataSource<HyChartLineDataSourceProtocol>

@property (nonatomic, strong, readonly) HyChartAxisDataSource *axisDataSource;
@property (nonatomic, strong, readonly) HyChartLineModelDataSource *modelDataSource;
@property (nonatomic, strong, readonly) HyChartLineConfigureDataSource *configreDataSource;

@end

NS_ASSUME_NONNULL_END
