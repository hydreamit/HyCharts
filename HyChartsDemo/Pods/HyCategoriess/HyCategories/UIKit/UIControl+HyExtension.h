//
//  UIControl+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (HyExtension)

- (void)hy_addBlockForControlEvents:(UIControlEvents)controlEvents
                              block:(void (^)(id sender))block;

- (void)hy_resetBlockForControlEvents:(UIControlEvents)controlEvents
                                block:(void (^)(id sender))block;

- (void)hy_removeAllBlocksForControlEvents:(UIControlEvents)controlEvents;

- (void)hy_resetTarget:(id)target
                action:(SEL)action
      forControlEvents:(UIControlEvents)controlEvents;

- (void)hy_removeAllTargets;

@end

NS_ASSUME_NONNULL_END
