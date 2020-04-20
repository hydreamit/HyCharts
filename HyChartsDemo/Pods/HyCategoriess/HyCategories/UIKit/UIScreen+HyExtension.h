//
//  UIScreen+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScreen (HyExtension)

+ (CGFloat)hy_screenScale;

@property (nonatomic,assign,readonly) CGRect hy_currentBounds;

- (CGRect)hy_boundsForOrientation:(UIInterfaceOrientation)orientation;

@end

NS_ASSUME_NONNULL_END
