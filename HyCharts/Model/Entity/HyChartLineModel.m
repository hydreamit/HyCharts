//
//  HyChartLineModel.m
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartLineModel.h"
#import "HyChartsMethods.h"

@implementation HyChartLineModel
@synthesize values = _values, breakpoints = _breakpoints;

- (void)setValues:(NSArray<NSNumber *> *)values {
    
    __block NSNumber *maxVaule = nil;
    __block NSNumber *minVaule = nil;
    NSMutableArray<NSNumber *> *mArray = @[].mutableCopy;
    [values enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *numberString = [self.numberFormatter stringFromNumber:obj];
        NSNumber *deNumber = SafetyNumber([NSDecimalNumber decimalNumberWithString:numberString]);
        [mArray addObject:deNumber];
        maxVaule = maxVaule ? MaxNumber(maxVaule, deNumber) : deNumber;
        minVaule = minVaule ? MinNumber(minVaule, deNumber) : deNumber;
    }];
    
    _values = mArray.copy;
    self.maxValue = maxVaule;
    self.minValue = minVaule;
}

- (NSArray<NSNumber *> *)breakpoints {
    if (_breakpoints.count != self.values.count) {
        NSMutableArray<NSNumber *> *array = @[].mutableCopy;
        for (NSInteger i = 0; i < self.values.count; i++) {
            [array addObject:@(NO)];
        }
        _breakpoints = array.copy;
    }
    return _breakpoints;
}

@end
