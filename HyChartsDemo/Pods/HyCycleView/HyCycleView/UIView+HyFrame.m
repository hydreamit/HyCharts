//
//  UIView+HyFrame.m
//  HyCycleView
//  https://github.com/hydreamit/HyCycleView
//
//  Created by Hy on 2016/5/15.
//  Copyright © 2016年 Hy. All rights reserved.
//

#import "UIView+HyFrame.h"

@implementation UIView (HyFrame)

- (UIView *(^)(CGFloat left, CGFloat top, CGFloat width, CGFloat heigth))rectValue {
    return ^(CGFloat left, CGFloat top, CGFloat width, CGFloat heigth) {
        self.frame = CGRectMake(left, top, width, heigth);
        return self;
    };
}

- (UIView *(^)(CGFloat value))widthValue {
    return ^(CGFloat value){
        self.width = value;
        return self;
    };
}

- (UIView *(^)(CGFloat value))heightValue {
    return ^(CGFloat value){
        self.height = value;
        return self;
    };
}

- (UIView *(^)(CGFloat width, CGFloat height))sizeValue {
    return ^(CGFloat width, CGFloat height) {
        self.size = CGSizeMake(width, height);
        return self;
    };
}

- (UIView *(^)(CGFloat value))leftValue {
    return ^(CGFloat value){
        self.left = value;
        return self;
    };
}

- (UIView *(^)(CGFloat value))topValue {
    return ^(CGFloat value){
        self.top = value;
        return self;
    };
}

- (UIView *(^)(CGFloat value))rightValue {
    return ^(CGFloat value){
        self.right = value;
        return self;
    };
}

- (UIView *(^)(CGFloat value))bottomValue {
    return ^(CGFloat value){
        self.bottom = value;
        return self;
    };
}

- (UIView *(^)(CGFloat value))centerXValue {
    return ^(CGFloat value){
        self.centerX = value;
        return self;
    };
}

- (UIView *(^)(CGFloat value))centerYValue {
    return ^(CGFloat value){
        self.centerY = value;
        return self;
    };
}

- (UIView *(^)(CGFloat left, CGFloat top))originValue {
    return ^(CGFloat left, CGFloat top) {
        self.origin = CGPointMake(left, top);
        return self;
    };
}

- (UIView *(^)(UIView *value))widthIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.width = value.width;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))heightIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.height = value.height;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))sizeIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.size = value.size;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))leftIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.left = value.left;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))topIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.top = value.top;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))rightIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.right = value.right;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))bottomIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.bottom = value.bottom;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))centerXIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.centerX = value.centerX;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))centerYIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.centerY = value.centerY;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))originIsEqualTo {
    return ^(UIView *value){
        if (value) {
            self.origin = value.origin;
        }
        return self;
    };
}

- (UIView *(^)(UIView *value))containTo {
    return ^(UIView *value){
        if (value) {
            self.frame = value.bounds;
        }
        return self;
    };
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)middlePoint {
    return CGPointMake(CGRectGetWidth(self.bounds) / 2.f, CGRectGetHeight(self.bounds) / 2.f);
}

@end
