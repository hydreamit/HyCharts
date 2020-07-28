//
//  HyChartLayer.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/20.
//  Copyright © 2018 Hy. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "HyChartLayerProtocol.h"
#import "HyChartDataSourceProtocol.h"
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


@interface HyChartLayer<__covariant DataSourceType : id<HyChartDataSourceProtocol>> : CALayer<HyChartLayerProtocol, HyChartValuePositonProviderProtocol>

+ (instancetype)layerWithDataSource:(DataSourceType)dataSource;

- (DataSourceType)dataSource;

@end

NS_ASSUME_NONNULL_END
