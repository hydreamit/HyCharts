//
//  HyChartsKLineDemoCursor.m
//  HyChartsDemo
//
//  Created by huangyi on 2020/4/20.
//  Copyright © 2020 Hy. All rights reserved.
//

#import "HyChartsKLineDemoCursor.h"
#import <HyCategoriess/HyCategories.h>


@implementation HyChartsKLineDemoCursor

- (void(^)(CGPoint point, NSString *xText, NSString *yText, id<HyChartModelProtocol> model, HyChartView *chartView))show {
    return ^(CGPoint point, NSString *xText, NSString *yText, id<HyChartModelProtocol> model, HyChartView *chartView) {
        
        [self dismiss];

    };
}

- (void)dismiss {
    
}

- (BOOL)isShowing {
    return YES;
}

@end
