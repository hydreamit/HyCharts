//
//  HyChartAlgorithmContext.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartKLineModelDataSourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN


@interface HyChartAlgorithmContext : NSObject

/// 指数移动平均数
+ (void (^)(NSInteger number, id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleSMA;

/// 指数移动平均数
+ (void (^)(NSInteger number,id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleEMA;

/// 布林线
+ (void (^)(NSInteger number,id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleBOLL;


/// 指数平滑异同平均线
+ (void (^)(NSInteger number1, NSInteger number2, NSInteger number3, id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleMACD;

/// 随机指标
+ (void (^)(NSInteger number1, NSInteger number2, NSInteger number3, id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleKDJ;

/// RSI指标公式
+ (void (^)(NSInteger number, id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleRSI;

@end

NS_ASSUME_NONNULL_END
