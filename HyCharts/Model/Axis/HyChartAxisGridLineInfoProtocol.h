//
//  HyChartAxisGridLineInfoProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/20.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartsTypedef.h"
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/// 坐标轴网格
@protocol HyChartAxisGridLineInfoProtocol <NSObject>

#pragma mark - 坐标轴网格属性

/// 网格颜色
@property (nonatomic, strong) UIColor *axisGridLineColor;
/// 网格线宽
@property (nonatomic, assign) CGFloat axisGridLineWidth;
/// 虚线模板起始位置
@property (nonatomic, assign) CGFloat axisGridLineDashPhase;
/// 虚线模板数组
@property (nonatomic, strong) NSArray<NSNumber *> *axisGridLineDashPattern;
/// 网格样式
@property (nonatomic,assign) HyChartAxisLineType axisGridLineType;

@end

NS_ASSUME_NONNULL_END
