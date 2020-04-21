//
//  HyChartKLineAuxiliaryLayer.h
//  DemoCode
//
//  Created by Hy on 2018/4/1.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartLayer.h"
#import "HyChartsTypedef.h"
#import "HyChartKLineDataSourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN


@interface HyChartKLineAuxiliaryLayer : HyChartLayer<id<HyChartKLineDataSourceProtocol>>

@property (nonatomic, assign) HyChartKLineAuxiliaryType auxiliaryType;

@end

NS_ASSUME_NONNULL_END
