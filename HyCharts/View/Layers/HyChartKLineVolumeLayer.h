//
//  HyChartKLineVolumeLayer.h
//  DemoCode
//
//  Created by Hy on 2018/3/31.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartLayer.h"
#import "HyChartsTypedef.h"
#import "HyChartKLineDataSourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartKLineVolumeLayer : HyChartLayer<id<HyChartKLineDataSourceProtocol>>

@property (nonatomic,assign) HyChartKLineTechnicalType technicalType;

@end

NS_ASSUME_NONNULL_END
