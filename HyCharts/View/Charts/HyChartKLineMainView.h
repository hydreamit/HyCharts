//
//  HyChartKLineMainView.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartView.h"
#import "HyChartsTypedef.h"
#import "HyChartKLineDataSourceProtocol.h"


NS_ASSUME_NONNULL_BEGIN

/// K线主图
@interface HyChartKLineMainView : HyChartView<id<HyChartKLineDataSourceProtocol>>

/// 是否是分时线
@property (nonatomic, assign, getter=isTimeLine) BOOL timeLine;

/// 切换K线主图技术指标
- (void)switchKLineTechnicalType:(HyChartKLineTechnicalType)type;


@end


NS_ASSUME_NONNULL_END
