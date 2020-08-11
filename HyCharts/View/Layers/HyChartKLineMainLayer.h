//
//  HyChartKLineMainLayer.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartLayer.h"
#import "HyChartsTypedef.h"
#import "HyChartKLineDataSource.h"

NS_ASSUME_NONNULL_BEGIN


@interface HyChartKLineMainLayer : HyChartLayer<HyChartKLineDataSource *>

@property (nonatomic, assign) HyChartKLineTechnicalType technicalType;

@property (nonatomic, assign, getter=isTimeLine) BOOL timeLine;

- (void)renderingNewprice;

@end

NS_ASSUME_NONNULL_END
