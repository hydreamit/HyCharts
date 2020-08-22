//
//  HyChartsTypedef.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/20.
//  Copyright © 2018 Hy. All rights reserved.
//

#ifndef HyChartsTypedef_h
#define HyChartsTypedef_h
#import <Foundation/Foundation.h>


/// 坐标轴上text 位置
typedef NS_ENUM (NSUInteger, HyChartAxisTextPosition) {
    /// 轴的正方向 （X轴下边, Y轴右边）
    HyChartAxisTextPositionPlus,
    /// 轴的负方向 （X轴上边, Y轴左边）
    HyChartAxisTextPositionBinus
};

/// 坐标线条样式
typedef NS_ENUM (NSUInteger, HyChartAxisLineType) {
    /// 实线
    HyChartAxisLineTypeSolid,
    /// 虚线
    HyChartAxisLineTypeDash,
    /// 隐藏
    HyChartAxisLineTypeNone
};

/// 简单 ChartLine 线条样式
typedef NS_ENUM (NSUInteger, HyChartLineType) {
    /// 折线
    HyChartLineTypeStraight,
    /// 曲线
    HyChartLineTypeCurve,
};

/// 简单 ChartLine 值点样式
typedef NS_ENUM (NSUInteger, HyChartLinePointType) {
    /// 无
    HyChartLinePointTypeNone,
    /// 方形
    HyChartLinePointTypeRect,
    /// 圆形
    HyChartLinePointTypeCircel,
    /// 圆环
    HyChartLinePointTypeRing
};


/// 数据渲染方向
typedef NS_ENUM (NSUInteger, HyChartRenderingDirection) {
    /// x轴正向渲染 —— 第一条数据在最左边 往右渲染
    HyChartRenderingDirectionForward,
    /// x轴逆向展示—— 第一条数据在最右边 往左渲染
    HyChartRenderingDirectionReverse
};


/// 数据不够 / 放大缩小 不能完全铺满时，靠哪一边
typedef NS_ENUM (NSUInteger, HyChartNotEnoughSide) {
    /// 靠左边
    HyChartNotEnoughSideLeft,
    /// 靠右边
    HyChartNotEnoughSideRight
};


/// 游标状态
typedef NS_ENUM (NSUInteger, HyChartCursorState) {
    /// 将要展示
    HyChartCursorStateWillShowing,
    /// 长按滚动展示
    HyChartCursorStateScrollShowing,
    /// 结束展示
    HyChartCursorStateDidEndShowing
};


/// K线图种类
typedef NS_ENUM (NSUInteger, HyChartKLineViewType) {
    /// 主图
    HyChartKLineViewTypeMain,
    /// 交易量图
    HyChartKLineViewTypeVolume,
    /// K线辅助图
    HyChartKLineViewTypeAuxiliary,
};


/// K线样式
typedef NS_ENUM (NSUInteger, HyChartKLineType) {
    /// 填充
    HyChartKLineTypeFill,
    /// 空心
    HyChartKLineTypeStroke,
};


/// K线主图技术指标线
typedef NS_ENUM (NSUInteger, HyChartKLineTechnicalType) {

    HyChartKLineTechnicalTypeNone,
    /// SMA线
    HyChartKLineTechnicalTypeSMA,
    /// EMA线
    HyChartKLineTechnicalTypeEMA,
    /// BOLL线
    HyChartKLineTechnicalTypeBOLL,
};

/// K线辅助图
typedef NS_ENUM (NSUInteger, HyChartKLineAuxiliaryType) {
//    HyChartKLineAuxiliaryTypeNone,
    /// MCAD
    HyChartKLineAuxiliaryTypeMACD,
    /// KDJ
    HyChartKLineAuxiliaryTypeKDJ,
    /// RSI
    HyChartKLineAuxiliaryTypeRSI,
};


#endif /* HyChartsTypedef_h */
