//
//  HyChartsMethods.h
//  HyChartsDemo
//
//  Created by Hy on 2018/4/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>


CG_INLINE void
AsyncHandler(dispatch_block_t (^block)(void)) {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), block ? (block() ?: ^{}) : ^{});
    });
}

CG_INLINE void
TransactionDisableActions(void (^block)(void)) {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (block) { block(); }
    [CATransaction commit];
}

CG_INLINE NSComparisonResult
DecimalCompare(NSNumber *numberOne, NSNumber *numberTwo) {
    NSDecimal decimalOne = numberOne.decimalValue;
    NSDecimal decimalTwo = numberTwo.decimalValue;
    return NSDecimalCompare(&decimalOne, &decimalTwo);
}

CG_INLINE BOOL
IsMax(NSNumber *numberOne, NSNumber *numberTwo) {
    return DecimalCompare(numberOne, numberTwo) == NSOrderedDescending;
}

CG_INLINE BOOL
IsMin(NSNumber *numberOne, NSNumber *numberTwo) {
    return DecimalCompare(numberOne, numberTwo) == NSOrderedAscending;
}

CG_INLINE BOOL
IsSame(NSNumber *numberOne, NSNumber *numberTwo) {
    return DecimalCompare(numberOne, numberTwo) == NSOrderedSame;
}

CG_INLINE NSNumber *
MaxNumber(NSNumber *numberOne, NSNumber *numberTwo) {
    if (IsMax(numberOne, numberTwo)) {
        return numberOne;
    }
    return numberTwo;
}

CG_INLINE NSNumber *
MinNumber(NSNumber *numberOne, NSNumber *numberTwo) {
    if (IsMin(numberOne, numberTwo)) {
        return numberOne;
    }
    return numberTwo;
}

CG_INLINE NSDecimalNumber *
DecimalNumber(NSNumber *number) {
    if ([number isKindOfClass:NSDecimalNumber.class]) {
        return (id)number;
    }
    return [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

CG_INLINE NSNumber *
CalculateNumber(NSNumber *numberOne, NSNumber *numberTwo, NSNumber *(^block)(NSDecimalNumber *decimalNumberOne, NSDecimalNumber *decimalNumberTwo)) {
    NSDecimalNumber *decimalNumberOne = DecimalNumber(numberOne);
    NSDecimalNumber *decimalNumberTwo = DecimalNumber(numberTwo);
    if (![decimalNumberOne isEqualToNumber:NSDecimalNumber.notANumber] &&
        ![decimalNumberTwo isEqualToNumber:NSDecimalNumber.notANumber]) {
        return  block(decimalNumberOne, decimalNumberTwo);
    }
    return [NSDecimalNumber decimalNumberWithString:@"0"];
}

CG_INLINE NSNumber *
AddingNumber(NSNumber *numberOne, NSNumber *numberTwo) {
    return CalculateNumber(numberOne, numberTwo, ^NSNumber *(NSDecimalNumber *decimalNumberOne, NSDecimalNumber *decimalNumberTwo) {
       return [decimalNumberOne decimalNumberByAdding:decimalNumberTwo];
    });
}

CG_INLINE NSNumber *
SubtractingNumber(NSNumber *numberOne, NSNumber *numberTwo) {
    return CalculateNumber(numberOne, numberTwo, ^NSNumber *(NSDecimalNumber *decimalNumberOne, NSDecimalNumber *decimalNumberTwo) {
       return [decimalNumberOne decimalNumberBySubtracting:decimalNumberTwo];
    });
}

CG_INLINE NSNumber *
MultiplyingNumber(NSNumber *numberOne, NSNumber *numberTwo) {
    return CalculateNumber(numberOne, numberTwo, ^NSNumber *(NSDecimalNumber *decimalNumberOne, NSDecimalNumber *decimalNumberTwo) {
       return [decimalNumberOne decimalNumberByMultiplyingBy:decimalNumberTwo];
    });
}

CG_INLINE NSNumber *
DividingNumber(NSNumber *numberOne, NSNumber *numberTwo) {
    return CalculateNumber(numberOne, numberTwo, ^NSNumber *(NSDecimalNumber *decimalNumberOne, NSDecimalNumber *decimalNumberTwo) {
        if ([decimalNumberTwo isEqualToNumber:NSDecimalNumber.zero]) {
            return [NSDecimalNumber decimalNumberWithString:@"0"];
        }
       return [decimalNumberOne decimalNumberByDividingBy:decimalNumberTwo];
    });
}

CG_INLINE NSNumber *
SafetyNumber(NSNumber *number) {
    if (![number isKindOfClass:NSNumber.class] ||
        [number isEqualToNumber:NSDecimalNumber.notANumber]) {
        return [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    return number;
}

CG_INLINE NSString *
SafetyString(NSString *string) {
    NSString *str = [NSString stringWithFormat:@"%@", string];
    str = [str stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    if ([str isEqualToString:@"nan"] || [str isEqualToString:@"NaN"]) {
        return @"0";
    }
    return str;
}


