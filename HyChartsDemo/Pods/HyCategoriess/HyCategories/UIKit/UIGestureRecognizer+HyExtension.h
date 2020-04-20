//
//  UIGestureRecognizer+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (HyExtension)

@property (nonatomic,weak,readonly,nullable) UIView *hy_targetView;

+ (instancetype)hy_gestureRecognizerWithActionBlock:(void (^)(UIGestureRecognizer *gesture))block;

- (void)hy_addActionBlock:(void(^)(UIGestureRecognizer *gesture))block;

- (void)hy_removeAllActionBlocks;

@end

NS_ASSUME_NONNULL_END
