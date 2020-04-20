//
//  UINavigationController+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 17/6/22.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import "UINavigationController+HyExtension.h"
#import "NSObject+HyExtension.h"
#import "HyRunTimeMethods.h"


@interface HyWeakObjectContainer : NSObject
@property (nonatomic, weak) id object;
@end
@implementation HyWeakObjectContainer
+ (instancetype)containerWithObject:(id)object {
    HyWeakObjectContainer *container = [self new];
    container.object = object;
    return container;
}
@end



@implementation UINavigationController (HyExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        hy_swizzleAndResetInstanceVoidMethodToBlock([self class], sel_registerName("viewDidLoad"), ^(UINavigationController *_self, void (^resetImpBlock)(void)) {
            
            __weak typeof(_self) _weakSelf = _self;
            [_self.hy_popGestureRecognizer hy_addObserverBlockForKeyPath:@"state" block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
                [_weakSelf hy_handleObserverPopGesture:obj state:[newVal integerValue]];
            }];
        });
        
        hy_swizzleInstanceVoidMethodToBlock([self class], sel_registerName("dealloc"), ^(UINavigationController *_self) {
            [_self.hy_popGestureRecognizer hy_removeObserverBlocksForKeyPath:@"state"];
        });
        
    });
}

- (UIPanGestureRecognizer *)hy_popGestureRecognizer {
    
    UIPanGestureRecognizer *pangestrue;
    NSArray<NSString *> *propertyList = hy_getPropertyList([self class]);
    if ([propertyList containsObject:@"fd_fullscreenPopGestureRecognizer"]) {
        pangestrue = [self valueForKey:@"fd_fullscreenPopGestureRecognizer"];
    } else {
        pangestrue = (UIPanGestureRecognizer *)self.interactivePopGestureRecognizer;
    }
    return pangestrue;
}

- (void)hy_handleObserverPopGesture:(UIPanGestureRecognizer *)gesture
                              state:(UIGestureRecognizerState)state {
    
    UIViewController *poppingViewController = self.hy_poppingViewController;
    UIViewController *popToViewController = self.topViewController;
    
    switch (state) {
        case UIGestureRecognizerStateBegan:{
            
            self.hy_poppingViewController =
            poppingViewController = self.topViewController;
            popToViewController = self.viewControllers[[self.viewControllers indexOfObject:self.topViewController] - 1];
            
            [self hy_handlePopGestureWithController:poppingViewController
                                              state:HyPopGestureState_Begin];
            [self hy_handlePopGestureWithController:popToViewController
                                              state:HyPopGestureState_Begin];
        }break;
        case UIGestureRecognizerStateChanged:{
            [self hy_handlePopGestureWithController:poppingViewController
                                              state:HyPopGestureState_Change];
            [self hy_handlePopGestureWithController:popToViewController
                                              state:HyPopGestureState_Change];
        }break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            
            CGPoint velocity = [gesture translationInView:gesture.view];
            HyPopGestureState state =
            (velocity.x >= ([UIScreen mainScreen].bounds.size.width) / 2) ?
            HyPopGestureState_SuccessPop : HyPopGestureState_FailPop;
            
            if (state == HyPopGestureState_SuccessPop) {
                [poppingViewController hy_viewWillDisappear:YES];
                [popToViewController hy_viewWillAppear:YES firstLoad:NO];
                [popToViewController hy_viewWillLayoutSubviewsIsFirstLoad:NO];
                [popToViewController hy_viewDidLayoutSubviewsIsFirstLoad:NO];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                         (int64_t)(.25 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                               
                               [poppingViewController hy_viewDidDisappear:YES];
                               [poppingViewController hy_viewDidAppear:YES firstLoad:NO];
                               self.hy_poppingViewController = nil;
                               poppingViewController.hy_popGestureState =
                               popToViewController.hy_popGestureState = HyPopGestureState_No;
                           });
            
            [self hy_handlePopGestureWithController:poppingViewController
                                              state:state];
            [self hy_handlePopGestureWithController:popToViewController
                                              state:state];
        }break;
        default:
        break;
    }
}

- (void)hy_handlePopGestureWithController:(UIViewController *)controller
                                    state:(HyPopGestureState)state {
    
    if (!controller) { return;}
    
    void (^handleBlock)(UIViewController *) = ^(UIViewController *vc) {
        vc.hy_popGestureState = state;
        if ([vc respondsToSelector:@selector(hy_popGestureHandlerWithState:isPopingController:)]) {
            [vc hy_popGestureHandlerWithState:state
                           isPopingController:controller == self.hy_poppingViewController];
        }
    };
    handleBlock(controller);
    [controller.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *obj,
                                                                  NSUInteger idx,
                                                                  BOOL *stop) {
        handleBlock(obj);
        [obj.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *objSub,
                                                               NSUInteger idx,
                                                               BOOL *stop) {
            handleBlock(obj);
        }];
    }];
}

- (nullable UIViewController *)hy_rootViewController {
    return self.viewControllers.firstObject;
}


- (nullable UIViewController *)hy_viewControllerFromIndex:(NSInteger)index {
    if (index >= 0 && index < self.childViewControllers.count) {
        return [self.childViewControllers objectAtIndex:index];
    }
    return nil;
}

