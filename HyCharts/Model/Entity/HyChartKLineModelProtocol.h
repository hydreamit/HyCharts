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


@property (nonatomic, strong) NSNumber *maxPrice;
@property (nonatomic, strong) NSNumber *minPrice;
@property (nonatomic, strong) NSNumber *maxVolume;
@property (nonatomic, strong) NSNumber *minVolume;
@property (nonatomic, strong) NSNumber *maxAuxiliary;
@property (nonatomic, strong) NSNumber *minAuxiliary;

@property (nonatomic, strong) NSNumberFormatter *priceNunmberFormatter;
@property (nonatomic, strong) NSNumberFormatter *volumeNunmberFormatter;

@end





NS_ASSUME_NONNULL_END
