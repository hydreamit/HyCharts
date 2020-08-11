//
//  HyChartAlgorithmProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartKLineModelDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyChartAlgorithmProtocol <NSObject>

- (void (^)(NSInteger number, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleSMA;

- (void (^)(NSInteger number, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleEMA;

- (void (^)(NSInteger number, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleBOLL;

- (void (^)(NSInteger number1, NSInteger number2, NSInteger number3, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleMACD;

- (void (^)(NSInteger number1, NSInteger number2, NSInteger number3, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleKDJ;

- (void (^)(NSInteger number, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleRSI;

@end

NS_ASSUME_NONNULL_END
