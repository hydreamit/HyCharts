//
//  UILabel+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/8/29.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (HyExtension)

+ (instancetype)hy_labelWithFrame:(CGRect)frame
                             font:(UIFont *)font
                             text:(nullable NSString *)text
                        textColor:(UIColor *)textColor
                    textAlignment:(NSTextAlignment)textAlignment
                    numberOfLines:(NSInteger)numberOfLines;

- (void)hy_drawTextColor:(UIColor *)color
                progress:(CGFloat)progress;

- (void)hy_drawTextColor:(UIColor *)color
                    rect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
