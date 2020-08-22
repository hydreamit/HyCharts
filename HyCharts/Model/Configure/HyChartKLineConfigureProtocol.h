//
//  HyChartKLineConfigureProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartLineConfigureProtocol.h"
#import <Foundation/Foundation.h>
#import "HyChartConfigureProtocol.h"
#import "HyChartsTypedef.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyChartKLineConfigureProtocol <HyChartConfigureProtocol>


/// 上影线、下影线、实体空心线、技术指标线 宽度
@property (nonatomic, assign) CGFloat lineWidth;
/// 当缩小时 线宽是否跟着缩小 默认NO
//@property (nonatomic, assign) BOOL lineWidthCanScale;
/// 上涨颜色
@property (nonatomic, strong) UIColor *trendUpColor;
/// 下跌颜色
@property (nonatomic, strong) UIColor *trendDownColor;
/// 上涨样式 填充/空心
@property (nonatomic, assign) HyChartKLineType trendUpKlineType;
/// 下跌样式 填充/空心
@property (nonatomic, assign) HyChartKLineType trendDownKlineType;


/// 分时线时 技术指标数据需不需要处理 默认NO
@property (nonatomic,assign) BOOL timeLineHandleTechnicalData;
/// 每条线的配置
- (instancetype)configLineConfigureAtIndex:(void(^)(NSInteger index, id<HyChartLineOneConfigureProtocol> oneConfigure))block;


/// 缩放到最小值变折线图(默认为YES)
@property (nonatomic, assign) BOOL minScaleToLine;
/// 缩放到最小值则线颜色
@property (nonatomic, strong) UIColor *minScaleLineColor;
/// 缩放到最小值则线宽度
@property (nonatomic, assign) CGFloat minScaleLineWidth;
/// 阴影渐变颜色数组 >= 3
@property (nonatomic, strong) NSArray<UIColor *> *minScaleLineShadeColors;


/// 是否展示最新价 默认YES
@property (nonatomic, assign) BOOL disPlayNewprice;
/// 最新价文字颜色 默认灰色
@property (nonatomic, strong) UIColor *newpriceColor;
/// 最新价文字字体 默认12
@property (nonatomic, strong) UIFont *newpriceFont;


/// 是否展示最高最底价 默认YES
@property (nonatomic, assign) BOOL disPlayMaxMinPrice;
/// 最高最底价文字颜色 默认灰色
@property (nonatomic, strong) UIColor *maxminPriceColor;
/// 最高最底价文字字体。默认10
@property (nonatomic, strong) UIFont *maxminPriceFont;


/// 价格精度
@property (nonatomic, assign) NSInteger priceDecimal;
/// 成交量精度
@property (nonatomic, assign) NSInteger volumeDecimal;
/// 价格格式转化器
@property (nonatomic, strong, readonly) NSNumberFormatter *priceNunmberFormatter;
/// 成交量格式转化器
@property (nonatomic, strong, readonly) NSNumberFormatter *volumeNunmberFormatter;


/// key : HyChartKLineViewType   value : 高度
@property (nonatomic, strong) NSDictionary<NSNumber *, NSNumber *> *klineViewDict;


/// 配置 SMA 值 和 对应 的 颜色
@property (nonatomic, strong) NSDictionary<NSNumber *, UIColor *> *smaDict;
/// 配置 EMA 值 和 对应 的 颜色
@property (nonatomic, strong) NSDictionary<NSNumber *, UIColor *> *emaDict;
/// 布林轨道 (上轨 中轨 下轨)
@property (nonatomic, strong) NSDictionary<NSNumber *, NSArray<UIColor *> *> *bollDict;


/// 配置 MACD 技术指标参数(NSArray 个数三个) 和 线条颜色数组(dif线颜色， dem线颜色, MACD 正值柱颜色 和 负值柱颜色)
@property (nonatomic, strong) NSDictionary<NSArray<NSNumber *> *, NSArray<UIColor *> *> *macdDict;
/// 配置 RSI 技术指标参数 和 线条颜色 最多三条
@property (nonatomic, strong) NSDictionary<NSNumber *, UIColor *> *rsiDict;
/// 配置 KDJ 技术指标参数(NSArray 个数三个) 和 线条颜色数组(K、D、J线颜色)
@property (nonatomic, strong) NSDictionary<NSArray<NSNumber *> *, NSArray<UIColor *> *> *kdjDict;


@end

NS_ASSUME_NONNULL_END
