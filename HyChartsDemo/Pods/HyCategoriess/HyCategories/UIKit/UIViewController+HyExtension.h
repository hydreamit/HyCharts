//
//  UIViewController+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/11.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HyPopGestureState) {
    HyPopGestureState_No,
    HyPopGestureState_Begin,
    HyPopGestureState_Change,
    HyPopGestureState_SuccessPop,
    HyPopGestureState_FailPop
};

@protocol UINavigationControllerPopGestureHandlerProtocol <NSObject>
@optional
- (void)hy_popGestureHandlerWithState:(HyPopGestureState)state
                   isPopingController:(BOOL)isPopingController;
@end



@interface UIViewController (HyExtension) <UINavigationControllerPopGestureHandlerProtocol>

@property (nonatomic,assign,readonly) BOOL hy_isPresented;
@property (nonatomic,assign) HyPopGestureState  hy_popGestureState;
@property (nonatomic,copy) void(^hy_reloadControllerBlock)(id params);

@property (nonatomic,copy,nullable) void(^hy_viewDidLoadBlock)(UIViewController *_self);
@property (nonatomic,copy,nullable) void(^hy_viewWillAppearBlock)(UIViewController *_self, BOOL animated, BOOL firstLoad);
@property (nonatomic,copy,nullable) void(^hy_viewDidAppearBlock)(UIViewController *_self, BOOL animated, BOOL firstLoad);
@property (nonatomic,copy,nullable) void(^hy_viewWillLayoutSubviewsBlock)(UIViewController *_self, BOOL firstLoad);
@property (nonatomic,copy,nullable) void(^hy_viewDidLayoutSubviewsBlock)(UIViewController *_self, BOOL firstLoad);

@property (nonatomic,copy,nullable) void(^hy_viewWillDisappearBlock)(UIViewController *_self, BOOL animated);
@property (nonatomic,copy,nullable) void(^hy_viewDidDisappearBlock)(UIViewController *_self, BOOL animated);

- (void)hy_viewDidLoad;
- (void)hy_viewWillAppear:(BOOL)animated firstLoad:(BOOL)flag;
- (void)hy_viewDidAppear:(BOOL)animated firstLoad:(BOOL)flag;
- (void)hy_viewWillLayoutSubviewsIsFirstLoad:(BOOL)flag;
- (void)hy_viewDidLayoutSubviewsIsFirstLoad:(BOOL)flag;

- (void)hy_viewWillDisappear:(BOOL)animated;
- (void)hy_viewDidDisappear:(BOOL)animated;

+ (nullable UIViewController *)hy_topViewController;
+ (nullable UIViewController *)hy_currentViewController;
- (nullable UIViewController *)hy_childViewControllerWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
