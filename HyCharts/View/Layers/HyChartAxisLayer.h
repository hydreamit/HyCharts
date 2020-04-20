//
//  HyChartAxisLayer.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/19.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HyChartDataSourceProtocol.h"
#import "HyChartLayer.h"


NS_ASSUME_NONNULL_BEGIN

@interface HyChartAxisLayer : HyChartLayer<id<HyChartDataSourceProtocol>>

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

+ (instancetype)layerWithDataSource:(id<HyChartDataSourceProtocol>)dataSource
                         xAxisModel:(id<HyChartXAxisModelProtocol>)xAxisModel
                         yAxisModel:(id<HyChartYAxisModelProtocol>)yAxisModel;

@end

NS_ASSUME_NONNULL_END
