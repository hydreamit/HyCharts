//
//  HyChartBarView.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartBarView.h"
#import "HyChartBarLayer.h"
#import "HyChartBarDataSource.h"
#import "HyChartBarModel.h"
#import "HyChartsMethods.h"


@interface HyChartBarView ()
@property (nonatomic, strong) NSNumberFormatter *yAxisNunmberFormatter;
@property (nonatomic, assign) CGFloat chartWidth;
@property (nonatomic, strong) HyChartBarLayer *chartLayer;
@property (nonatomic, strong) id<HyChartBarDataSourceProtocol> dataSource;
@end


@implementation HyChartBarView

- (void)handleVisibleModelsWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    
    __block id<HyChartBarModelProtocol> maxModel = nil;
    __block id<HyChartBarModelProtocol> minModel = nil;
    id<HyChartBarConfigureProtocol> configure =  self.dataSource.configreDataSource.configure;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, endIndex - startIndex + 1)];
    self.dataSource.modelDataSource.visibleModels = [self.dataSource.modelDataSource.models objectsAtIndexes:indexSet];
    
    HyChartDataDirection dataDirection =  self.dataSource.configreDataSource.configure.dataDirection;
    
    [self.dataSource.modelDataSource.visibleModels enumerateObjectsUsingBlock:^(id<HyChartBarModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
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
           if (obj.value.doubleValue > maxModel.value.doubleValue) {
               maxModel = obj;
           } else
           if (obj.value.doubleValue < minModel.value.doubleValue) {
               minModel = obj;
           }
        }
    }];
    
    self.dataSource.modelDataSource.minValue = @(0);
    self.dataSource.modelDataSource.maxValue = maxModel.value;
    self.dataSource.modelDataSource.visibleMaxModel = maxModel;
    self.dataSource.modelDataSource.visibleMinModel = minModel;
}

- (HyChartBarLayer *)chartLayer {
    if (!_chartLayer){
        _chartLayer = [HyChartBarLayer layerWithDataSource:self.dataSource];
    }
    return _chartLayer;
}

- (id<HyChartBarDataSourceProtocol>)dataSource {
    if (!_dataSource){
        _dataSource = [[HyChartBarDataSource alloc] init];
    }
    return _dataSource;
}

- (id<HyChartModelProtocol>)model {
    return HyChartBarModel.new;
}

- (NSNumberFormatter *)yAxisNunmberFormatter {
    return self.dataSource.configreDataSource.configure.numberFormatter;
}

@end
