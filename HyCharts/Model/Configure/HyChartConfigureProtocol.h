//
//  HyChartConfigureProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HyChartsTypedef.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyChartConfigureProtocol <NSObject>

/// 值柱体宽度 (线条可不设)
@property (nonatomic, assign) CGFloat width;
/// 值间距
@property (nonatomic, assign) CGFloat margin;
/// 是否自动算margin 正好铺满
@property (nonatomic, assign) BOOL autoMargin;
/// 开始边距
@property (nonatomic, assign) CGFloat edgeInsetStart;
/// 结束边距
@property (nonatomic, assign) CGFloat edgeInsetEnd;
/// 数据展示方向
@property (nonatomic, assign) HyChartRenderingDirection renderingDirection;
/// 数据不够 / 放大缩小 不能完全铺满时，靠哪一边 (默认靠左)
@property (nonatomic, assign) HyChartNotEnoughSide notEnoughSide;


/// 偏移量
@property (nonatomic, assign) CGFloat trans;
/// 当前缩放值
@property (nonatomic, assign) CGFloat scale;
/// 最小缩放值
@property (nonatomic, assign) CGFloat minScale;
/// 最大缩放值
@property (nonatomic, assign) CGFloat maxScale;
/// 当前展示范围
@property (nonatomic, assign) CGFloat displayWidth;
/// 最小展示范围(优先级别高于minScale)
@property (nonatomic, assign) CGFloat minDisplayWidth;
/// 最大展示范围(优先级别高于maxScale)
@property (nonatomic, assign) CGFloat maxDisplayWidth;

/// 精度
@property (nonatomic, assign) NSInteger decimal;
@property (nonatomic, strong, readonly) NSNumberFormatter *numberFormatter;

@end



NS_ASSUME_NONNULL_END
