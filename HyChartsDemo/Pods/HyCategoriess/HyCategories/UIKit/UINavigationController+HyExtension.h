//
//  UINavigationController+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 17/6/22.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+HyExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (HyExtension) <UIGestureRecognizerDelegate>

@property (nonatomic,weak,readonly,nullable) UIViewController *hy_rootViewController;
@property (nonatomic,weak,readonly,nullable) UIViewController *hy_poppingViewController;
@property (nonatomic,assign,readonly,nullable) UIPanGestureRecognizer  *hy_popGestureRecognizer;

- (nullable UIViewController *)hy_viewControllerFromIndex:(NSInteger)index;
- (nullable UIViewController *)hy_viewControllerToIndex:(NSInteger)index;
- (nullable UIViewController *)hy_viewControllerWithName:(NSString *)name;

- (void)hy_popToViewControllerWithName:(NSString *)name animated:(BOOL)animated;
- (void)hy_popToViewControllerWithToIndex:(NSInteger)index animated:(BOOL)animated;
- (void)hy_popToViewControllerWithFromIndex:(NSInteger)index animated:(BOOL)animated;

- (void)hy_removeViewControllerWithName:(NSString *)name;
- (void)hy_removeViewControllerFromIndex:(NSInteger)index;
- (void)hy_removeViewControllerToIndex:(NSInteger)index;

- (BOOL)hy_containViewControllerWithName:(NSString *)name;

- (void)hy_repleaseViewControllerAtIndex:(NSInteger )index
                         withController:(UIViewController *)controller;


- (void)hy_pushViewController:(UIViewController *)viewController
                     animated:(BOOL)animated
                   completion:(void (^_Nullable)(void))completion;

- (nullable UIViewController *)hy_popViewControllerAnimated:(BOOL)animated
                                                 completion:(void (^_Nullable)(void))completion;

- (nullable NSArray<__kindof UIViewController *> *)hy_popToViewController:(UIViewController *)viewController
                                                                 animated:(BOOL)animated
                                                               completion:(void (^_Nullable)(void))completion;

- (nullable NSArray<__kindof UIViewController *> *)hy_popToRootViewControllerAnimated:(BOOL)animated
                                                                           completion:(void (^_Nullable)(void))completion;


@end

NS_ASSUME_NONNULL_END
