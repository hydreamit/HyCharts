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
@end


@protocol HyChartLineConfigureProtocol <HyChartConfigureProtocol>

- (instancetype)configLineConfigureAtIndex:(void(^)(NSInteger index, id<HyChartLineOneConfigureProtocol> oneConfigure))block;

@property (nonatomic, copy, readonly) void(^lineConfigureAtIndexBlock)(NSInteger, id<HyChartLineOneConfigureProtocol>);

@end

NS_ASSUME_NONNULL_END



