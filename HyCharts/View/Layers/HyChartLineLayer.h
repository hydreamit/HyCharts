//
//  HyChartLineLayer.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/25.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartLayer.h"
#import "HyChartLineDataSourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartLineLayer : HyChartLayer<id<HyChartLineDataSourceProtocol>>

@end

NS_ASSUME_NONNULL_END
