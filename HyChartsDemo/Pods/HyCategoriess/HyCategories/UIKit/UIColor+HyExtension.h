//
//  UIColor+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 17/7/14.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Hy_ColorWithHex(hex) [UIColor hy_colorWithHexString:hex]
#define Hy_ColorWithRGB(r, g , b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define Hy_ColorWithRGBA(r, g , b, a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HyExtension)

// RGB
@property (nonatomic,assign,readonly) CGFloat hy_red;
@property (nonatomic,assign,readonly) CGFloat hy_green;
@property (nonatomic,assign,readonly) CGFloat hy_blue;
@property (nonatomic,assign,readonly) CGFloat hy_alpha;
@property (nonatomic,assign,readonly) uint32_t hy_rgbValue;
@property (nonatomic,assign,readonly) uint32_t hy_rgbaValue;
@property (nonatomic,copy,readonly,nullable) NSString *hy_hexString;
@property (nonatomic,copy,readonly,nullable) NSString *hy_hexStringWithAlpha;
// HSB
@property (nonatomic,assign,readonly) CGFloat hy_hue;
@property (nonatomic,assign,readonly) CGFloat hy_saturation;
@property (nonatomic,assign,readonly) CGFloat hy_brightness;

@property (nonatomic,assign,readonly) CGColorSpaceModel hy_colorSpaceModel;
@property (nonatomic,copy,readonly) NSString *hy_colorSpaceString;


+ (UIColor *)hy_randomColor;
+ (UIColor *)hy_colorWithRGBValue:(uint32_t)rgbValue;
+ (UIColor *)hy_colorWithRGBAValue:(uint32_t)rgbaValue;
+ (UIColor *)hy_colorWithRGBValue:(uint32_t)rgbValue alpha:(CGFloat)alpha;
+ (nullable UIColor *)hy_colorWithHexString:(NSString *)hexString;

- (UIColor *)hy_transitionToColor:(UIColor *)toColor progress:(CGFloat)progress;
- (UIColor *)hy_colorCombineColor:(UIColor *)color blendMode:(CGBlendMode)blendMode;

@end

NS_ASSUME_NONNULL_END
