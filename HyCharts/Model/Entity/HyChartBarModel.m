//
//  HyChartBarModel.m
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartBarModel.h"
#import "HyChartsMethods.h"

@implementation HyChartBarModel
@synthesize values = _values;

- (void)setValues:(NSArray<NSNumber *> *)values {
    
    __block NSNumber *maxVaule = nil;
    NSMutableArray<NSNumber *> *mArray = @[].mutableCopy;
    [values enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *numberString = [self.numberFormatter stringFromNumber:obj];
        NSNumber *deNumber = SafetyNumber([NSDecimalNumber decimalNumberWithString:numberString]);
        [mArray addObject:deNumber];
        if (!maxVaule) {
            maxVaule = deNumber;
        } else {
            maxVaule = MaxNumber(maxVaule, deNumber);
        }
    }];
    
    _values = mArray.copy;
    self.value = maxVaule;
}

@end