- (nullable UIViewController *)hy_viewControllerToIndex:(NSInteger)index {
    return [self hy_viewControllerFromIndex:self.viewControllers.count - 1 - index];
}

- (nullable UIViewController *)hy_viewControllerWithName:(NSString *)name {
    
    __block UIViewController *vc;
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass(obj.class) isEqualToString:name]) {
            vc = obj;
            *stop = YES;
        }
    }];
    return vc;
}

- (void)hy_popToViewControllerWithName:(NSString *)name animated:(BOOL)animated {
    
    UIViewController *vc = [self hy_viewControllerWithName:name];
    if (vc) {
        [self popToViewController:vc animated:animated];
    }
}

- (void)hy_popToViewControllerWithToIndex:(NSInteger)index animated:(BOOL)animated {
    
    UIViewController *vc = [self hy_viewControllerFromIndex:index];
    if (vc) {
        [self popToViewController:vc animated:animated];
    }
}

- (void)hy_popToViewControllerWithFromIndex:(NSInteger)index animated:(BOOL)animated {
    
    UIViewController *vc = [self hy_viewControllerFromIndex:self.childViewControllers.count - index - 1];
    if (vc) {
        [self popToViewController:vc animated:animated];
    }
}

- (void)hy_removeViewControllerWithName:(NSString *)name {
    
    UIViewController *vc = [self hy_viewControllerWithName:name];
    if (vc) {
        NSMutableArray *arr = self.viewControllers.mutableCopy;
        [arr removeObject:vc];
        [self setViewControllers:arr.copy];
    }
}

- (void)hy_removeViewControllerFromIndex:(NSInteger)index {
    
    UIViewController *vc = [self hy_viewControllerFromIndex:index];
    if (vc) {
        NSMutableArray *arr = self.viewControllers.mutableCopy;
        [arr removeObject:vc];
        [self setViewControllers:arr.copy];
    }
}
- (void)hy_removeViewControllerToIndex:(NSInteger)index {
 
    UIViewController *vc = [self hy_viewControllerFromIndex:self.childViewControllers.count - index - 1];
    if (vc) {
        NSMutableArray *arr = self.viewControllers.mutableCopy;
        [arr removeObject:vc];
        [self setViewControllers:arr.copy];
    }
}

- (BOOL)hy_containViewControllerWithName:(NSString *)name {
    return [self hy_viewControllerWithName:name] ? YES : NO;
}

- (void)hy_repleaseViewControllerAtIndex:(NSInteger )index
                          withController:(UIViewController *)controller {
 
    if (index >= 0 && index < self.viewControllers.count) {
        controller.hidesBottomBarWhenPushed = index!= 0 ? YES : NO;
        NSMutableArray *arr = self.viewControllers.mutableCopy;
        [arr replaceObjectAtIndex:index withObject:controller];
        [self setViewControllers:arr.copy];
    }
}

- (void)hy_pushViewController:(UIViewController *)viewController
                     animated:(BOOL)animated
                   completion:(void (^_Nullable)(void))completion {
    
    [self hy_hookDidAppearWithViewController:viewController completion:completion];
    [self pushViewController:viewController animated:animated];
}

- (nullable UIViewController *)hy_popViewControllerAnimated:(BOOL)animated
                                                 completion:(void (^_Nullable)(void))completion {
    
    if (self.viewControllers.count > 2) {
        NSInteger index = self.viewControllers.count - 2;
        [self hy_hookDidAppearWithViewController:self.viewControllers[index] completion:completion];
    }
    return [self popViewControllerAnimated:YES];
}

- (nullable NSArray<__kindof UIViewController *> *)hy_popToViewController:(UIViewController *)viewController
                                                                 animated:(BOOL)animated
                                                               completion:(void (^_Nullable)(void))completion {
    
    if (self.viewControllers.count > 2 && [self.viewControllers containsObject:viewController]) {
        [self hy_hookDidAppearWithViewController:viewController completion:completion];
    }
    return [self popToViewController:viewController animated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)hy_popToRootViewControllerAnimated:(BOOL)animated
                                                                           completion:(void (^_Nullable)(void))completion {
    
    if (self.viewControllers.count > 2) {
        [self hy_hookDidAppearWithViewController:self.viewControllers.firstObject completion:completion];
    }
    return [self popToRootViewControllerAnimated:animated];
}

- (void)hy_hookDidAppearWithViewController:(UIViewController *)viewController
                                completion:(void (^)(void))completion {
 
    if (viewController && completion) {
        hy_swizzleAndResetInstanceMethodToBlock(viewController.class,sel_registerName("viewDidAppear:") , ^id(SEL sel, IMP (^impBlock)(void), void (^resetImpBlock)(void)) {
            return ^(UIViewController *_self, BOOL animated) {
                HyVoidImpFuctoin(_self, sel, animated);
                completion();
                resetImpBlock();
            };
        });
    }
}

- (void)setHy_poppingViewController:(UIViewController * _Nullable)hy_poppingViewController {
    objc_setAssociatedObject(self,
                             @selector(hy_poppingViewController),
                             [HyWeakObjectContainer containerWithObject:hy_poppingViewController],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIViewController *)hy_poppingViewController {
    return ((HyWeakObjectContainer *)objc_getAssociatedObject(self, _cmd)).object;
}

@end
