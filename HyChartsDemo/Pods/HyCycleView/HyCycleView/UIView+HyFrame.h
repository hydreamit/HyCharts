//
//  UIView+HyFrame.h
//  HyCycleView
//  https://github.com/hydreamit/HyCycleView
//
//  Created by Hy on 2016/5/15.
//  Copyright © 2016年 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (HyFrame)

@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign, readonly) CGPoint middlePoint;

- (UIView *(^)(CGFloat left, CGFloat top, CGFloat width, CGFloat heigth))rectValue;

- (UIView *(^)(CGFloat value))widthValue;
- (UIView *(^)(CGFloat value))heightValue;
- (UIView *(^)(CGFloat width, CGFloat height))sizeValue;

- (UIView *(^)(CGFloat value))leftValue;
- (UIView *(^)(CGFloat value))topValue;
- (UIView *(^)(CGFloat value))rightValue;
- (UIView *(^)(CGFloat value))bottomValue;

- (UIView *(^)(CGFloat value))centerXValue;
- (UIView *(^)(CGFloat value))centerYValue;
- (UIView *(^)(CGFloat left, CGFloat top))originValue;

- (UIView *(^)(UIView *value))widthIsEqualTo;
- (UIView *(^)(UIView *value))heightIsEqualTo;
- (UIView *(^)(UIView *value))sizeIsEqualTo;

- (UIView *(^)(UIView *value))leftIsEqualTo;
- (UIView *(^)(UIView *value))topIsEqualTo;
- (UIView *(^)(UIView *value))rightIsEqualTo;
- (UIView *(^)(UIView *value))bottomIsEqualTo;

- (UIView *(^)(UIView *value))centerXIsEqualTo;
- (UIView *(^)(UIView *value))centerYIsEqualTo;
- (UIView *(^)(UIView *value))originIsEqualTo;

- (UIView *(^)(UIView *value))containTo;

@end


