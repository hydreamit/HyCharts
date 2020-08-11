//
//  HyChartAlgorithmContext.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartAlgorithmContext.h"
#import "HyChartAlgorithm.h"


@interface HyChartAlgorithmContext ()
@property (nonatomic, strong) id<HyChartAlgorithmProtocol> algorithm;
@end


@implementation HyChartAlgorithmContext

+ (instancetype)context {
    static HyChartAlgorithmContext *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
        _instance.algorithm = HyChartAlgorithm.new;
    });
    return _instance;
}

+ (id<HyChartAlgorithmProtocol>)chartAlgorithm {
    return [[self context] algorithm];
}

+ (void (^)(NSInteger number,HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleSMA {
    return ^(NSInteger number,HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex){
        return self.chartAlgorithm.handleSMA(number, modelDataSource, rangeIndex);
    };
}

+ (void (^)(NSInteger number,HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleEMA {
    return ^(NSInteger number,HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex){
        return self.chartAlgorithm.handleEMA(number, modelDataSource, rangeIndex);
    };
}

+ (void (^)(NSInteger number,HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleBOLL {
    return ^(NSInteger number,HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex){
        return self.chartAlgorithm.handleBOLL(number, modelDataSource, rangeIndex);
    };
}

+ (void (^)(NSInteger number1, NSInteger number2, NSInteger number3, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleMACD {
    return ^(NSInteger number1, NSInteger number2, NSInteger number3, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex){
        return self.chartAlgorithm.handleMACD(number1, number2, number3, modelDataSource, rangeIndex);
    };
}

+ (void (^)(NSInteger number1, NSInteger number2, NSInteger number3, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleKDJ {
    return ^(NSInteger number1, NSInteger number2, NSInteger number3, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex){
        return self.chartAlgorithm.handleKDJ(number1, number2, number3, modelDataSource, rangeIndex);
    };
}

+ (void (^)(NSInteger number, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex))handleRSI {
    return ^(NSInteger number, HyChartKLineModelDataSource *modelDataSource, NSInteger rangeIndex){
        return self.chartAlgorithm.handleRSI(number, modelDataSource, rangeIndex);
    };
}

@end
