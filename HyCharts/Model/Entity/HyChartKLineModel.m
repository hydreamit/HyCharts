//
//  HyChartKLineModel.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartKLineModel.h"
#import "HyChartsMethods.h"


@interface HyChartKLineModel ()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *priceSMADict;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *volumeSMADict;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *priceEMADict;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *volumeEMADict;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSDictionary *> *priceBollDict;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSDictionary *> *volumeBollDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *priceDIFDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *priceDEMDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *priceMACDDict;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *priceRSIDict;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *priceRSVDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *priceKDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *priceDDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *priceJDict;
@property (nonatomic, copy) void (^timeLineValuesBlock)(HyChartKLineModel *model);
@end


@implementation HyChartKLineModel
@synthesize highPrice = _highPrice, lowPrice = _lowPrice, openPrice = _openPrice, closePrice = _closePrice, volume = _volume, amount = _amount, trend = _trend, trendPercent = _trendPercent, trendChanging = _trendChanging, turnoverrate = _turnoverrate, time = _time,values = _values, breakpoints = _breakpoints;;

- (void)setHighPrice:(NSNumber *)highPrice {
    _highPrice = SafetyNumber([NSDecimalNumber decimalNumberWithString:[self.priceNunmberFormatter stringFromNumber:highPrice]]);
    _maxPrice = _highPrice;
}

- (void)configTimeLineValues:(void (^)(id<HyChartKLineModelProtocol> _Nonnull))block {
    self.timeLineValuesBlock = [block copy];
}

- (void)handleModel {
    if (!self.timeLineValuesBlock) {
        self.values = @[self.closePrice ?: @0];
    }
}

- (void)setValues:(NSArray<NSNumber *> *)values {
    
    __block NSNumber *maxVaule = nil;
    __block NSNumber *minVaule = nil;
    NSMutableArray<NSNumber *> *mArray = @[].mutableCopy;
    [values enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *numberString = [self.priceNunmberFormatter stringFromNumber:obj];
        NSNumber *deNumber = SafetyNumber([NSDecimalNumber decimalNumberWithString:numberString]);
        [mArray addObject:deNumber];
        maxVaule = maxVaule ? MaxNumber(maxVaule, deNumber) : deNumber;
        minVaule = minVaule ? MinNumber(minVaule, deNumber) : deNumber;
    }];
    
    _values = mArray.copy;
    self.maxValue = maxVaule;
    self.minValue = minVaule;
}

- (void)setLowPrice:(NSNumber *)lowPrice {
    _lowPrice = SafetyNumber([NSDecimalNumber decimalNumberWithString:[self.priceNunmberFormatter stringFromNumber:lowPrice]]);
    _minPrice = _lowPrice;
}

- (void)setClosePrice:(NSNumber *)closePrice {
    _closePrice = SafetyNumber([NSDecimalNumber decimalNumberWithString:[self.priceNunmberFormatter stringFromNumber:closePrice]]);
}

- (void)setOpenPrice:(NSNumber *)openPrice {
    _openPrice = SafetyNumber([NSDecimalNumber decimalNumberWithString:[self.priceNunmberFormatter stringFromNumber:openPrice]]);
}

- (void)setVolume:(NSNumber *)volume {
    _volume = SafetyNumber([NSDecimalNumber decimalNumberWithString:[self.volumeNunmberFormatter stringFromNumber:volume]]);
    _maxVolume = volume;
}

- (NSNumber * (^)(NSInteger))priceSMA {
    return ^NSNumber *(NSInteger number) {
        return self.priceSMADict[[NSNumber numberWithInteger:number]];
    };
}

- (NSNumber * (^)(NSInteger))volumeSMA {
    return ^NSNumber *(NSInteger number) {
        return self.volumeSMADict[[NSNumber numberWithInteger:number]];
    };
}

- (NSNumber * (^)(NSInteger))priceEMA {
    return ^NSNumber *(NSInteger number) {
        return self.priceEMADict[[NSNumber numberWithInteger:number]];
    };
}

- (NSNumber * (^)(NSInteger))volumeEMA {
    return ^NSNumber *(NSInteger number) {
        return self.volumeEMADict[[NSNumber numberWithInteger:number]];
    };
}

- (NSNumber * (^)(NSInteger, NSString * _Nonnull))priceBoll {
    return ^NSNumber *(NSInteger number, NSString * _Nonnull bollType){
        return self.priceBollDict[[NSNumber numberWithInteger:number]][bollType];
    };
}

- (NSNumber * (^)(NSInteger, NSString * _Nonnull))volumeBoll {
    return ^NSNumber *(NSInteger number, NSString * _Nonnull bollType){
        return self.volumeBollDict[[NSNumber numberWithInteger:number]][bollType];
    };
}

- (NSNumber * (^)(NSInteger, NSInteger))priceDIF {
    return ^NSNumber * (NSInteger number1, NSInteger number2) {
        NSString *key = [NSString stringWithFormat:@"%ld+%ld", (long)number1, (long)number2];
        return self.priceDIFDict[key];
    };
}

- (NSNumber * (^)(NSInteger, NSInteger, NSInteger))priceDEM {
    return ^NSNumber * (NSInteger number1, NSInteger number2, NSInteger number3) {
        NSString *key = [NSString stringWithFormat:@"%ld+%ld+%ld", (long)number1, (long)number2, (long)number3];
        return self.priceDEMDict[key];
    };
}

- (NSNumber * (^)(NSInteger, NSInteger, NSInteger))priceMACD {
    return ^NSNumber * (NSInteger number1, NSInteger number2, NSInteger number3) {
        NSString *key = [NSString stringWithFormat:@"%ld+%ld+%ld", (long)number1, (long)number2, (long)number3];
        return self.priceMACDDict[key];
    };
}

