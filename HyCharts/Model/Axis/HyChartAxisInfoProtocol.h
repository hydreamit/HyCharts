//
//  HyChartAxisInfoProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartsTypedef.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol HyChartAxisInfoProtocol <NSObject>


#pragma mark - 坐标轴上Text属性
/// 轴上文字字体
@property (nonatomic, strong) UIFont *axisTextFont;
/// 轴上文字颜色
@property (nonatomic, strong) UIColor *axisTextColor;
/// 轴上文字偏移量
@property (nonatomic, assign) CGPoint axisTextOffset;
/// 轴上文字旋转角度 [-PI/2, PI/2]之间
@property (nonatomic, assign) CGFloat rotateAngle;
/// 轴上文字位置
@property (nonatomic, assign) HyChartAxisTextPosition axisTextPosition;
/// 自动内部设置坐标轴文字(默认为YES), X轴文字(根据 HyChartModelProtocol 的设置的text)  Y轴文字(根据最大值和最小值平均分)
@property (nonatomic, assign) BOOL autoSetText;
/// 是否显示坐标原点文字
@property (nonatomic, assign) BOOL displayAxisZeroText;

#pragma mark - 坐标轴属性
/// 轴的颜色
@property (nonatomic, strong) UIColor *axisLineColor;
/// 轴线粗细
@property (nonatomic, assign) CGFloat axisLineWidth;
/// 虚线模板起始位置
@property (nonatomic, assign) CGFloat axisLineDashPhase;
/// 虚线模板数组
@property (nonatomic, strong) NSArray<NSNumber *> *axisLineDashPattern;
/// 轴线样式
@property (nonatomic,assign) HyChartAxisLineType axisLineType;

@end

NS_ASSUME_NONNULL_END
