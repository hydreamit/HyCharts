//
//  HyChartAlgorithmProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartKLineModelDataSourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyChartAlgorithmProtocol <NSObject>

- (void (^)(NSInteger number, id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleSMA;

- (void (^)(NSInteger number, id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleEMA;

- (void (^)(NSInteger number, id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleBOLL;

- (void (^)(NSInteger number1, NSInteger number2, NSInteger number3, id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleMACD;

- (void (^)(NSInteger number1, NSInteger number2, NSInteger number3, id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleKDJ;

- (void (^)(NSInteger number, id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleRSI;

@end

NS_ASSUME_NONNULL_END
