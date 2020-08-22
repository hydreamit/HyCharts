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


/// 是否禁用左侧Y轴 默认为NO
@property (nonatomic, assign) BOOL leftYAxisDisabled;
/// 是否禁用右侧Y轴 默认为YES
@property (nonatomic, assign) BOOL rightYAaxisDisabled;


/// 下边界溢出值的比例
@property (nonatomic, strong) NSNumber *yAxisMinValueExtraPrecent;
/// 上边界溢出值的比例
@property (nonatomic, strong) NSNumber *yAxisMaxValueExtraPrecent;


/// 设置固定最大值, yAxisMinValueExtraPrecent 失效
- (id<HyChartYAxisModelProtocol>)configYAxisMinValue:(NSNumber *(^)(void))block;
/// 设置固定最小值 yAxisMaxValueExtraPrecent 失效
- (id<HyChartYAxisModelProtocol>)configYAxisMaxValue:(NSNumber *(^)(void))block;


/// 配置基本信息
- (id<HyChartYAxisModelProtocol>)configLeftYAxisInfo:(void(^)(id<HyChartYAxisInfoProtocol> yAxisInfo))block;
/// 配置数据
- (id<HyChartYAxisModelProtocol>)configRightYAxisInfo:(void(^)(id<HyChartYAxisInfoProtocol> yAxisInfo))block;


@end

NS_ASSUME_NONNULL_END
