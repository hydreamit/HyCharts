//
//  HYSwipeViewController.m
//  DriverApp
//
//  Created by huangyi on 17/4/1.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "HYSwipeViewController.h"
#import "HYSwipeTransitioning.h"

@interface HYSwipeViewController ()
@property (nonatomic, assign) UIRectEdge dismissTargetEdge;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *EdgeLeftGesture;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *EdgeRightGesture;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *EdgeTopGesture;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *EdgeBottomGesture;
@property (nonatomic, strong) HYSwipeTransitioning *transitionDelegate;
@property (nonatomic, assign) BOOL isInitialed;
@end

@implementation HYSwipeViewController
#pragma mark - LifeCycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isInitialed) {
        return;
    }
    [self initPresentEdgeGesture];
    [self initDismissEdgeGesture];
    self.isInitialed = YES;
}

#pragma mark - Private Methods
- (void)initPresentEdgeGesture {
    if (self.swipeJumpToVc) {
        if (self.swipePresentEdge & HYPresentLeft) {
            if (!self.EdgeLeftGesture.view) {
                [self.view addGestureRecognizer:self.EdgeLeftGesture];
            }
        }
        
        if (self.swipePresentEdge & HYPresentRigt) {
            if (!self.EdgeRightGesture.view) {
                [self.view addGestureRecognizer:self.EdgeRightGesture];
            }
        }
        
        if (self.swipePresentEdge & HYPresentTop) {
            if (!self.EdgeTopGesture.view) {
                [self.view addGestureRecognizer:self.EdgeTopGesture];
            }
        }
        
        if (self.swipePresentEdge & HYPresentBottom) {
            if (!self.EdgeBottomGesture.view) {
                [self.view addGestureRecognizer:self.EdgeBottomGesture];
            }
        }
    }
}

- (void)initDismissEdgeGesture {
    id transitioningDelegate = self.navigationController.transitioningDelegate;
    if ([transitioningDelegate isKindOfClass:[HYSwipeTransitioning class]]) {
        HYSwipeTransitioning *swipeTransitionDelegate = (HYSwipeTransitioning *)transitioningDelegate;
        switch (swipeTransitionDelegate.targetEdge) {
            case UIRectEdgeLeft:
            {
                if (!self.EdgeRightGesture.view) {
                    [self.view addGestureRecognizer:self.EdgeRightGesture];
                    self.dismissTargetEdge = UIRectEdgeRight;
                }
            }break;
            case UIRectEdgeRight:
            {
                if (!self.EdgeLeftGesture.view) {
                    [self.view addGestureRecognizer:self.EdgeLeftGesture];
                    self.dismissTargetEdge = UIRectEdgeLeft;
                }
            }break;
            case UIRectEdgeTop:
            {
                if (!self.EdgeBottomGesture.view) {
                    [self.view addGestureRecognizer:self.EdgeBottomGesture];
                    self.dismissTargetEdge = UIRectEdgeBottom;
                }
            }break;
            case UIRectEdgeBottom:
            {
                if (!self.EdgeTopGesture.view) {
                    [self.view addGestureRecognizer:self.EdgeTopGesture];
                    self.dismissTargetEdge = UIRectEdgeTop;
                }
            }break;
            default:
            break;
        }
    }
}

- (void)hy_presentViewController:(UIViewController *)viewController
                     presentEdge:(HYPresentEdge)presentEdge
                        animated:(BOOL)flag
                      completion:(void (^)())completion {
    [self hy_presentViewController:viewController
                       presentEdge:presentEdge
                            sender:nil
                          animated:YES
                        completion:completion];
}

- (void)hy_presentViewController:(UIViewController *)viewController
                     presentEdge:(HYPresentEdge)presentEdge
                          sender:(id)sender
                        animated:(BOOL)flag
                      completion:(void (^)())completion {
    UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    HYSwipeTransitioning *transitionDelegate = self.transitionDelegate;
    if ([sender isKindOfClass:UIGestureRecognizer.class]) {
        transitionDelegate.gestureRecognizer = sender;
    } else {
        transitionDelegate.gestureRecognizer = nil;
    }
    transitionDelegate.targetEdge = [self checkPresentTargetEdge:presentEdge];
    Nav.transitioningDelegate = transitionDelegate;
    Nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:Nav animated:flag completion:^{
        !completion ? : completion();
    }];
}

- (void)hy_dismissViewControllerAnimated:(BOOL)flag
                              completion: (void (^)(void))completion {
    [self dismissViewControllerAnimated:flag
                                 sender:nil
                       completionHandle:completion];
}

