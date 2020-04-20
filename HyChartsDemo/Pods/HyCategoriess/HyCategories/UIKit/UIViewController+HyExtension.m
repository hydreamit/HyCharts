//
//  UIViewController+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/11.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UIViewController+HyExtension.h"
#import "UINavigationController+HyExtension.h"
#import "HyRunTimeMethods.h"

@interface HyTopViewControllerManager : NSObject
@property (nonatomic, weak) UIViewController *hy_topViewController;
@end

@implementation HyTopViewControllerManager
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}
@end

@interface UIViewController()
@property (nonatomic, assign) BOOL hy_willAppearFirstLoad;
@property (nonatomic, assign) BOOL hy_didAppearFirstLoad;
@property (nonatomic, assign) BOOL hy_WillLayoutSubviewsFirstLoad;
@property (nonatomic, assign) BOOL hy_didLayoutSubviewsFirstLoad;
@end


@implementation UIViewController (HyExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        hy_swizzleInstanceMethodToBlock([self class], @selector(viewDidLoad), ^id(SEL sel, IMP (^impBlock)(void)) {
            return ^(UIViewController *_self){
                
                HyVoidImpFuctoin(_self, sel);

                [_self hy_viewDidLoad];
            };
        });
        
        hy_swizzleInstanceMethodToBlock([self class], @selector(viewWillAppear:), ^id(SEL sel, IMP (^impBlock)(void)) {
            return ^(UIViewController *_self, BOOL animated){
                
                HyVoidImpFuctoin(_self, sel, animated);
                
                if (_self.hy_popGestureState == HyPopGestureState_No) {
                    [_self hy_viewWillAppear:animated firstLoad:!_self.hy_willAppearFirstLoad];
                    if (!_self.hy_willAppearFirstLoad) {
                        _self.hy_willAppearFirstLoad = YES;
                    }
                }
            };
        });
        
        hy_swizzleInstanceMethodToBlock([self class], @selector(viewDidAppear:), ^id(SEL sel, IMP (^impBlock)(void)) {
            return ^(UIViewController *_self, BOOL animated){
                
                HyVoidImpFuctoin(_self, sel, animated);

                if (_self.hy_popGestureState == HyPopGestureState_No) {
                    [_self hy_viewDidAppear:animated firstLoad:!_self.hy_didAppearFirstLoad];
                    if (!_self.hy_didAppearFirstLoad) {
                        _self.hy_didAppearFirstLoad = YES;
                     }
                }
            };
        });
        
        hy_swizzleInstanceMethodToBlock([self class], @selector(viewWillLayoutSubviews), ^id(SEL sel, IMP (^impBlock)(void)) {
            return ^(UIViewController *_self){
                
                HyVoidImpFuctoin(_self, sel);
                
                if (_self.hy_popGestureState == HyPopGestureState_No) {
                    [_self hy_viewWillLayoutSubviewsIsFirstLoad:!_self.hy_WillLayoutSubviewsFirstLoad];
                    if (!_self.hy_WillLayoutSubviewsFirstLoad) {
                       _self.hy_WillLayoutSubviewsFirstLoad = YES;
                    }
                }
            };
        });
       
        hy_swizzleInstanceMethodToBlock([self class], @selector(viewDidLayoutSubviews), ^id(SEL sel, IMP (^impBlock)(void)) {
            return ^(UIViewController *_self){
                
                HyVoidImpFuctoin(_self, sel);
                
                if (_self.hy_popGestureState == HyPopGestureState_No) {
                    [_self hy_viewDidLayoutSubviewsIsFirstLoad:!_self.hy_didLayoutSubviewsFirstLoad];
                    if (!_self.hy_didLayoutSubviewsFirstLoad) {
                        _self.hy_didLayoutSubviewsFirstLoad = YES;
                    }
                }
            };
        });
        
        hy_swizzleInstanceMethodToBlock([self class], @selector(viewWillDisappear:), ^id(SEL sel, IMP (^impBlock)(void)) {
            
            return ^(UIViewController *_self, BOOL animated){
                
                HyVoidImpFuctoin(_self, sel, animated);
                
                if (_self.hy_popGestureState == HyPopGestureState_No) {
                    [_self hy_viewWillDisappear:animated];
                }
            };
        });
        
        hy_swizzleInstanceMethodToBlock([self class], @selector(viewDidDisappear:), ^id(SEL sel, IMP (^impBlock)(void)) {
            
            return ^(UIViewController *_self, BOOL animated){
                
                HyVoidImpFuctoin(_self, sel, animated);
                
                if (_self.hy_popGestureState == HyPopGestureState_No) {
                    [_self hy_viewDidDisappear:animated];
                }
            };
        });
        
        
        hy_swizzleInstanceMethodToBlock([self class], @selector(hy_viewDidLoad), ^id(SEL sel, IMP (^impBlock)(void)) {
            return ^(UIViewController *_self){
                
                HyVoidImpFuctoin(_self, sel);
                !_self.hy_viewDidLoadBlock ?: _self.hy_viewDidLoadBlock(_self);
            };
        });
        
        hy_swizzleInstanceMethodToBlock([self class], @selector(hy_viewWillAppear:firstLoad:), ^id(SEL sel, IMP (^impBlock)(void)) {
            return ^(UIViewController *_self, BOOL animated, BOOL flag){
                
                HyVoidImpFuctoin(_self, sel, animated, flag);
                
                [HyTopViewControllerManager sharedManager].hy_topViewController = _self;
                !_self.hy_viewWillAppearBlock ?: _self.hy_viewWillAppearBlock(_self, animated, flag);
            };
        });
        
        hy_swizzleInstanceMethodToBlock([self class], @selector(hy_viewWillLayoutSubviewsIsFirstLoad:), ^id(SEL sel, IMP (^impBlock)(void)) {
            return ^(UIViewController *_self, BOOL flag){
                
                HyVoidImpFuctoin(_self, sel, flag);
                !_self.hy_viewWillLayoutSubviewsBlock ?: _self.hy_viewWillLayoutSubviewsBlock(_self, flag);
            };
        });
        
        hy_swizzleInstanceMethodToBlock([self class], @selector(hy_viewDidLayoutSubviewsIsFirstLoad:), ^id(SEL sel, IMP (^impBlock)(void)) {
            return ^(UIViewController *_self, BOOL flag){
                
                HyVoidImpFuctoin(_self, sel, flag);
                !_self.hy_viewDidLayoutSubviewsBlock ?: _self.hy_viewDidLayoutSubviewsBlock(_self, flag);
            };
        });
        
        hy_swizzleInstanceMethodToBlock([self class], @selector(hy_viewDidAppear:firstLoad:), ^id(SEL sel, IMP (^impBlock)(void)) {
            return ^(UIViewController *_self, BOOL animated, BOOL flag){
                
                HyVoidImpFuctoin(_self, sel, animated, flag);
                !_self.hy_viewDidAppearBlock ?: _self.hy_viewDidAppearBlock(_self, animated, flag);
            };
        });
        
        hy_swizzleInstanceMethodToBlock([self class], @selector(hy_viewWillDisappear:), ^id(SEL sel, IMP (^impBlock)(void)) {
            
            return ^(UIViewController *_self, BOOL animated){
                
                HyVoidImpFuctoin(_self, sel, animated);
                !_self.hy_viewWillDisappearBlock ?: _self.hy_viewWillDisappearBlock(_self, animated);
            };
        });
        
        hy_swizzleInstanceMethodToBlock([self class], @selector(hy_viewDidDisappear:), ^id(SEL sel, IMP (^impBlock)(void)) {
            
            return ^(UIViewController *_self, BOOL animated){
                
                HyVoidImpFuctoin(_self, sel, animated);
                !_self.hy_viewDidDisappearBlock ?: _self.hy_viewDidDisappearBlock(_self, animated);
            };
        });
    });
}

