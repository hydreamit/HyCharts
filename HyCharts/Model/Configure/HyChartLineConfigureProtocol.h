//
//  HyChartLineConfigureProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartConfigureProtocol.h"
#import "HyChartsTypedef.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyChartLineOneConfigureProtocol <NSObject>
/// 线条颜色
@property (nonatomic, strong) UIColor *lineColor;
/// 线宽度 默认1.0
@property (nonatomic, assign) CGFloat lineWidth;
/// 虚线模板起始位置
@property (nonatomic, assign) CGFloat lineDashPhase;
/// 虚线模板数组
@property (nonatomic, strong) NSArray<NSNumber *> *lineDashPattern;
/// 线样式
@property (nonatomic, assign) HyChartLineType lineType;
/// 值点线宽度
@property (nonatomic, assign) CGFloat linePointWidth;
/// 值点大小
@property (nonatomic, assign) CGSize linePointSize;
/// 值点Stroke颜色
@property (nonatomic, strong) UIColor *linePointStrokeColor;
/// 值点Fill颜色
@property (nonatomic, strong) UIColor *linePointFillColor;
/// 值点样式
@property (nonatomic, assign) HyChartLinePointType linePointType;
/// 阴影渐变颜色数组 >= 3
@property (nonatomic, strong) NSArray<UIColor *> *shadeColors;


/// 是否展示最新数据 默认YES
@property (nonatomic, assign) BOOL disPlayNewvalue;
/// 最新数据文字颜色 默认灰色
@property (nonatomic, strong) UIColor *newvalueColor;
/// 最新数据文字字体 默认12
@property (nonatomic, strong) UIFont *newvalueFont;


/// 是否展示最大最小数据 默认YES
@property (nonatomic, assign) BOOL disPlayMaxMinValue;
/// 最大最小数据文字颜色 默认灰色
@property (nonatomic, strong) UIColor *maxminValueColor;
/// 最大最小数据文字字体。默认10
@property (nonatomic, strong) UIFont *maxminValueFont;


@end


@protocol HyChartLineConfigureProtocol <HyChartConfigureProtocol>

- (instancetype)configLineConfigureAtIndex:(void(^)(NSInteger index, id<HyChartLineOneConfigureProtocol> oneConfigure))block;


@end

NS_ASSUME_NONNULL_END



