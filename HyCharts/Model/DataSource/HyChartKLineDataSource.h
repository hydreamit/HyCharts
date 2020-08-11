//
//  HyChartKLineDataSource.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartDataSource.h"
#import "HyChartKLineDataSourceProtocol.h"
#import "HyChartKLineConfigureDataSource.h"
#import "HyChartKLineModelDataSource.h"


NS_ASSUME_NONNULL_BEGIN

@interface HyChartKLineDataSource : HyChartDataSource<HyChartKLineDataSourceProtocol>

@property (nonatomic, strong, readonly) HyChartAxisDataSource *axisDataSource;
@property (nonatomic, strong, readonly) HyChartKLineModelDataSource *modelDataSource;
@property (nonatomic, strong, readonly) HyChartKLineConfigureDataSource *configreDataSource;

@end

NS_ASSUME_NONNULL_END
