//
//  HyChartsMethods.h
//  HyChartsDemo
//
//  Created by Hy on 2018/4/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>


void AsyncHandler(dispatch_block_t(^block)(void));
void CATransactionDisableActions(void (^block)(void));

BOOL IsMax(NSNumber *numberOne, NSNumber *numberTwo);
BOOL IsMin(NSNumber *numberOne, NSNumber *numberTwo);
BOOL IsSame(NSNumber *numberOne, NSNumber *numberTwo);

NSNumber *MaxNumber(NSNumber *numberOne, NSNumber *numberTwo);
NSNumber *MinNumber(NSNumber *numberOne, NSNumber *numberTwo);

NSDecimalNumber *DecimalNumber(NSNumber *number);

NSNumber *AddingNumber(NSNumber *numberOne, NSNumber *numberTwo);
NSNumber *SubtractingNumber(NSNumber *numberOne, NSNumber *numberTwo);

NSNumber *MultiplyingNumber(NSNumber *numberOne, NSNumber *numberTwo);
NSNumber *DividingNumber(NSNumber *numberOne, NSNumber *numberTwo);