- (void)dismissViewControllerAnimated:(BOOL)flag
                               sender:(id)sender
                     completionHandle:(void(^)())completionHandle {
    if ([self.navigationController.transitioningDelegate isKindOfClass:[HYSwipeTransitioning class]]) {
        HYSwipeTransitioning *transitionDelegate = (HYSwipeTransitioning *)self.navigationController.transitioningDelegate;
        if ([sender isKindOfClass:UIGestureRecognizer.class]) {
            transitionDelegate.gestureRecognizer = sender;
        } else {
            transitionDelegate.gestureRecognizer = nil;
        }
        transitionDelegate.targetEdge = self.dismissTargetEdge;
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            !completionHandle ? : completionHandle();
        }];
    }
}

- (UIRectEdge)checkPresentTargetEdge:(HYPresentEdge)PresentTargetEdge {
    UIRectEdge edge ;
    switch (PresentTargetEdge) {
        case HYPresentLeft:
        {
            edge = UIRectEdgeLeft;
        }break;
        case HYPresentRigt:
        {
            edge = UIRectEdgeRight;
        }break;
        case HYPresentTop:
        {
            edge = UIRectEdgeTop;
        }break;
        case HYPresentBottom:
        {
            edge = UIRectEdgeBottom;
        }break;
        default:
        break;
    }
    return edge;
}

#pragma mark - Event Response
- (void)EdgeLeftGestureAction:(UIScreenEdgePanGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (self.swipeJumpToVc) {
            [self hy_presentViewController:self.swipeJumpToVc
                               presentEdge:HYPresentLeft
                                    sender:sender
                                  animated:YES
                                completion:nil];
        } else {
            [self dismissViewControllerAnimated:YES
                                         sender:sender
                               completionHandle:nil];
        }
    }
}

- (void)EdgeRightGestureAction:(UIScreenEdgePanGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (self.swipeJumpToVc) {
            [self hy_presentViewController:self.swipeJumpToVc
                               presentEdge:HYPresentRigt
                                    sender:sender
                                  animated:YES
                                completion:nil];
        } else {
            [self dismissViewControllerAnimated:YES
                                         sender:sender
                               completionHandle:nil];
        }
    }
}

- (void)EdgeTopGestureAction:(UIScreenEdgePanGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (self.swipeJumpToVc) {
            [self hy_presentViewController:self.swipeJumpToVc
                               presentEdge:HYPresentTop
                                    sender:sender
                                  animated:YES
                                completion:nil];
        } else {
             [self dismissViewControllerAnimated:YES
                                          sender:sender
                                completionHandle:nil];
        }
    }
}

- (void)EdgeBottomGestureAction:(UIScreenEdgePanGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (self.swipeJumpToVc) {
            [self hy_presentViewController:self.swipeJumpToVc
                               presentEdge:HYPresentBottom
                                    sender:sender
                                  animated:YES
                                completion:nil];
        } else {
           [self dismissViewControllerAnimated:YES
                                        sender:sender
                              completionHandle:nil];
        }
    }
}

- (void)cancelAction:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES
                                 sender:btn
                       completionHandle:nil];
}

#pragma mark - Setters And Getters
- (UIScreenEdgePanGestureRecognizer *)EdgeLeftGesture {
    if (!_EdgeLeftGesture) {
        _EdgeLeftGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(EdgeLeftGestureAction:)];
        _EdgeLeftGesture.edges = UIRectEdgeLeft;
    }
    return _EdgeLeftGesture;
}

- (UIScreenEdgePanGestureRecognizer *)EdgeRightGesture {
    if (!_EdgeRightGesture) {
        _EdgeRightGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(EdgeRightGestureAction:)];
        _EdgeRightGesture.edges = UIRectEdgeRight;
    }
    return _EdgeRightGesture;
}

- (UIScreenEdgePanGestureRecognizer *)EdgeTopGesture {
    if (!_EdgeTopGesture) {
        _EdgeTopGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(EdgeTopGestureAction:)];
        _EdgeTopGesture.edges = UIRectEdgeTop;
    }
    return _EdgeTopGesture;
}

- (UIScreenEdgePanGestureRecognizer *)EdgeBottomGesture {
    if (!_EdgeBottomGesture) {
        _EdgeBottomGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(EdgeBottomGestureAction:)];
         _EdgeBottomGesture.edges = UIRectEdgeBottom;
    }
    return _EdgeBottomGesture;
}

- (HYSwipeTransitioning *)transitionDelegate {
    if (!_transitionDelegate) {
        _transitionDelegate = [[HYSwipeTransitioning alloc]  init];
    }
    return _transitionDelegate;
}

@end
