//
//  HyChartAlgorithmContext.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartKLineModelDataSource.h"

NS_ASSUME_NONNULL_BEGIN


@interface HyChartAlgorithmContext : NSObject

/// 指数移动平均数
+ (void (^)(NSInteger number, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleSMA;

/// 指数移动平均数
+ (void (^)(NSInteger number,HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleEMA;

/// 布林线
+ (void (^)(NSInteger number,HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleBOLL;


/// 指数平滑异同平均线
+ (void (^)(NSInteger number1, NSInteger number2, NSInteger number3, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleMACD;

/// 随机指标
+ (void (^)(NSInteger number1, NSInteger number2, NSInteger number3, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleKDJ;

/// RSI指标公式
+ (void (^)(NSInteger number, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleRSI;

@end

NS_ASSUME_NONNULL_END
