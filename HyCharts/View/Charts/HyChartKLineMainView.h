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


- (void)switchKLineTechnicalType:(HyChartKLineTechnicalType)type;

@property (nonatomic, assign, getter=isTimeLine) BOOL timeLine;


@end


NS_ASSUME_NONNULL_END