- (NSNumber * (^)(NSInteger))priceRSI {
    return ^NSNumber * (NSInteger number) {
        return self.priceRSIDict[[NSNumber numberWithInteger:number]];
    };
}


- (NSNumber * (^)(NSInteger))priceRSV {
    return ^NSNumber * (NSInteger number) {
        return self.priceRSVDict[[NSNumber numberWithInteger:number]];
    };
}

- (NSNumber * (^)(NSInteger, NSInteger))priceK {
    return ^NSNumber * (NSInteger number1, NSInteger number2) {
         NSString *key = [NSString stringWithFormat:@"%ld+%ld", (long)number1, (long)number2];
         return self.priceKDict[key];
    };
}

- (NSNumber * (^)(NSInteger, NSInteger, NSInteger))priceD {
    return ^NSNumber * (NSInteger number1, NSInteger number2, NSInteger number3) {
         NSString *key = [NSString stringWithFormat:@"%ld+%ld+%ld", (long)number1, (long)number2, (long)number3];
         return self.priceDDict[key];
    };
}

- (NSNumber * (^)(NSInteger, NSInteger, NSInteger))priceJ {
    return ^NSNumber * (NSInteger number1, NSInteger number2, NSInteger number3) {
         NSString *key = [NSString stringWithFormat:@"%ld+%ld+%ld", (long)number1, (long)number2, (long)number3];
         return self.priceJDict[key];
    };
}

- (NSMutableDictionary<NSNumber *,NSNumber *> *)priceSMADict {
    if (!_priceSMADict){
        _priceSMADict = @{}.mutableCopy;
    }
    return _priceSMADict;
}

- (NSMutableDictionary<NSNumber *,NSNumber *> *)volumeSMADict {
    if (!_volumeSMADict){
        _volumeSMADict = @{}.mutableCopy;
    }
    return _volumeSMADict;
}

- (NSMutableDictionary<NSNumber *,NSNumber *> *)priceEMADict {
    if (!_priceEMADict){
        _priceEMADict = @{}.mutableCopy;
    }
    return _priceEMADict;
}

- (NSMutableDictionary<NSNumber *,NSNumber *> *)volumeEMADict {
    if (!_volumeEMADict){
        _volumeEMADict = @{}.mutableCopy;
    }
    return _volumeEMADict;
}

- (NSMutableDictionary<NSNumber *,NSDictionary *> *)priceBollDict {
    if (!_priceBollDict){
        _priceBollDict = @{}.mutableCopy;
    }
    return _priceBollDict;
}

- (NSMutableDictionary<NSNumber *,NSDictionary *> *)volumeBollDict {
    if (!_volumeBollDict){
        _volumeBollDict = @{}.mutableCopy;
    }
    return _volumeBollDict;
}

- (NSMutableDictionary<NSString *,NSNumber *> *)priceDIFDict {
    if (!_priceDIFDict){
        _priceDIFDict = @{}.mutableCopy;
    }
    return _priceDIFDict;
}

- (NSMutableDictionary<NSString *,NSNumber *> *)priceDEMDict {
    if (!_priceDEMDict){
        _priceDEMDict = @{}.mutableCopy;
    }
    return _priceDEMDict;
}

- (NSMutableDictionary<NSString *,NSNumber *> *)priceMACDDict {
    if (!_priceMACDDict){
        _priceMACDDict = @{}.mutableCopy;
    }
    return _priceMACDDict;
}

- (NSMutableDictionary<NSNumber *,NSNumber *> *)priceRSIDict {
    if (!_priceRSIDict){
        _priceRSIDict = @{}.mutableCopy;
    }
    return _priceRSIDict;
}

- (NSMutableDictionary<NSNumber *,NSNumber *> *)priceRSVDict {
    if (!_priceRSVDict){
        _priceRSVDict = @{}.mutableCopy;
    }
    return _priceRSVDict;
}

- (NSMutableDictionary<NSString *,NSNumber *> *)priceKDict {
    if (!_priceKDict){
        _priceKDict = @{}.mutableCopy;
    }
    return _priceKDict;
}

- (NSMutableDictionary<NSString *,NSNumber *> *)priceDDict {
    if (!_priceDDict){
        _priceDDict = @{}.mutableCopy;
    }
    return _priceDDict;
}

- (NSMutableDictionary<NSString *,NSNumber *> *)priceJDict {
    if (!_priceJDict){
        _priceJDict = @{}.mutableCopy;
    }
    return _priceJDict;
}

- (HyChartKLineTrend)trend {
    
    if (self.openPrice.floatValue > self.closePrice.floatValue) {
        return HyChartKLineTrendDown;
    } else if (self.openPrice.floatValue < self.closePrice.floatValue) {
        return HyChartKLineTrendUp;
    } else {
        if (self.trendChanging.floatValue > 0) {
            return HyChartKLineTrendUp;
        } else if (self.trendChanging.floatValue < 0) {
            return HyChartKLineTrendDown;
        } else {
            return HyChartKLineTrendEqual;
        }
    }
}

- (NSArray<NSNumber *> *)breakpoints {
    if (_breakpoints.count != self.values.count) {
        NSMutableArray<NSNumber *> *array = @[].mutableCopy;
        for (NSInteger i = 0; i < self.values.count; i++) {
            [array addObject:@(NO)];
        }
        _breakpoints = array.copy;
    }
    return _breakpoints;
}

//- (NSNumber *)value {
//    return self.highPrice;
//}

@end
