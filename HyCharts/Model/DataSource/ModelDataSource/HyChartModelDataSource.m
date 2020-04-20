//
//  HyChartModelDataSource.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartModelDataSource.h"


@interface HyChartModelDataSource ()
@property (nonatomic, copy) NSInteger(^numberOfItemsBlock)(void);
@end


@implementation HyChartModelDataSource
@synthesize maxValue = _maxValue, minValue = _minValue;
@synthesize  visibleModels = _visibleModels, visibleXAxisModels = _visibleXAxisModels, models = _models, numberFormatter = _numberFormatter;

- (instancetype)configNumberOfItems:(NSInteger(^)(void))block {
    
    self.numberOfItemsBlock = [block copy];
    return self;
}


@end
