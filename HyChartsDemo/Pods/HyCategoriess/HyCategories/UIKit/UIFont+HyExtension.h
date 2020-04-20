//
//  UIFont+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>


#define Hy_SystemFont(size) [UIFont systemFontOfSize:size]
#define Hy_BoldFont(size) [UIFont boldSystemFontOfSize:size]


NS_ASSUME_NONNULL_BEGIN

@interface UIFont (HyExtension)

@property (nonatomic,assign,readonly) BOOL hy_isBold;
@property (nonatomic,assign,readonly) BOOL hy_isItalic;
@property (nonatomic,assign,readonly) BOOL hy_isMonoSpace;
@property (nonatomic,assign,readonly) BOOL hy_isColorGlyphs;
@property (nonatomic,assign,readonly) CGFloat hy_fontWeight;

- (UIFont *)hy_fontToNormal;
- (UIFont *)hy_fontToBold;
- (UIFont *)hy_fontToItalic;
- (UIFont *)hy_fontToBoldItalic;

@end

NS_ASSUME_NONNULL_END
