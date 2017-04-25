//
//  HYSwipeViewController.h
//  DriverApp
//
//  Created by huangyi on 17/4/1.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(int, HYPresentEdge) {
    HYPresentLeft = 1 << 0,
    HYPresentRigt = 1 << 1,
    HYPresentTop  = 1 << 2,
    HYPresentBottom = 1 << 3
};

@interface HYSwipeViewController : UIViewController

- (void)hy_presentViewController:(UIViewController *)viewController
                     presentEdge:(HYPresentEdge)presentEdge
                        animated:(BOOL)flag
                      completion:(void (^)())completion;

- (void)hy_dismissViewControllerAnimated: (BOOL)flag
                              completion: (void (^)(void))completion;


// 通过边缘手势滑动可以present, 初始化这两个个参数
@property (nonatomic, readwrite) HYPresentEdge swipePresentEdge;//可多选 （HYPresentTop | HYPresentLeft | HYPresentBottom | HYPresentRigt)
@property (nonatomic, strong) UIViewController *swipeJumpToVc; // 边缘手势滑动Present到的VC

@end
