//
//  HyChartYAxisInfo.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/20.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartYAxisInfo.h"


@interface HyChartYAxisInfo ()
@property (nonatomic, copy) id(^textAtIndexBlock)(NSInteger, NSNumber *maxValue, NSNumber *minValue);
@end


@implementation HyChartYAxisInfo
- (instancetype)init {
    if (self = [super init]) {
//        self.displayAxisZeroText = NO;
    } return self;
}

- (instancetype)configTextAtIndex:(id(^)(NSInteger index, NSNumber *maxValue, NSNumber *minValue))block {
    self.textAtIndexBlock = [block copy];
    return self;
}

@end
