//
//  HYSwipeTransitioning.m
//  DriverApp
//
//  Created by huangyi on 17/3/17.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "HYSwipeTransitioning.h"

#define TransitionDuration .25
#define BlackViewAlpha 0.35

@interface HYSwipeTransitionInteractiveTransition : UIPercentDrivenInteractiveTransition
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong, readonly) UIScreenEdgePanGestureRecognizer *gestureRecognizer;
@property (nonatomic, readonly) UIRectEdge edge;
- (instancetype)initWithGestureRecognizer:(UIScreenEdgePanGestureRecognizer*)gestureRecognizer edgeForDragging:(UIRectEdge)edge;
@end

@implementation HYSwipeTransitionInteractiveTransition
- (instancetype)initWithGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer edgeForDragging:(UIRectEdge)edge {
    if (self = [super init]) {
        _gestureRecognizer = gestureRecognizer;
        _edge = edge;
        [_gestureRecognizer addTarget:self action:@selector(gestureRecognizeDidUpdate:)];
    }
    return self;
}

#pragma mark - UIViewControllerInteractiveTransitioning
- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    [super startInteractiveTransition:transitionContext];
}

- (CGFloat)percentForGesture:(UIScreenEdgePanGestureRecognizer *)gesture {

    UIView *transitionContainerView = self.transitionContext.containerView;
    CGPoint locationInSourceView = [gesture locationInView:transitionContainerView];
    CGFloat width = CGRectGetWidth(transitionContainerView.bounds);
    CGFloat height = CGRectGetHeight(transitionContainerView.bounds);
    
    switch (self.edge) {
        case UIRectEdgeRight:
        {
            return (width - locationInSourceView.x) / width;
        }break;
        case UIRectEdgeLeft:
        {
            return locationInSourceView.x / width;
        }break;
        case UIRectEdgeBottom:
        {
            return (height - locationInSourceView.y) / height;
        }break;
        case UIRectEdgeTop:
        {
             return locationInSourceView.y / height;
        }break;
        default:
        {
             return 0.f;
        }break;
    }
}

- (void)gestureRecognizeDidUpdate:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self updateInteractiveTransition:[self percentForGesture:gestureRecognizer]];
        }break;
        case UIGestureRecognizerStateEnded:
        {
            [self percentForGesture:gestureRecognizer] >= 0.5f ? [self finishInteractiveTransition] : [self cancelInteractiveTransition];
        }break;
        default:
        {
            [self cancelInteractiveTransition];
        }break;
    }
}

- (void)dealloc {
    [self.gestureRecognizer removeTarget:self action:@selector(gestureRecognizeDidUpdate:)];
}

@end


@implementation HYSwipeTransitioning
#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
     return  self.gestureRecognizer ? [[HYSwipeTransitionInteractiveTransition alloc] initWithGestureRecognizer:self.gestureRecognizer edgeForDragging:self.targetEdge] : nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
   return  self.gestureRecognizer ? [[HYSwipeTransitionInteractiveTransition alloc] initWithGestureRecognizer:self.gestureRecognizer edgeForDragging:self.targetEdge] : nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return TransitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    
    UIView *fromView;
    UIView *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    BOOL isPresenting = (toViewController.presentingViewController == fromViewController);
    
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    
    CGVector offset;
    switch (self.targetEdge) {
        case UIRectEdgeTop:
        {
            offset = CGVectorMake(0.f, 1.f);
        } break;
        case UIRectEdgeBottom:
        {
            offset = CGVectorMake(0.f, -1.f);
        } break;
        case UIRectEdgeLeft:
        {
            offset = CGVectorMake(1.f, 0.f);
        } break;
        case UIRectEdgeRight:
        {
            offset = CGVectorMake(-1.f, 0.f);
        } break;
        default:
        break;
    }
    
    if (isPresenting) {
        fromView.frame = fromFrame;
        toView.frame = CGRectOffset(toFrame, toFrame.size.width * offset.dx * -1,
                                    toFrame.size.height * offset.dy * -1);
    } else {
        fromView.frame = fromFrame;
        toView.frame = toFrame;
    }
    
#pragma mark - 手势滑动加黑色透明背景
    UIView *blackView;
    if (transitionContext.interactive) {
        blackView = [[UIView alloc] init];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = isPresenting ? 0 : BlackViewAlpha;
        blackView.frame = containerView.bounds;
    }
    if (isPresenting) {
        if (transitionContext.interactive) {
            [containerView addSubview:blackView];
        }
        [containerView addSubview:toView];
    }else{
        [containerView insertSubview:toView belowSubview:fromView];
        if (transitionContext.interactive) {
            [containerView insertSubview:blackView aboveSubview:toView];
        }
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
        if (isPresenting) {
            if (transitionContext.interactive) {
                blackView.alpha = BlackViewAlpha;
            }
            toView.frame = toFrame;
        } else {
            if (transitionContext.interactive) {
                blackView.alpha = 0.0;
            }
            fromView.frame = CGRectOffset(fromFrame, fromFrame.size.width * offset.dx,
                                          fromFrame.size.height * offset.dy);
        }
        
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        if (wasCancelled) {
            [toView removeFromSuperview];
        }
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
