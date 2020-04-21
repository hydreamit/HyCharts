//
//  HyChartsKlineDemoController.m
//  DemoCode
//
//  Created by Hy on 2018/4/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartsKlineDemoController.h"
#import <HyCategoriess/HyCategories.h>
#import <HyCycleView/HySegmentView.h>
#import "HyCharts.h"


@implementation HyChartsKlineDemoController

- (NSArray<NSString *> *)titleArray {
    return @[@"K线主图", @"K线交易量图", @"K线辅助图", @"K线图全图"];
}

- (NSArray<NSString *> *)controllerArray {
    return @[@"HyChartsKlineMainDemoController",
             @"HyChartsKlineVolumeDemoController",
             @"HyChartsKLineAuxiliaryDemoController",
             @"HyChartsKlineNewDemoController"];
}

@end
