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

/// K线组装图 ------- K线主图 、交易量图、辅助图
@interface HyChartKLineView : HyChartView<id<HyChartKLineDataSourceProtocol>>


/// 是否是分时线
@property (nonatomic, assign, getter=isTimeLine) BOOL timeLine;

/// 切换K线主图技术指标
- (void)switchKLineTechnicalType:(HyChartKLineTechnicalType)type;

/// 切换辅助图技术指标
- (void)switchKLineAuxiliaryType:(HyChartKLineAuxiliaryType)type;

@end

NS_ASSUME_NONNULL_END
