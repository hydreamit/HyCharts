//
//  HyChartAxisDataSource.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartAxisDataSource.h"
#import "HyChartXAxisModel.h"
#import "HyChartYAxisModel.h"


@interface HyChartAxisDataSource ()
@property (nonatomic, strong) id<HyChartXAxisModelProtocol> xAxisModel;
@property (nonatomic, strong) id<HyChartYAxisModelProtocol> yAxisModel;
@property (nonatomic, strong) NSDictionary<NSNumber *, id<HyChartXAxisModelProtocol>> *xAxisModelDict;
@property (nonatomic, strong) NSDictionary<NSNumber *, id<HyChartYAxisModelProtocol>> *yAxisModelDict;
@end


@implementation HyChartAxisDataSource

- (id<HyChartAxisDataSourceProtocol>)configXAxisWithModel:(void(^)(id<HyChartXAxisModelProtocol> xAxisModel))block {
    !block ?: block(self.xAxisModel);
    return self;
}

- (id<HyChartAxisDataSourceProtocol>)configYAxisWithModel:(void(^)(id<HyChartYAxisModelProtocol> yAxisModel))block {
    !block ?: block(self.yAxisModel);
    return self;
}

- (id<HyChartAxisDataSourceProtocol>)configYAxisWithModelAndViewType:(void(^)(id<HyChartYAxisModelProtocol> yAxisModel, HyChartKLineViewType type))block {
    if (block) {
        [self.yAxisModelDict.allKeys enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            block(self.yAxisModelDict[obj], [obj integerValue]);
        }];
    }
    return self;
}

- (id<HyChartXAxisModelProtocol>)xAxisModel {
    if (!_xAxisModel) {
        _xAxisModel = [[HyChartXAxisModel alloc] init];
    }
    return _xAxisModel;
}

- (id<HyChartYAxisModelProtocol>)yAxisModel {
    if (!_yAxisModel) {
        _yAxisModel = [[HyChartYAxisModel alloc] init];
    }
    return _yAxisModel;
}

- (id<HyChartYAxisModelProtocol>  _Nonnull (^)(HyChartKLineViewType))yAxisModelWityViewType {
    return ^id<HyChartYAxisModelProtocol> (HyChartKLineViewType type){
        return self.yAxisModelDict[@(type)];
    };
}

- (id<HyChartXAxisModelProtocol>  _Nonnull (^)(HyChartKLineViewType))xAxisModelWityViewType {
    return ^id<HyChartXAxisModelProtocol> (HyChartKLineViewType type){
        return self.xAxisModelDict[@(type)];
    };
}

- (NSDictionary<NSNumber *,id<HyChartYAxisModelProtocol>> *)yAxisModelDict {
    if (!_yAxisModelDict) {
        _yAxisModelDict = @{@(HyChartKLineViewTypeMain) : [[HyChartYAxisModel alloc] init],
                            @(HyChartKLineViewTypeVolume) : [[HyChartYAxisModel alloc] init],
                            @(HyChartKLineViewTypeAuxiliary) : [[HyChartYAxisModel alloc] init]};
    }
    return _yAxisModelDict;
}

- (NSDictionary<NSNumber *,id<HyChartXAxisModelProtocol>> *)xAxisModelDict {
    if (!_xAxisModelDict) {
        _xAxisModelDict = @{@(HyChartKLineViewTypeMain) : [[HyChartXAxisModel alloc] init],
                            @(HyChartKLineViewTypeVolume) : [[HyChartXAxisModel alloc] init],
                            @(HyChartKLineViewTypeAuxiliary) : [[HyChartXAxisModel alloc] init]};
    }
    return _xAxisModelDict;
}

@end
