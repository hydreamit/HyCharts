//
//  HyChartLayer.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/20.
//  Copyright © 2018 Hy. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "HyChartLayerProtocol.h"
#import "HyChartDataSource.h"
#import <UIKit/UIKit.h>
#import "HyChartModel.h"


NS_ASSUME_NONNULL_BEGIN


@interface HyChartLayer<__covariant DataSourceType : HyChartDataSource *> : CALayer<HyChartLayerProtocol, HyChartValuePositonProviderProtocol>

+ (instancetype)layerWithDataSource:(DataSourceType)dataSource;

- (DataSourceType)dataSource;

@end

NS_ASSUME_NONNULL_END