+ (UIViewController *)hy_topViewController {
    return [HyTopViewControllerManager sharedManager].hy_topViewController;
}

+ (UIViewController *)hy_currentViewController {
    
       UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
       while (1) {
         if ([vc isKindOfClass:[UITabBarController class]]) {
             vc = ((UITabBarController*)vc).selectedViewController;
         }
         if ([vc isKindOfClass:[UINavigationController class]]) {
             vc = ((UINavigationController*)vc).visibleViewController;
         }
         if (vc.presentedViewController) {
             vc = vc.presentedViewController;
         }else{
            break;
         }
       }
       return vc;
}

- (nullable UIViewController *)hy_childViewControllerWithName:(NSString *)name {
    __block UIViewController *vc;
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass(obj.class) isEqualToString:name]) {
            vc = obj;
            *stop = YES;
        }
    }];
    return vc;
}

- (BOOL)hy_isPresented {
    
    UIViewController *viewController = self;
    if (self.navigationController) {
        if (self.navigationController.hy_rootViewController != self) {
            return NO;
        }
        viewController = self.navigationController;
    }
    return viewController.presentingViewController.presentedViewController == viewController;;
}

- (void)hy_viewDidLoad {}

- (void)hy_viewWillAppear:(BOOL)animated firstLoad:(BOOL)flag {}
- (void)hy_viewDidAppear:(BOOL)animated firstLoad:(BOOL)flag {}
- (void)hy_viewWillLayoutSubviewsIsFirstLoad:(BOOL)flag {}
- (void)hy_viewDidLayoutSubviewsIsFirstLoad:(BOOL)flag {}
- (void)hy_viewWillDisappear:(BOOL)animated {}
- (void)hy_viewDidDisappear:(BOOL)animated {}

