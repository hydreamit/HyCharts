//
//  HyChartLineView.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartLineView.h"
#import "HyChartLineLayer.h"
#import "HyChartLineDataSource.h"
#import "HyChartLineModel.h"
#import "HyChartKLineConfigureProtocol.h"
#import "HyChartsMethods.h"


@interface HyChartLineView ()
@property (nonatomic, assign) CGFloat chartWidth;
@property (nonatomic,strong) HyChartLineLayer *chartLayer;
@property (nonatomic, strong) id<HyChartLineDataSourceProtocol> dataSource;
@end


@implementation HyChartLineView

- (void)handleVisibleModelsWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    
    __block id<HyChartLineModelProtocol> maxModel = nil;
    __block id<HyChartLineModelProtocol> minModel = nil;
    id<HyChartLineConfigureProtocol> configure =  self.dataSource.configreDataSource.configure;
    
    HyChartDataDirection dataDirection =  self.dataSource.configreDataSource.configure.dataDirection;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, endIndex - startIndex + 1)];
    self.dataSource.modelDataSource.visibleModels = [self.dataSource.modelDataSource.models objectsAtIndexes:indexSet];
    [self.dataSource.modelDataSource.visibleModels enumerateObjectsUsingBlock:^(id<HyChartLineModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.visibleIndex = idx;
        if (dataDirection == HyChartDataDirectionForward) {
            obj.position = configure.scaleEdgeInsetStart + obj.index * configure.scaleItemWidth ;
            obj.visiblePosition = obj.position - configure.trans;
        } else {
            obj.position = configure.scaleEdgeInsetStart + obj.index * configure.scaleItemWidth + configure.scaleWidth;
            obj.visiblePosition = self.chartWidth - (obj.position - configure.trans);
        }

        if (!maxModel) {
            maxModel = obj;
            minModel = obj;
        } else {
            if (IsMax(obj.value, maxModel.value)) {
              maxModel = obj;
            } else
            if (IsMin(obj.value, minModel.value)) {
              minModel = obj;
            }
        }
    }];
    
    self.dataSource.modelDataSource.minValue = @(0);
    self.dataSource.modelDataSource.maxValue = maxModel.value;
    self.dataSource.modelDataSource.visibleMaxModel = maxModel;
    self.dataSource.modelDataSource.visibleMinModel = minModel;
}

- (HyChartLineLayer *)chartLayer {
    if (!_chartLayer){
        _chartLayer = [HyChartLineLayer layerWithDataSource:self.dataSource];
    }
    return _chartLayer;
}

- (id<HyChartLineDataSourceProtocol>)dataSource {
    if (!_dataSource){
        _dataSource = [[HyChartLineDataSource alloc] init];
    }
    return _dataSource;
}

- (id<HyChartLineModelProtocol>)model {
    return HyChartLineModel.new;
}

- (NSNumberFormatter *)yAxisNunmberFormatter {
    return self.dataSource.configreDataSource.configure.numberFormatter;
}

@end
