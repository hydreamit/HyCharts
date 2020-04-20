//
//  HyChartsMethods.m
//  HyChartsDemo
//
//  Created by Hy on 2018/4/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartsMethods.h"
#import <QuartzCore/QuartzCore.h>

void AsyncHandler(dispatch_block_t (^block)(void)) {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), block ? (block() ?: ^{}) : ^{});
    });
}

void CATransactionDisableActions(void (^block)(void)) {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    !block ?: block();
    [CATransaction commit];
}

NSComparisonResult DecimalCompare(NSNumber *numberOne, NSNumber *numberTwo) {
    NSDecimal decimalOne = numberOne.decimalValue;
    NSDecimal decimalTwo = numberTwo.decimalValue;
    return NSDecimalCompare(&decimalOne, &decimalTwo);
}

BOOL IsMax(NSNumber *numberOne, NSNumber *numberTwo) {
    return DecimalCompare(numberOne, numberTwo) == NSOrderedDescending;
};

BOOL IsMin(NSNumber *numberOne, NSNumber *numberTwo) {
    return DecimalCompare(numberOne, numberTwo) == NSOrderedAscending;
};

BOOL IsSame(NSNumber *numberOne, NSNumber *numberTwo) {
    return DecimalCompare(numberOne, numberTwo) == NSOrderedSame;
};

NSNumber *MaxNumber(NSNumber *numberOne, NSNumber *numberTwo) {
    if (IsMax(numberOne, numberTwo)) {
        return numberOne;
    }
    return numberTwo;
};

NSNumber *MinNumber(NSNumber *numberOne, NSNumber *numberTwo) {
    if (IsMin(numberOne, numberTwo)) {
        return numberOne;
    }
    return numberTwo;
};

NSDecimalNumber *DecimalNumber(NSNumber *number) {
    if ([number isKindOfClass:NSDecimalNumber.class]) {
        return (id)number;
    }
    return [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

NSNumber *CalculateNumber(NSNumber *numberOne, NSNumber *numberTwo, NSNumber *(^block)(NSDecimalNumber *decimalNumberOne, NSDecimalNumber *decimalNumberTwo)) {
    NSDecimalNumber *decimalNumberOne = DecimalNumber(numberOne);
    NSDecimalNumber *decimalNumberTwo = DecimalNumber(numberTwo);
    if (![decimalNumberOne isEqualToNumber:NSDecimalNumber.notANumber] &&
        ![decimalNumberTwo isEqualToNumber:NSDecimalNumber.notANumber]) {
        return  block(decimalNumberOne, decimalNumberTwo);
    }
    return [NSDecimalNumber decimalNumberWithString:@"0"];
}

NSNumber *AddingNumber(NSNumber *numberOne, NSNumber *numberTwo) {
    return CalculateNumber(numberOne, numberTwo, ^NSNumber *(NSDecimalNumber *decimalNumberOne, NSDecimalNumber *decimalNumberTwo) {
       return [decimalNumberOne decimalNumberByAdding:decimalNumberTwo];
    });
}

NSNumber *SubtractingNumber(NSNumber *numberOne, NSNumber *numberTwo) {
    return CalculateNumber(numberOne, numberTwo, ^NSNumber *(NSDecimalNumber *decimalNumberOne, NSDecimalNumber *decimalNumberTwo) {
       return [decimalNumberOne decimalNumberBySubtracting:decimalNumberTwo];
    });
}

NSNumber *MultiplyingNumber(NSNumber *numberOne, NSNumber *numberTwo) {
    return CalculateNumber(numberOne, numberTwo, ^NSNumber *(NSDecimalNumber *decimalNumberOne, NSDecimalNumber *decimalNumberTwo) {
       return [decimalNumberOne decimalNumberByMultiplyingBy:decimalNumberTwo];
    });
}

NSNumber *DividingNumber(NSNumber *numberOne, NSNumber *numberTwo) {
    return CalculateNumber(numberOne, numberTwo, ^NSNumber *(NSDecimalNumber *decimalNumberOne, NSDecimalNumber *decimalNumberTwo) {
        if ([decimalNumberTwo isEqualToNumber:NSDecimalNumber.zero]) {
            return [NSDecimalNumber decimalNumberWithString:@"0"];
        }
       return [decimalNumberOne decimalNumberByDividingBy:decimalNumberTwo];
    });
}


