//
//  HyChartYAxisModel.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import "HyChartYAxisModelProtocol.h"
#import "HyChartAxisModel.h"
#import "HyChartYAxisInfo.h"


NS_ASSUME_NONNULL_BEGIN

/// Y 轴数据
@interface HyChartYAxisModel : HyChartAxisModel<HyChartYAxisModelProtocol>

@property (nonatomic, strong) NSNumber *yAxisMinValue;
@property (nonatomic, strong) NSNumber *yAxisMaxValue;

@property (nonatomic, copy, readonly) NSNumber *(^yAxisMinValueBlock)(void);
@property (nonatomic, copy, readonly) NSNumber *(^yAxisMaxValueBlock)(void);

@property (nonatomic, strong, readonly) id<HyChartYAxisInfoProtocol> leftYAxisInfo;
@property (nonatomic, strong, readonly) id<HyChartYAxisInfoProtocol> rightYAxisInfo;

@end

NS_ASSUME_NONNULL_END
