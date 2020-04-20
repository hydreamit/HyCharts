//
//  HyChartLineView.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartView.h"
#import "HyChartLineDataSourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN


/// 单一折/曲线图
@interface HyChartLineView : HyChartView<id<HyChartLineDataSourceProtocol>>


@end

NS_ASSUME_NONNULL_END
