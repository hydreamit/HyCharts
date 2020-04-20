//
//  UITabBarController+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/13.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UITabBarController+HyExtension.h"
#import "UINavigationController+HyExtension.h"
#import "UIView+HyExtension.h"
#import "HyRunTimeMethods.h"


@interface UITabBarController ()
@property (nonatomic,assign) NSInteger hy_clickItemFromIndex;
@end


@implementation UITabBarController (HyExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        hy_swizzleInstanceMethodToBlock([self class], @selector(tabBar:didSelectItem:), ^id(SEL sel, IMP (^impBlock)(void)) {
            return ^(UITabBarController *_self, UITabBar *tabBar, UITabBarItem *item) {
                                
                NSInteger index = [tabBar.items indexOfObject:item];
                BOOL isRepeat = index == _self.hy_clickItemFromIndex;
                !_self.hy_clickItemBlock ?: _self.hy_clickItemBlock(_self, index, isRepeat);
                _self.hy_clickItemFromIndex = index;
            };
        });
    });
}

- (void)hy_jumpSelectedToIndex:(NSInteger)index
                      animated:(BOOL)animated
                    completion:(void(^)(UIViewController *selectedVc))completion {
 
    UIViewController *selectedViewController = self.selectedViewController;
    NSUInteger selectedIndex = self.selectedIndex;
    
    if ([selectedViewController isKindOfClass:UINavigationController.class]) {
        
        UINavigationController *nav = (UINavigationController *)selectedViewController;
        UIViewController *presentedVc = nav.presentedViewController ?: nav.topViewController.presentedViewController;
        if (presentedVc) {
            if (nav.topViewController != nav.hy_rootViewController) {
                [nav popToRootViewControllerAnimated:NO];
            }
            [presentedVc dismissViewControllerAnimated:animated completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                         (int64_t)(animated ? 0.25 : 0  * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                               if (index != selectedIndex) {
                                   self.selectedIndex = index;
                               }
                               !completion ?: completion(self.selectedViewController);
                           });
        } else {
            [nav hy_popToRootViewControllerAnimated:animated completion:^{
                if (index != selectedIndex) {
                    self.selectedIndex = index;
                }
                !completion ?: completion(self.selectedViewController);
            }];
        }
        
    } else if (selectedViewController.presentedViewController) {
        [selectedViewController.presentedViewController dismissViewControllerAnimated:animated completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(animated ? 0.25 : 0  * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           if (index != selectedIndex) {
                               self.selectedIndex = index;
                           }
                           !completion ?: completion(self.selectedViewController);
                       });
    } else {
        if (index != selectedIndex) {
            self.selectedIndex = index;
        }
        !completion ?: completion(self.selectedViewController);
    }
}

- (void)hy_addChildViewController:(UIViewController *)childVc
                            title:(NSString *)title
                            image:(NSString *)image
                    selectedImage:(NSString *)selectedImage
                      imageInsets:(UIEdgeInsets)imageInsets
                    titlePosition:(UIOffset)titlePosition {
    
    childVc.title = title;
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.imageInsets = imageInsets;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.titlePositionAdjustment = titlePosition;
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]
                                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:childVc];
}

- (void)setHy_clickItemFromIndex:(NSUInteger)hy_clickItemFromIndex {
    objc_setAssociatedObject(self,
                             @selector(hy_clickItemFromIndex),
                             @(hy_clickItemFromIndex),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSUInteger)hy_clickItemFromIndex {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}


- (void)setHy_clickItemBlock:(void (^)(UITabBarController *, NSInteger, BOOL))hy_clickItemBlock {
    objc_setAssociatedObject(self,
                             @selector(hy_clickItemBlock),
                             hy_clickItemBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(UITabBarController *, NSInteger, BOOL))hy_clickItemBlock {
   return objc_getAssociatedObject(self, _cmd);
}
@end
