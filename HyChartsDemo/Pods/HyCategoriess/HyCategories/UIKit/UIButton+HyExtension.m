//
//  UIButton+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UIButton+HyExtension.h"
#import "UIControl+HyExtension.h"


@implementation UIButton (HyExtension)

+ (instancetype)hy_buttonWithType:(UIButtonType)type
                            frame:(CGRect)frame
                            title:(NSString *)title
                    selectedTitle:(NSString *)selectedTitle
                       titleColor:(UIColor *)titleColor
               selectedTitleColor:(UIColor *)selectedTitleColor
                        titleFont:(UIFont *)titleFont
                  backgroundColor:(UIColor *)backgroundColor
                  backgroundImage:(UIImage *)backgroundImage
                       clickBlock:(void(^)(UIButton *button))clickBlock {
    
    UIButton *button = [UIButton buttonWithType:type];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    if (selectedTitle) {
       [button setTitle:selectedTitle forState:UIControlStateSelected];
    }
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    if (selectedTitleColor) {
        [button setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    }
    if (titleFont) {
        [button.titleLabel setFont:titleFont];
    }
    [button setBackgroundColor:backgroundColor];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button hy_addBlockForControlEvents:UIControlEventTouchUpInside block:clickBlock];
    return button;
}

- (void)hy_clickBlock:(void (^)(UIButton * _Nonnull))block {
    [self hy_resetBlockForControlEvents:UIControlEventTouchUpInside block:block];
}

@end
