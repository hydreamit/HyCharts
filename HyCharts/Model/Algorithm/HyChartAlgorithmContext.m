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

+ (void (^)(NSInteger number,id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleSMA {
    return ^(NSInteger number,id<HyChartKLineModelDataSourceProtocol> modelDataSource){
        return self.chartAlgorithm.handleSMA(number, modelDataSource);
    };
}

+ (void (^)(NSInteger number,id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleEMA {
    return ^(NSInteger number,id<HyChartKLineModelDataSourceProtocol> modelDataSource){
        return self.chartAlgorithm.handleEMA(number, modelDataSource);
    };
}

+ (void (^)(NSInteger number,id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleBOLL {
    return ^(NSInteger number,id<HyChartKLineModelDataSourceProtocol> modelDataSource){
        return self.chartAlgorithm.handleBOLL(number, modelDataSource);
    };
}

+ (void (^)(NSInteger number1, NSInteger number2, NSInteger number3, id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleMACD {
    return ^(NSInteger number1, NSInteger number2, NSInteger number3, id<HyChartKLineModelDataSourceProtocol> modelDataSource){
        return self.chartAlgorithm.handleMACD(number1, number2, number3, modelDataSource);
    };
}

+ (void (^)(NSInteger number1, NSInteger number2, NSInteger number3, id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleKDJ {
    return ^(NSInteger number1, NSInteger number2, NSInteger number3, id<HyChartKLineModelDataSourceProtocol> modelDataSource){
        return self.chartAlgorithm.handleKDJ(number1, number2, number3, modelDataSource);
    };
}

+ (void (^)(NSInteger number, id<HyChartKLineModelDataSourceProtocol> modelDataSource))handleRSI {
    return ^(NSInteger number, id<HyChartKLineModelDataSourceProtocol> modelDataSource){
        return self.chartAlgorithm.handleRSI(number, modelDataSource);
    };
}

@end
