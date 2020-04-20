//
//  UILabel+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/8/29.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UILabel+HyExtension.h"
#import "HyRunTimeMethods.h"


static const int drawTextColor_key;
static const int drawTextColorProgress_key;
static const int drawTextColorRect_key;

@implementation UILabel (HyExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        hy_swizzleInstanceMethodToBlock([self class], sel_registerName("drawRect:"), ^id(SEL sel, IMP (^impBlock)(void)) {
            
            return ^(UILabel *_self, CGRect rect) {
                
                HyVoidImpFuctoin(_self, sel, rect);
                
                UIColor *drawTextColor = objc_getAssociatedObject(_self, &drawTextColor_key);
                if (drawTextColor) {
                    
                    [drawTextColor set];
                    
                    NSValue *value = objc_getAssociatedObject(_self, &drawTextColorRect_key);
                    if (value) {
                        CGRect drawRect = [value CGRectValue];
                        UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceIn);
                    } else {
                        CGFloat progress = [objc_getAssociatedObject(_self, &drawTextColorProgress_key) floatValue];
                        CGFloat width = ABS(progress) * rect.size.width;
                        if (progress < 0) {
                            rect.origin.x = rect.size.width - width;
                        }
                        rect.size.width = width;
                        UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
                    }
                }
            };
        });
    });
 }

+ (instancetype)hy_labelWithFrame:(CGRect)frame
                             font:(UIFont *)font
                             text:(NSString *)text
                        textColor:(UIColor *)textColor
                    textAlignment:(NSTextAlignment)textAlignment
                    numberOfLines:(NSInteger)numberOfLines {
    
    UILabel *label = [[self alloc] initWithFrame:frame];
    label.font = font;
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.numberOfLines = numberOfLines;
    return label;
}

- (void)hy_drawTextColor:(UIColor *)color
                progress:(CGFloat)progress {
    
    if (!color) { return;}
    
    objc_setAssociatedObject(self, &drawTextColor_key, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &drawTextColorProgress_key, [NSNumber numberWithFloat:progress], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsDisplay];
}

- (void)hy_drawTextColor:(UIColor *)color
                    rect:(CGRect)rect {
    
    if (!color) { return;}

    objc_setAssociatedObject(self, &drawTextColor_key, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &drawTextColorRect_key, [NSValue valueWithCGRect:rect], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsDisplay];
}

@end