- (void)setHy_popGestureState:(HyPopGestureState)hy_popGestureState {
    objc_setAssociatedObject(self,
                             @selector(hy_popGestureState),
                             @(hy_popGestureState),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (HyPopGestureState)hy_popGestureState {
    NSNumber *state = objc_getAssociatedObject(self, _cmd) ?: @(HyPopGestureState_No);
    return [state integerValue];
}

- (void)setHy_viewDidLoadBlock:(void (^)(UIViewController *))hy_viewDidLoadBlock {
    objc_setAssociatedObject(self,
                             @selector(hy_viewDidLoadBlock),
                             hy_viewDidLoadBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(UIViewController *))hy_viewDidLoadBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHy_viewWillAppearBlock:(void (^)(UIViewController *, BOOL, BOOL))hy_viewWillAppearBlock {
    objc_setAssociatedObject(self,
                             @selector(hy_viewWillAppearBlock),
                             hy_viewWillAppearBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(UIViewController *, BOOL, BOOL))hy_viewWillAppearBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHy_viewWillLayoutSubviewsBlock:(void (^)(UIViewController *, BOOL))hy_viewWillLayoutSubviewsBlock {
    objc_setAssociatedObject(self,
                             @selector(hy_viewWillLayoutSubviewsBlock),
                             hy_viewWillLayoutSubviewsBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(UIViewController *, BOOL))hy_viewWillLayoutSubviewsBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHy_viewDidLayoutSubviewsBlock:(void (^)(UIViewController *, BOOL))hy_viewDidLayoutSubviewsBlock {
    objc_setAssociatedObject(self,
                             @selector(hy_viewDidLayoutSubviewsBlock),
                             hy_viewDidLayoutSubviewsBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(UIViewController *, BOOL))hy_viewDidLayoutSubviewsBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHy_viewDidAppearBlock:(void (^)(UIViewController *, BOOL, BOOL))hy_viewDidAppearBlock {
    objc_setAssociatedObject(self,
                             @selector(hy_viewDidAppearBlock),
                             hy_viewDidAppearBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(UIViewController *, BOOL, BOOL))hy_viewDidAppearBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHy_viewWillDisappearBlock:(void (^)(UIViewController *, BOOL))hy_viewWillDisappearBlock {
    objc_setAssociatedObject(self,
                             @selector(hy_viewWillDisappearBlock),
                             hy_viewWillDisappearBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(UIViewController *, BOOL))hy_viewWillDisappearBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHy_viewDidDisappearBlock:(void (^)(UIViewController *, BOOL))hy_viewDidDisappearBlock {
    objc_setAssociatedObject(self,
                             @selector(hy_viewDidDisappearBlock),
                             hy_viewDidDisappearBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(UIViewController *, BOOL))hy_viewDidDisappearBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHy_reloadControllerBlock:(void (^)(id _Nonnull))hy_reloadControllerBlock {
    objc_setAssociatedObject(self,
                             @selector(hy_reloadControllerBlock),
                             hy_reloadControllerBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(id _Nonnull))hy_reloadControllerBlock {
   return objc_getAssociatedObject(self, _cmd);
}

- (void)setHy_willAppearFirstLoad:(BOOL)hy_willAppearFirstLoad {
        objc_setAssociatedObject(self,
                                 @selector(hy_willAppearFirstLoad),
                                 @(hy_willAppearFirstLoad),
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hy_willAppearFirstLoad {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHy_didAppearFirstLoad:(BOOL)hy_didAppearFirstLoad {
    objc_setAssociatedObject(self,
                             @selector(hy_didAppearFirstLoad),
                             @(hy_didAppearFirstLoad),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hy_didAppearFirstLoad {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHy_WillLayoutSubviewsFirstLoad:(BOOL)hy_WillLayoutSubviewsFirstLoad {
        objc_setAssociatedObject(self,
                                 @selector(hy_WillLayoutSubviewsFirstLoad),
                                 @(hy_WillLayoutSubviewsFirstLoad),
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hy_WillLayoutSubviewsFirstLoad {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHy_didLayoutSubviewsFirstLoad:(BOOL)hy_didLayoutSubviewsFirstLoad {
        objc_setAssociatedObject(self,
                                 @selector(hy_didLayoutSubviewsFirstLoad),
                                 @(hy_didLayoutSubviewsFirstLoad),
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hy_didLayoutSubviewsFirstLoad {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
