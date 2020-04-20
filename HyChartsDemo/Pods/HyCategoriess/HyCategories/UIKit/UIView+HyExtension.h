//
//  UIView+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/11.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Hy_ScreenW [UIScreen mainScreen].bounds.size.width
#define Hy_ScreenH [UIScreen mainScreen].bounds.size.height

NS_ASSUME_NONNULL_BEGIN


@interface UIView (HyExtension)

@property (nonatomic,assign,readonly) BOOL hy_visible;
@property (nonatomic,weak,readonly,nullable) UIViewController *hy_viewController;
@property (nonatomic,weak,readonly,nullable) UITabBarController *hy_tabBarController;
@property (nonatomic,weak,readonly,nullable) UINavigationController *hy_navigationController;

@property (nonatomic,strong,readonly) NSData *hy_snapshotPDF;
@property (nonatomic,strong,readonly) UIImage *hy_snapshotImage;
- (UIImage *)hy_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

- (void)hy_addResponderForBeyondView:(UIView *)view;
- (void)hy_addResponderForBeyondInsets:(UIEdgeInsets)insets;

- (CGPoint)hy_convertPoint:(CGPoint)point toView:(UIView *)view;
- (CGPoint)hy_convertPoint:(CGPoint)point fromView:(UIView *)view;
- (CGRect)hy_convertRect:(CGRect)rect toView:(UIView *)view;
- (CGRect)hy_convertRect:(CGRect)rect fromView:(UIView *)view;

- (void)hy_setLayerCornerRadius:(CGFloat)cornerRadius
                     rectCorner:(UIRectCorner)rectCorner;

- (void)hy_setLayerShadowWithColor:(UIColor*)color
                            offset:(CGSize)offset
                            radius:(CGFloat)radius
                           opacity:(CGFloat)opacity;


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

- (UIView *(^)(UIView *value))centerTo;
- (UIView *(^)(UIView *value))containTo;

@property(nonatomic, assign, readonly) CGFloat scaleX;
@property(nonatomic, assign, readonly) CGFloat scaleY;
@property(nonatomic, assign, readonly) CGFloat translationX;
@property(nonatomic, assign, readonly) CGFloat translationY;

@end

NS_ASSUME_NONNULL_END
