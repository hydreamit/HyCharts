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

@property (nonatomic,copy,readonly) UIView *(^rectValue)(CGFloat left, CGFloat top, CGFloat width, CGFloat heigth);

@property (nonatomic,copy,readonly) UIView *(^widthValue)(CGFloat width);
@property (nonatomic,copy,readonly) UIView *(^heightValue)(CGFloat heigth);
@property (nonatomic,copy,readonly) UIView *(^sizeValue)(CGFloat width, CGFloat heigth);

@property (nonatomic,copy,readonly) UIView *(^leftValue)(CGFloat left);
@property (nonatomic,copy,readonly) UIView *(^topValue)(CGFloat top);
@property (nonatomic,copy,readonly) UIView *(^rightValue)(CGFloat right);
@property (nonatomic,copy,readonly) UIView *(^bottomValue)(CGFloat bottom);

@property (nonatomic,copy,readonly) UIView *(^centerXValue)(CGFloat centerX);
@property (nonatomic,copy,readonly) UIView *(^centerYValue)(CGFloat centerY);
@property (nonatomic,copy,readonly) UIView *(^originValue)(CGFloat left, CGFloat top);

@property (nonatomic,copy,readonly) UIView *(^widthIsEqualTo)(UIView *view);
@property (nonatomic,copy,readonly) UIView *(^heightIsEqualTo)(UIView *view);
@property (nonatomic,copy,readonly) UIView *(^sizeIsEqualTo)(UIView *view);

@property (nonatomic,copy,readonly) UIView *(^leftIsEqualTo)(UIView *view);
@property (nonatomic,copy,readonly) UIView *(^topIsEqualTo)(UIView *view);
@property (nonatomic,copy,readonly) UIView *(^rightIsEqualTo)(UIView *view);
@property (nonatomic,copy,readonly) UIView *(^bottomIsEqualTo)(UIView *view);

@property (nonatomic,copy,readonly) UIView *(^centerXIsEqualTo)(UIView *view);
@property (nonatomic,copy,readonly) UIView *(^centerYIsEqualTo)(UIView *view);
@property (nonatomic,copy,readonly) UIView *(^originIsEqualTo)(UIView *view);

@property (nonatomic,copy,readonly) UIView *(^containTo)(UIView *view);

@end


