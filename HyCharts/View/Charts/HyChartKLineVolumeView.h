//
//  HyChartKLineVolumeView.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartView.h"
#import "HyChartsTypedef.h"
#import "HyChartKLineDataSourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN


/// K线交易量图
@interface HyChartKLineVolumeView : HyChartView<id<HyChartKLineDataSourceProtocol>>

/// 切换技术指标
- (void)switchKLineTechnicalType:(HyChartKLineTechnicalType)type;


@end

NS_ASSUME_NONNULL_END
