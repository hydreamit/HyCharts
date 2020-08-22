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
#import <objc/message.h>


@interface HyChartBarView ()
@property (nonatomic, strong) HyChartBarLayer *chartLayer;
@property (nonatomic, strong) HyChartBarDataSource *dataSource;
@property (nonatomic, strong) NSNumberFormatter *yAxisNunmberFormatter;
@end


@implementation HyChartBarView

- (void)handleVisibleModelsWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    
    __block HyChartBarModel *maxModel = nil;
    __block HyChartBarModel *minModel = nil;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, endIndex - startIndex + 1)];
    self.dataSource.modelDataSource.visibleModels = [self.dataSource.modelDataSource.models objectsAtIndexes:indexSet];    
    [self.dataSource.modelDataSource.visibleModels enumerateObjectsUsingBlock:^(HyChartBarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        ((void(*)(id, SEL, HyChartModel *, NSUInteger))objc_msgSend)(self, sel_registerName("handlePositionWithModel:idx:"), obj, idx);

        if (!maxModel) {
            maxModel = obj;
            minModel = obj;
        } else {
           if (obj.maxValue.doubleValue > maxModel.maxValue.doubleValue) {
               maxModel = obj;
           }
           if (obj.minValue.doubleValue < minModel.minValue.doubleValue) {
               minModel = obj;
           }
        }
    }];
    
    self.dataSource.modelDataSource.minValue = minModel.minValue;
    self.dataSource.modelDataSource.maxValue = maxModel.maxValue;
    self.dataSource.modelDataSource.visibleMaxModel = maxModel;
    self.dataSource.modelDataSource.visibleMinModel = minModel;
}

- (HyChartBarLayer *)chartLayer {
    if (!_chartLayer){
        _chartLayer = [HyChartBarLayer layerWithDataSource:self.dataSource];
    }
    return _chartLayer;
}

- (HyChartBarDataSource *)dataSource {
    if (!_dataSource){
        _dataSource = [[HyChartBarDataSource alloc] init];
    }
    return _dataSource;
}

- (HyChartBarModel *)model {
    return HyChartBarModel.new;
}

- (NSNumberFormatter *)yAxisNunmberFormatter {
    return self.dataSource.configreDataSource.configure.numberFormatter;
}

@end
