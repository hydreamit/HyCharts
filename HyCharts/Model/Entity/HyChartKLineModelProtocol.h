//
//  HyChartKLineModelProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartModelProtocol.h"


typedef NS_ENUM(NSUInteger, HyChartKLineTrend) {
    HyChartKLineTrendUp,
    HyChartKLineTrendDown,
    HyChartKLineTrendEqual,
};


NS_ASSUME_NONNULL_BEGIN

@protocol HyVolumeChartModelProtocol;
@protocol HyChartKLineModelProtocol <HyChartModelProtocol>

/// 时间
@property (nonatomic, copy) NSString *time;
/// 最高价
@property (nonatomic, strong) NSNumber *highPrice;
/// 最低价
@property (nonatomic, strong) NSNumber *lowPrice;
/// 开盘价
@property (nonatomic, strong) NSNumber *openPrice;
/// 收盘价
@property (nonatomic, strong) NSNumber *closePrice;
/// 成交量
@property (nonatomic, strong) NSNumber *volume;
/// 成交额
@property (nonatomic, strong) NSNumber *amount;
/// 涨跌幅度百分比
@property (nonatomic, strong) NSNumber *trendPercent;
/// 涨跌额
@property (nonatomic, strong) NSNumber *trendChanging;
/// 换手率
@property (nonatomic, strong) NSNumber *turnoverrate;

/// 涨/跌
@property (nonatomic, assign, readonly) HyChartKLineTrend trend;


/*
 分时图线条设置 默认是一条线 ---->  @[收盘价]
 */
/// 自定义 方式一  直接赋值
@property (nonatomic, strong) NSArray<NSNumber *> *values;
/// 分时线断点设置, 默认为NO  —— @(YES) \ @(NO)
@property (nonatomic, strong) NSArray<NSNumber *> *breakpoints;
/// 自定义 方式 二  根据K线处理后数据设置
- (void)configTimeLineValues:(void (^)(id<HyChartKLineModelProtocol> _model))block;



@property (nonatomic, strong, readonly) NSNumberFormatter *priceNunmberFormatter;
@property (nonatomic, strong, readonly) NSNumberFormatter *volumeNunmberFormatter;

/// SMA
@property (nonatomic, copy, readonly) NSNumber *(^priceSMA)(NSInteger number);
@property (nonatomic, copy, readonly) NSNumber *(^volumeSMA)(NSInteger number);
@property (nonatomic, strong, readonly) NSMutableDictionary<NSNumber *, NSNumber *> *priceSMADict;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSNumber *, NSNumber *> *volumeSMADict;


/// EMA
@property (nonatomic, copy, readonly) NSNumber *(^priceEMA)(NSInteger number);
@property (nonatomic, copy, readonly) NSNumber *(^volumeEMA)(NSInteger number);
@property (nonatomic, strong, readonly) NSMutableDictionary<NSNumber *, NSNumber *> *priceEMADict;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSNumber *, NSNumber *> *volumeEMADict;


/// bollType : mb" , @"up", @"dn"
@property (nonatomic, copy, readonly) NSNumber *(^priceBoll)(NSInteger number, NSString *bollType);
@property (nonatomic, copy, readonly) NSNumber *(^volumeBoll)(NSInteger number, NSString *bollType);
@property (nonatomic, strong, readonly) NSMutableDictionary<NSNumber *, NSDictionary *> *priceBollDict;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSNumber *, NSDictionary *> *volumeBollDict;


/// MACD
@property (nonatomic, copy, readonly) NSNumber *(^priceDIF)(NSInteger number1, NSInteger number2);
@property (nonatomic, copy, readonly) NSNumber *(^priceDEM)(NSInteger number1, NSInteger number2, NSInteger number3);
@property (nonatomic, copy, readonly) NSNumber *(^priceMACD)(NSInteger number1, NSInteger number2, NSInteger number3);
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSNumber *> *priceDIFDict;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSNumber *> *priceDEMDict;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSNumber *> *priceMACDDict;


/// RSI
@property (nonatomic, copy, readonly) NSNumber *(^priceRSI)(NSInteger number);
@property (nonatomic, strong, readonly) NSMutableDictionary<NSNumber *, NSNumber *> *priceRSIDict;


/// KDJ
@property (nonatomic, copy, readonly) NSNumber *(^priceRSV)(NSInteger number);
@property (nonatomic, copy, readonly) NSNumber *(^priceK)(NSInteger number1, NSInteger number2);
@property (nonatomic, copy, readonly) NSNumber *(^priceD)(NSInteger number1, NSInteger number2, NSInteger number3);
@property (nonatomic, copy, readonly) NSNumber *(^priceJ)(NSInteger number1, NSInteger number2, NSInteger number3);
@property (nonatomic, strong, readonly) NSMutableDictionary<NSNumber *, NSNumber *> *priceRSVDict;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSNumber *> *priceKDict;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSNumber *> *priceDDict;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSNumber *> *priceJDict;

@end





NS_ASSUME_NONNULL_END
