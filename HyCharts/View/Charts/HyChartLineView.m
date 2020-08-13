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
#import <objc/message.h>
#import "HyChartLineModel.h"


@interface HyChartLineView ()
@property (nonatomic, assign) CGFloat chartWidth;
@property (nonatomic, strong) HyChartLineLayer *chartLayer;
@property (nonatomic, strong) HyChartLineDataSource *dataSource;
@end


@implementation HyChartLineView

- (void)handleVisibleModelsWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    
    __block HyChartLineModel *maxModel = nil;
    __block HyChartLineModel *minModel = nil;
    HyChartLineConfigure *configure =  self.dataSource.configreDataSource.configure;
    
    HyChartDataDirection dataDirection =  self.dataSource.configreDataSource.configure.dataDirection;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, endIndex - startIndex + 1)];
    self.dataSource.modelDataSource.visibleModels = [self.dataSource.modelDataSource.models objectsAtIndexes:indexSet];
    [self.dataSource.modelDataSource.visibleModels enumerateObjectsUsingBlock:^(HyChartLineModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = [self.dataSource.modelDataSource.models indexOfObject:obj];
        if (dataDirection == HyChartDataDirectionForward) {
            obj.position = configure.scaleEdgeInsetStart + index * configure.scaleItemWidth ;
            obj.visiblePosition = obj.position - configure.trans;
        } else {
            obj.position = configure.scaleEdgeInsetStart + index * configure.scaleItemWidth + configure.scaleWidth;
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


- (void)handleYAxis {
    
    double maxValue = self.dataSource.modelDataSource.maxValue.doubleValue;
    double minValue = self.dataSource.modelDataSource.minValue.doubleValue;
    double subValue  = (maxValue - minValue);
    
    HyChartYAxisModel *yAxisModel = self.dataSource.axisDataSource.yAxisModel;
    
    if (yAxisModel.yAxisMinValueBlock) {
        yAxisModel.yAxisMinValue = yAxisModel.yAxisMinValueBlock();
        minValue = yAxisModel.yAxisMinValue.doubleValue;
    } else {
        NSNumber *yAxisMinValueExtraPrecent = yAxisModel.yAxisMinValueExtraPrecent;
        if (yAxisMinValueExtraPrecent) {
            minValue = minValue - subValue * yAxisMinValueExtraPrecent.doubleValue;
        }
        yAxisModel.yAxisMinValue = [NSNumber numberWithDouble:minValue];
    }
    
    if (yAxisModel.yAxisMaxValueBlock) {
        yAxisModel.yAxisMaxValue = yAxisModel.yAxisMaxValueBlock();
        maxValue = yAxisModel.yAxisMaxValue.doubleValue;
    } else {
        NSNumber *yAxisMaxValueExtraPrecent = yAxisModel.yAxisMaxValueExtraPrecent;
        if (yAxisMaxValueExtraPrecent) {
            maxValue = maxValue + subValue * yAxisMaxValueExtraPrecent.doubleValue;
        }
        yAxisModel.yAxisMaxValue = [NSNumber numberWithDouble:maxValue];
    }
    
    if (yAxisModel.indexs) {
        NSNumberFormatter *formatter = self.dataSource.modelDataSource.numberFormatter;
        CGFloat averageMargin = (maxValue - minValue) / yAxisModel.indexs;
        typeof(id(^)(NSInteger, NSNumber *, NSNumber *)) (^textBlock)(BOOL) = ^(BOOL displayAxisZeroText){
            return ^id(NSInteger index, NSNumber * _Nonnull maxV, NSNumber * _Nonnull minV){
                if (!displayAxisZeroText && !index) {
                    return @"";
                }
                double current = minValue + averageMargin * index;
                return [formatter stringFromNumber:[NSNumber numberWithDouble:current]];
            };
        };
        
        if (!yAxisModel.leftYAxisDisabled && yAxisModel.leftYAxisInfo.autoSetText) {
            [yAxisModel.leftYAxisInfo configTextAtIndex:textBlock(yAxisModel.leftYAxisInfo.displayAxisZeroText)];
        }
        if (!yAxisModel.rightYAaxisDisabled && yAxisModel.rightYAxisInfo.autoSetText) {
            [yAxisModel.rightYAxisInfo configTextAtIndex:textBlock(yAxisModel.rightYAxisInfo.displayAxisZeroText)];
        }
    }
}


- (HyChartLineLayer *)chartLayer {
    if (!_chartLayer){
        _chartLayer = [HyChartLineLayer layerWithDataSource:self.dataSource];
    }
    return _chartLayer;
}

- (HyChartLineDataSource *)dataSource {
    if (!_dataSource){
        _dataSource = [[HyChartLineDataSource alloc] init];
    }
    return _dataSource;
}

- (HyChartLineModel *)model {
    return HyChartLineModel.new;
}

- (NSNumberFormatter *)yAxisNunmberFormatter {
    return self.dataSource.configreDataSource.configure.numberFormatter;
}

@end
