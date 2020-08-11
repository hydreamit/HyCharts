//
//  HyChartAxisLayer.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/19.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HyChartDataSource.h"
#import "HyChartLayer.h"


NS_ASSUME_NONNULL_BEGIN

@interface HyChartAxisLayer : HyChartLayer<HyChartDataSource *>

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

+ (instancetype)layerWithDataSource:(HyChartDataSource *)dataSource
                         xAxisModel:(HyChartXAxisModel *)xAxisModel
                         yAxisModel:(HyChartYAxisModel *)yAxisModel;

@end

NS_ASSUME_NONNULL_END
