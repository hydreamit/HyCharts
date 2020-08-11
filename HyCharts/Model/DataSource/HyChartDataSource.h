//
//  HyChartDataSource.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartDataSourceProtocol.h"
#import "HyChartModelDataSource.h"
#import "HyChartConfigureDataSource.h"
#import "HyChartAxisDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartDataSource : NSObject<HyChartDataSourceProtocol>

@property (nonatomic, strong, readonly) HyChartAxisDataSource *axisDataSource;
@property (nonatomic, strong, readonly) HyChartModelDataSource *modelDataSource;
@property (nonatomic, strong, readonly) HyChartConfigureDataSource *configreDataSource;

@end


NS_ASSUME_NONNULL_END
