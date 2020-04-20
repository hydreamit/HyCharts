//
//  UIBezierPath+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/30.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (HyExtension)

+ (UIBezierPath *)hy_bezierPathWithRoundedRect:(CGRect)rect
                             cornerRadiusArray:(NSArray<NSNumber *> *)cornerRadius
                                     lineWidth:(CGFloat)lineWidth;

+ (nullable UIBezierPath *)hy_bezierPathWithText:(NSString *)text font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
