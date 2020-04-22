//
//  HyChartsReactChainsDemoController.m
//  HyChartsDemo
//
//  Created by Hy on 2018/4/20.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartsReactChainsDemoController.h"


@implementation HyChartsReactChainsDemoController

- (NSArray<NSString *> *)titleArray {
    return @[@"K线组合图", @"其他组合图"];
}

- (NSArray<NSString *> *)controllerArray {
    return @[@"HyChartsKlineReactChainsDemoController",
             @"HyChartsAnyReactChainsDemoController"];
}
@end
