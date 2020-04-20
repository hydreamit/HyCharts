//
//  HyChartKLineMainLayer.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartLayer.h"
#import "HyChartsTypedef.h"
#import "HyChartKLineDataSourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN


@interface HyChartKLineMainLayer : HyChartLayer<id<HyChartKLineDataSourceProtocol>>

@property (nonatomic, assign) HyChartKLineTechnicalType technicalType;

@property (nonatomic, assign, getter=isTimeLine) BOOL timeLine;

@end

NS_ASSUME_NONNULL_END
