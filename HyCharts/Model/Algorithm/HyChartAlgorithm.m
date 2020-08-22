//
//  HyChartAlgorithm.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartAlgorithm.h"
#import "HyChartKLineModel.h"
#import "HyChartsMethods.h"


@implementation HyChartAlgorithm

//  SMA(简单均线) SMA(n) = (C1+C2+C3+…+Cn) / n   Cn第前n个周期的收盘价
- (void (^)(NSInteger number,HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleSMA {
    return ^(NSInteger number, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex) {
        
        NSInteger count = modelDataSource.models.count;
        if (rangeIndex > count) {
            return;
        }
        
        NSArray<HyChartKLineModel *> *models = modelDataSource.models;
        models = [[models reverseObjectEnumerator] allObjects];
        
        if (rangeIndex == 0) {
            if (models.lastObject.priceSMADict[@(number)] &&
                models.lastObject.volumeSMADict[@(number)]) {
                return ;
            }
        }
        
        if (rangeIndex != 0) {
            rangeIndex = count - rangeIndex;
        }
        [models enumerateObjectsUsingBlock:^(HyChartKLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >= rangeIndex) {
                NSArray<NSNumber *> *array = self.samAtIndex(number, idx, models);
                [obj.priceSMADict setObject:array.firstObject
                                     forKey:@(number)];
                [obj.volumeSMADict setObject:array.lastObject
                                      forKey:@(number)];
            }
        }];
    };
}

// EMA 指数均线 EMA(n) = 2 / (n+1) * (本周期收盘价 - 上一周期EMAn) + 上一周期EMA
- (void (^)(NSInteger number,HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleEMA {
    return ^(NSInteger number,HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex) {
        
        NSInteger count = modelDataSource.models.count;
        if (rangeIndex > count) {
            return;
        }
        
        NSArray<HyChartKLineModel *> *models = modelDataSource.models;
        models = [[models reverseObjectEnumerator] allObjects];
        
        if (rangeIndex == 0) {
            if (models.lastObject.priceEMADict[@(number)] ||
                models.lastObject.priceEMADict[@(number)]) {
                return ;
            }
        }
        
        if (rangeIndex != 0) {
            rangeIndex = count - rangeIndex;
        }
        
        double emaPrice = 0;
        double emaVolume = 0;
        for (HyChartKLineModel *model in models) {
            
            NSInteger index = [models indexOfObject:model];
            
            if (index >= rangeIndex) {
                // EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
                double ratio = 2.0 / (number + 1);
                if (index) {
                     emaPrice = ratio * (model.closePrice.doubleValue - emaPrice) +  emaPrice;
                     emaVolume = ratio * (model.volume.doubleValue - emaVolume) +  emaVolume;
                } else {
                    emaPrice = model.closePrice.doubleValue;
                    emaVolume = model.volume.doubleValue;
                }
        
               [model.priceEMADict setObject:SafetyNumber([NSDecimalNumber decimalNumberWithString:[model.priceNunmberFormatter stringFromNumber:[NSNumber numberWithDouble:emaPrice]]])
                                      forKey:@(number)];
                
               [model.volumeEMADict setObject:SafetyNumber([NSDecimalNumber decimalNumberWithString:[model.volumeNunmberFormatter stringFromNumber:[NSNumber numberWithDouble:emaVolume]]])
                                               forKey:@(number)];
            }
        }
    };
}

/*
mb 中轨线 = N日的移动平均线SMA(N)
up 上轨线 = 中轨线 + 两倍的标准差
dn 下轨线 = 中轨线 －两倍的标准差
md 标准差 =  平方根( ((N）日的（C－SMA）的两次方之和) / N )
 */
- (void (^)(NSInteger number,HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleBOLL {
    return ^(NSInteger number,HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex) {
        
        NSInteger count = modelDataSource.models.count;
        if (rangeIndex > count) {
            return;
        }
        
        NSArray<HyChartKLineModel *> *models = modelDataSource.models;
        models = [[models reverseObjectEnumerator] allObjects];
        
        if (rangeIndex == 0) {
            if (models.lastObject.priceBollDict[@(number)] ||
                models.lastObject.volumeBollDict[@(number)]) {
                return ;
            }
        }
        
        if (rangeIndex != 0) {
            rangeIndex = count - rangeIndex;
        }

        [models enumerateObjectsUsingBlock:^(HyChartKLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >= rangeIndex) {
                NSArray *bollArray = self.bollAtIndex(number, idx, models);
                [obj.priceBollDict setObject:bollArray.firstObject
                                      forKey:@(number)];
                [obj.volumeBollDict setObject:bollArray.lastObject
                                      forKey:@(number)];
            }
        }];
    };
}

/**
 DIF(偏离值线) = 快的指数移动平均线EMA(12) - 慢的指数移动平均线 EMA(26)
 DEM(讯号线) =  DIF的N日指数移动平均值 EMA(9 DIF)
 MACD(柱) = 2 * (DIF - DEM)
 */
- (void (^)(NSInteger number1, NSInteger number2, NSInteger number3, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleMACD {
    return ^(NSInteger number1, NSInteger number2, NSInteger number3, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex) {
        
        NSInteger count = modelDataSource.models.count;
        if (rangeIndex > count) {
            return;
        }
        
        NSArray<HyChartKLineModel *> *models = modelDataSource.models;
        models = [[models reverseObjectEnumerator] allObjects];
        
        self.handleEMA(number1, modelDataSource, rangeIndex);
        self.handleEMA(number2, modelDataSource, rangeIndex);
        
        
        if (rangeIndex != 0) {
            rangeIndex = count - rangeIndex;
        }
        
        // DIF(偏离值线) = 快的指数移动平均线EMA(12) - 慢的指数移动平均线 EMA(26)
        NSString *difKey = [NSString stringWithFormat:@"%ld+%ld", (long)number1, (long)number2];
        BOOL updateDif = YES;
        if (rangeIndex == 0) {
            updateDif = ![models.lastObject.priceDIFDict objectForKey:difKey];
        }
        if (updateDif) {
            [models enumerateObjectsUsingBlock:^(HyChartKLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx >= rangeIndex) {
                    [obj.priceDIFDict setObject:[NSNumber numberWithDouble:obj.priceEMA(number1).doubleValue - obj.priceEMA(number2).doubleValue]
                    forKey:difKey];
                }
            }];
        }
        
        // DEM(讯号线) =  DIF的N日指数移动平均值 EMA(9 DIF)
        // MACD(柱) = 2 * (DIF - DEM)
        NSString *demdKey = [NSString stringWithFormat:@"%ld+%ld+%ld", (long)number1, (long)number2, (long)number3];
        BOOL updateMACD = YES;
        if (rangeIndex == 0) {
            updateMACD = ![models.lastObject.priceMACDDict objectForKey:demdKey];
        }
        if (updateMACD) {
            
              double difEMA = 0;
              for (HyChartKLineModel *model in models) {
                  NSInteger index = [models indexOfObject:model];
                  if (index >= rangeIndex) {
                      double dif = model.priceDIF(number1, number2).doubleValue;

                      // EMA（N）=2/（N+1）*（gif-昨日EMA）+昨日EMA；
                      double ratio = 2.0 / (number3 + 1);
                      if (index) {
                         difEMA = ratio * (dif - difEMA) +  difEMA;
                      } else {
                         difEMA = dif;
                      }
                      
                      [model.priceDEMDict setObject:SafetyNumber([NSDecimalNumber decimalNumberWithString:[model.priceNunmberFormatter stringFromNumber:[NSNumber numberWithDouble:difEMA]]])
                                             forKey:demdKey];
                      
                      [model.priceMACDDict setObject:SafetyNumber([NSDecimalNumber decimalNumberWithString:[model.priceNunmberFormatter stringFromNumber:[NSNumber numberWithDouble:(dif - difEMA) * 2]]])
                                             forKey:demdKey];
                  }
            }
        }
    };
}

/**
 (9, 3, 3)
 RSV(n)=（今日收盘价－n日内最低价）÷（n日内最高价－n日内最低价）× 100
 K(n)=（当日RSV值 + 前一日K值）÷ n
 D(n)=（当日K值 + 前一日D值）÷ n
 J = 3K－2D
 */
- (void (^)(NSInteger number1, NSInteger number2, NSInteger number3, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleKDJ {
    return ^(NSInteger number1, NSInteger number2, NSInteger number3, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex) {
        
        NSInteger count = modelDataSource.models.count;
        if (rangeIndex > count) {
            return;
        }
        
        NSArray<HyChartKLineModel *> *models = modelDataSource.models;
        models = [[models reverseObjectEnumerator] allObjects];
        
        if (rangeIndex != 0) {
            rangeIndex = count - rangeIndex;
        }
        
        double rsvValue  = 0, kValue = 0, dValue = 0, jValue = 0;
        for (HyChartKLineModel *model in models) {
            
            NSInteger index = [models indexOfObject:model];
            
            if (index >= rangeIndex) {
                double maxValue =  -MAXFLOAT;
                double minValue = MAXFLOAT;
                NSInteger startIndex = index - number1 + 1;
                if (startIndex < 0) { startIndex = 0; }
                for (NSInteger i = startIndex; i <= index; i++) {
                    maxValue = MAX(maxValue, models[i].highPrice.doubleValue);
                    minValue = MIN(minValue, models[i].lowPrice.doubleValue);
                }
                
                if (maxValue - minValue != 0) {
                    rsvValue = 100.0 * (model.closePrice.doubleValue - minValue) / (maxValue - minValue);
                } else {
                    rsvValue = 0;
                }
                if (index > 0) {
                    kValue = (rsvValue + 2 * kValue) / number2;
                    dValue = (kValue + 2 * dValue) / number3;
                    jValue = 3 * kValue - 2 * dValue;
                } else {
                   kValue = 50;
                   dValue = 50;
                   jValue = 50;
                }
                
                [model.priceRSVDict setObject:SafetyNumber([NSDecimalNumber decimalNumberWithString:[model.priceNunmberFormatter stringFromNumber:[NSNumber numberWithDouble:rsvValue]]])
                                       forKey:@(number1)];
                [model.priceKDict setObject:SafetyNumber([NSDecimalNumber decimalNumberWithString:[model.priceNunmberFormatter stringFromNumber:[NSNumber numberWithDouble:kValue]]])
                                     forKey:[NSString stringWithFormat:@"%ld+%ld", (long)number1, (long)number2]];
                [model.priceDDict setObject:SafetyNumber([NSDecimalNumber decimalNumberWithString:[model.priceNunmberFormatter stringFromNumber:[NSNumber numberWithDouble:dValue]]])
                                     forKey:[NSString stringWithFormat:@"%ld+%ld+%ld", (long)number1, (long)number2, (long)number3]];
                [model.priceJDict setObject:SafetyNumber([NSDecimalNumber decimalNumberWithString:[model.priceNunmberFormatter stringFromNumber:[NSNumber numberWithDouble:jValue]]])
                                     forKey:[NSString stringWithFormat:@"%ld+%ld+%ld", (long)number1, (long)number2, (long)number3]];
            }
        }
    };
}

/**
   A(n) n个周期中所有收盘价上涨数之和 / n    n参数：周期数    n是用户自定义参数  6,12,24
   B(n) = n个周期中所有收盘价下跌数之和 / n (取绝对值)
   RSI(n) = A(n) /(A(n) + B(n)) * 100
   RSI(N) = SMA(MAX(Close-LastClose,0) , N, 1) / SMA( ABS(Close-LastClose), N ,1) * 100
 */
- (void (^)(NSInteger number, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleRSI {
    return ^(NSInteger number, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex){
        
        NSInteger count = modelDataSource.models.count;
        if (rangeIndex > count) {
            return;
        }
        
        NSArray<HyChartKLineModel *> *models = modelDataSource.models;
        models = [[models reverseObjectEnumerator] allObjects];
        
        if (rangeIndex != 0) {
            rangeIndex = count - rangeIndex - 1;
        }
        
        double aValue = 0 , bValue = 0, rsiValue = 0;
        for (HyChartKLineModel *model in models) {
            NSInteger index = [models indexOfObject:model];
            if (index > rangeIndex) {
                double a = MAX(0, model.closePrice.doubleValue - models[index - 1].closePrice.doubleValue);
                double b = ABS((model.closePrice.doubleValue - models[index - 1].closePrice.doubleValue));
                aValue = (a + (number - 1) * aValue) / number;
                bValue = (b + (number - 1) * bValue) / number;
                rsiValue = (aValue / bValue) * 100;
                [model.priceRSIDict setObject:SafetyNumber([NSDecimalNumber decimalNumberWithString:[model.priceNunmberFormatter stringFromNumber:[NSNumber numberWithDouble:rsiValue]]])
                                       forKey:@(number)];
            }
        }
    };
}

- (NSArray<NSNumber *> *(^)(NSInteger , NSInteger , NSArray<HyChartKLineModel *> *))samAtIndex {
    return ^NSArray<NSNumber *> *(NSInteger number, NSInteger index, NSArray<HyChartKLineModel *> *models){
        
        double priceValue = 0.0;
        double volumeValue = 0.0;
        NSInteger totalNumber = 0;
        NSInteger minIndex = index - number;
        if (minIndex < 0) { minIndex = -1; }
        
        for (NSInteger i = index; i > minIndex; i--) {
            HyChartKLineModel *model = models[i];
            priceValue += model.closePrice.doubleValue;
            volumeValue += model.volume.doubleValue;
            totalNumber += 1;
        }
        
        priceValue = priceValue / totalNumber;
        volumeValue = volumeValue / totalNumber;
        
        return @[SafetyNumber([NSDecimalNumber decimalNumberWithString:[models.firstObject.priceNunmberFormatter stringFromNumber:[NSNumber numberWithDouble:priceValue]]]),
                 SafetyNumber([NSDecimalNumber decimalNumberWithString:[models.firstObject.priceNunmberFormatter stringFromNumber:[NSNumber numberWithDouble:volumeValue]]])];
    };
}

- (NSArray<NSDictionary *> *(^)(NSInteger , NSInteger , NSArray<HyChartKLineModel *> *))bollAtIndex {
    return ^NSArray<NSDictionary *> *(NSInteger number, NSInteger idx, NSArray<HyChartKLineModel *> *models) {

        double priceMb = 0.0;
        double volumeMb = 0.0;
        HyChartKLineModel *model = [models objectAtIndex:idx];
        if (model.priceSMADict[[NSNumber numberWithInteger:number]] &&
            model.volumeSMADict[[NSNumber numberWithInteger:number]]) {
            priceMb = model.priceSMA(number).doubleValue;
            volumeMb = model.volumeSMA(number).doubleValue;
        } else {
            NSArray *sma = self.samAtIndex(number, idx, models);
            priceMb = [sma.firstObject doubleValue];
            volumeMb = [sma.lastObject doubleValue];
        }

        double priceMd = 0;
        double volumeMd = 0;
        NSInteger totalNumber = 0;
        NSInteger minIndex = idx - number;
        if (minIndex < 0) { minIndex = -1; }

        for (NSInteger i = idx; i > minIndex; i--) {
            priceMd += pow(models[i].closePrice.doubleValue - priceMb, 2);
            volumeMd += pow(models[i].closePrice.doubleValue - volumeMb, 2);
            totalNumber += 1;
        }
        priceMd = 1.0 * priceMd / totalNumber;
        priceMd = sqrt(priceMd);

        volumeMd = 1.0 * volumeMd / totalNumber;
        volumeMd = sqrt(volumeMd);

        CGFloat k = 2.0;
        
        NSNumberFormatter *priceNunmberFormatter = models.firstObject.priceNunmberFormatter;
        NSNumber *priceMbNumber = SafetyNumber([NSDecimalNumber decimalNumberWithString:[priceNunmberFormatter stringFromNumber:[NSNumber numberWithDouble:priceMb]]]);
        NSNumber *priceUp = SafetyNumber([NSDecimalNumber decimalNumberWithString:[priceNunmberFormatter stringFromNumber:[NSNumber numberWithDouble:priceMb + k * priceMd]]]);
        NSNumber *priceDn = SafetyNumber([NSDecimalNumber decimalNumberWithString:[priceNunmberFormatter stringFromNumber:[NSNumber numberWithDouble:priceMb - k * priceMd]]]);
        
        NSNumberFormatter *volumeNunmberFormatter = models.firstObject.volumeNunmberFormatter;
        NSNumber *volumeMbNumber = SafetyNumber([NSDecimalNumber decimalNumberWithString:[volumeNunmberFormatter stringFromNumber:[NSNumber numberWithDouble:volumeMb]]]);
        NSNumber *volumeUp = SafetyNumber([NSDecimalNumber decimalNumberWithString:[volumeNunmberFormatter stringFromNumber:[NSNumber numberWithDouble:volumeMb + k * volumeMd]]]);
        NSNumber *volumeDn = SafetyNumber([NSDecimalNumber decimalNumberWithString:[volumeNunmberFormatter stringFromNumber:[NSNumber numberWithDouble:volumeMb - k * volumeMd]]]);

        NSDictionary *priceDict = @{@"mb" : priceMbNumber, @"up" : priceUp, @"dn" : priceDn};
        NSDictionary *volumeDict = @{@"mb" : volumeMbNumber, @"up" : volumeUp, @"dn" : volumeDn};
        
        return @[priceDict, volumeDict];
    };
}

@end
