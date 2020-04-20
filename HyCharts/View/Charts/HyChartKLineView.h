//
//  HyChartKLineView.h
//  HyChartsDemo
//
//  Created by Hy on 2018/4/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartView.h"
#import "HyChartsTypedef.h"
#import "HyChartKLineDataSourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// K线图
@interface HyChartKLineView : HyChartView<id<HyChartKLineDataSourceProtocol>>

@property (nonatomic, assign, getter=isTimeLine) BOOL timeLine;

- (void)switchKLineTechnicalType:(HyChartKLineTechnicalType)type;

- (void)switchKLineAuxiliaryType:(HyChartKLineAuxiliaryType)type;

@end

NS_ASSUME_NONNULL_END
