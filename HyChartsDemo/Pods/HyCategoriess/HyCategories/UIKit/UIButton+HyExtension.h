//
//  UIButton+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (HyExtension)

+ (instancetype)hy_buttonWithType:(UIButtonType)type
                            frame:(CGRect)frame
                            title:(nullable NSString * )title
                    selectedTitle:(nullable NSString *)selectedTitle
                       titleColor:(nullable UIColor *)titleColor
               selectedTitleColor:(nullable UIColor *)selectedTitleColor
                        titleFont:(nullable UIFont *)titleFont
                  backgroundColor:(nullable UIColor *)backgroundColor
                  backgroundImage:(nullable UIImage *)backgroundImage
                       clickBlock:(nullable void(^)(UIButton *button))clickBlock;

- (void)hy_clickBlock:(void(^_Nullable)(UIButton *button))block;

@end

NS_ASSUME_NONNULL_END
