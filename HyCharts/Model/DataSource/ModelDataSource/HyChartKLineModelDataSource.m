//
//  HyChartKLineModelDataSource.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartKLineModelDataSource.h"
#import "HyChartKLineModelProtocol.h"

@implementation HyChartKLineModelDataSource

- (NSNumber * _Nonnull (^)(HyChartKLineViewType))maxValueWithViewType {
    return ^NSNumber *(HyChartKLineViewType type){
        NSNumber *number = 0;
        switch (type) {
            case HyChartKLineViewTypeMain: {
                number = self.maxPrice;
            }break;
            case HyChartKLineViewTypeVolume: {
                number = self.maxVolume;
            }break;
            case HyChartKLineViewTypeAuxiliary: {
                number = self.maxAuxiliary;
            }break;
            default:
            break;
        }
        return number;
    };
}

- (NSNumber * _Nonnull (^)(HyChartKLineViewType))minValueWithViewType {
    return ^NSNumber *(HyChartKLineViewType type){
        NSNumber *number = 0;
        switch (type) {
            case HyChartKLineViewTypeMain: {
                number = self.minPrice;
            }break;
            case HyChartKLineViewTypeVolume: {
                number = self.minVolume;
            }break;
            case HyChartKLineViewTypeAuxiliary: {
                number = self.minAuxiliary;
            }break;
            default:
            break;
        }
        return number;
    };
}

- (NSNumberFormatter *)numberFormatter {
    return self.priceNunmberFormatter;
}

@end
