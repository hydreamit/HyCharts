//
//  HyChartYAxisModelProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartYAxisInfoProtocol.h"
#import "HyChartAxisModelProtocol.h"
#import "HyChartModelProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyChartYAxisModelProtocol <HyChartAxisModelProtocol>


/// Y轴的最小值
@property (nonatomic, strong) NSNumber *yAxisMinValue;
/// Y轴的最大值
@property (nonatomic, strong) NSNumber *yAxisMaxValue;
/// 下边界溢出值的比例
@property (nonatomic, strong) NSNumber *yAxisMinValueExtraPrecent;
/// 上边界溢出值的比例
@property (nonatomic, strong) NSNumber *yAxisMaxValueExtraPrecent;



/// 是否禁用左侧Y轴 默认为NO
@property (nonatomic, assign) BOOL leftYAxisDisabled;
/// 是否禁用右侧Y轴 默认为YES
@property (nonatomic, assign) BOOL rightYAaxisDisabled;


/// 配置基本信息
- (id<HyChartYAxisModelProtocol>)configLeftYAxisInfo:(void(^)(id<HyChartYAxisInfoProtocol> yAxisInfo))block;
/// 配置数据
- (id<HyChartYAxisModelProtocol>)configRightYAxisInfo:(void(^)(id<HyChartYAxisInfoProtocol> yAxisInfo))block;

- (id<HyChartYAxisModelProtocol>)configYAxisMinValue:(NSNumber *(^)(void))block;
- (id<HyChartYAxisModelProtocol>)configYAxisMaxValue:(NSNumber *(^)(void))block;
@property (nonatomic, copy, readonly) NSNumber *(^yAxisMinValueBlock)(void);
@property (nonatomic, copy, readonly) NSNumber *(^yAxisMaxValueBlock)(void);

@property (nonatomic, strong, readonly) id<HyChartYAxisInfoProtocol> leftYAxisInfo;
@property (nonatomic, strong, readonly) id<HyChartYAxisInfoProtocol> rightYAxisInfo;


@end

NS_ASSUME_NONNULL_END
