//
//  UIScrollView+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/8/29.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UIScrollView+HyExtension.h"
#import "HyRunTimeMethods.h"


@interface HyScrollViewDelegateConfigure () <UIScrollViewDelegate>
@property (nonatomic,copy) void (^scrollViewDidScroll)(UIScrollView *scrollView);
@property (nonatomic,copy) void (^scrollViewDidZoom)(UIScrollView *scrollView);
@property (nonatomic,copy) void (^scrollViewWillBeginDragging)(UIScrollView *scrollView);
@property (nonatomic,copy) void (^scrollViewWillBeginDecelerating)(UIScrollView *scrollView);
@property (nonatomic,copy) void (^scrollViewDidEndDecelerating)(UIScrollView *scrollView);
@property (nonatomic,copy) void (^scrollViewDidEndScrollingAnimation)(UIScrollView *scrollView);
@property (nonatomic,copy) void (^scrollViewDidScrollToTop)(UIScrollView *scrollView);
@property (nonatomic,copy) BOOL (^scrollViewShouldScrollToTop)(UIScrollView *scrollView);
@property (nonatomic,copy) void (^scrollViewDidChangeAdjustedContentInset)(UIScrollView *scrollView);
@property (nonatomic,copy) UIView *(^viewForZoomingInScrollView)(UIScrollView *scrollView);
@property (nonatomic,copy) void (^scrollViewWillBeginZooming)(UIScrollView *scrollView, UIView *view);
@property (nonatomic,copy) void (^scrollViewDidEndZooming)(UIScrollView *scrollView, UIView *view, CGFloat scale);
@property (nonatomic,copy) void (^scrollViewWillEndDragging)(UIScrollView *scrollView, CGPoint velocity, CGPoint targetContentOffset);
@property (nonatomic,copy) void (^scrollViewDidEndDragging)(UIScrollView *scrollView, BOOL willDecelerate);
@end


@implementation HyScrollViewDelegateConfigure
- (instancetype)configScrollViewDidScroll:(void (^)(UIScrollView *scrollView))block {
    self.scrollViewDidScroll = [block copy];
    return self;
}
- (instancetype)configScrollViewDidZoom:(void (^)(UIScrollView *scrollView))block {
    self.scrollViewDidZoom = [block copy];
    return self;
}
- (instancetype)configScrollViewWillBeginDragging:(void (^)(UIScrollView *scrollView))block{
    self.scrollViewWillBeginDragging = [block copy];
    return self;
}
- (instancetype)configScrollViewWillBeginDecelerating:(void (^)(UIScrollView *scrollView))block{
    self.scrollViewWillBeginDecelerating = [block copy];
    return self;
}
- (instancetype)configScrollViewDidEndDecelerating:(void (^)(UIScrollView *scrollView))block{
    self.scrollViewDidEndDecelerating = [block copy];
    return self;
}
- (instancetype)configScrollViewDidEndScrollingAnimation:(void (^)(UIScrollView *scrollView))block{
    self.scrollViewDidEndScrollingAnimation = [block copy];
    return self;
}
- (instancetype)configScrollViewDidScrollToTop:(void (^)(UIScrollView *scrollView))block{
    self.scrollViewDidScrollToTop = [block copy];
    return self;
}
- (instancetype)configScrollViewDidChangeAdjustedContentInset:(void (^)(UIScrollView *scrollView))block{
    self.scrollViewDidChangeAdjustedContentInset = [block copy];
    return self;
}
- (instancetype)configScrollViewShouldScrollToTop:(BOOL (^)(UIScrollView *scrollView))block{
    self.scrollViewShouldScrollToTop = [block copy];
    return self;
}
- (instancetype)configScrollViewForZoomingInScrollView:(UIView *(^)(UIScrollView *scrollView))block{
    self.viewForZoomingInScrollView = [block copy];
    return self;
}
- (instancetype)configScrollViewWillBeginZooming:(void (^)(UIScrollView *scrollView, UIView *view))block{
    self.scrollViewWillBeginZooming = [block copy];
    return self;
}
- (instancetype)configScrollViewDidEndZooming:(void (^)(UIScrollView *scrollView, UIView *view, CGFloat scale))block{
    self.scrollViewDidEndZooming = [block copy];
    return self;
}
- (instancetype)configScrollViewWillEndDragging:(void (^)(UIScrollView *scrollView,
                                                          CGPoint velocity,
                                                          CGPoint targetContentOffset))block{
    self.scrollViewWillEndDragging = [block copy];
    return self;
}
- (instancetype)configScrollViewDidEndDragging:(void (^)(UIScrollView *scrollView, BOOL willDecelerate))block{
    self.scrollViewDidEndDragging = [block copy];
    return self;
}

#pragma mark — UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollViewDidScroll  ?:
    self.scrollViewDidScroll (scrollView);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView  {
    !self.scrollViewDidZoom  ?:
    self.scrollViewDidZoom (scrollView);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    !self.scrollViewWillBeginDragging  ?:
    self.scrollViewWillBeginDragging (scrollView);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    !self.scrollViewWillBeginDecelerating  ?:
    self.scrollViewWillBeginDecelerating (scrollView);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    !self.scrollViewDidEndDecelerating  ?:
    self.scrollViewDidEndDecelerating (scrollView);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    !self.scrollViewDidEndScrollingAnimation  ?:
    self.scrollViewDidEndScrollingAnimation (scrollView);
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return
    self.viewForZoomingInScrollView  ?
    self.viewForZoomingInScrollView (scrollView) : nil;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.scrollViewWillEndDragging  ?
    self.scrollViewWillEndDragging (scrollView, velocity, *targetContentOffset) : nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.scrollViewDidEndDragging  ?
    self.scrollViewDidEndDragging (scrollView, decelerate) : nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    self.scrollViewWillBeginZooming  ?
    self.scrollViewWillBeginZooming (scrollView, view) : nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    self.scrollViewDidEndZooming  ?
    self.scrollViewDidEndZooming (scrollView, view, scale) : nil;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return
    self.scrollViewShouldScrollToTop  ?
    self.scrollViewShouldScrollToTop (scrollView) : YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    !self.scrollViewDidScrollToTop  ?:
    self.scrollViewDidScrollToTop (scrollView);
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    !self.scrollViewDidChangeAdjustedContentInset  ?:
    self.scrollViewDidChangeAdjustedContentInset (scrollView);
}
@end

@interface UIScrollView ()
@property (nonatomic,strong) HyScrollViewDelegateConfigure *hy_delegateConfigure;
@end
@implementation UIScrollView (HyExtension)

+ (instancetype)hy_scrollViewWithFrame:(CGRect)frame
                              delegate:(id<UIScrollViewDelegate>)delegate {
    
    UIScrollView *scrollView = [[self alloc] initWithFrame:frame];
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    scrollView.delegate = delegate;
    return scrollView;
}

+ (instancetype)hy_scrollViewWithFrame:(CGRect)frame
                     delegateConfigure:(void(^)(HyScrollViewDelegateConfigure *configure))delegateConfigure {
    
    UIScrollView *scrollView = [[self alloc] initWithFrame:frame];
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    scrollView.hy_delegateConfigure = [[HyScrollViewDelegateConfigure alloc] init];
    !delegateConfigure ?: delegateConfigure(scrollView.hy_delegateConfigure);
    scrollView.delegate = scrollView.hy_delegateConfigure;
    return scrollView;
}

- (void)setHy_delegateConfigure:(HyScrollViewDelegateConfigure *)hy_delegateConfigure {
    
    objc_setAssociatedObject(self,
                             @selector(hy_delegateConfigure),
                             hy_delegateConfigure,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HyScrollViewDelegateConfigure *)hy_delegateConfigure {
    return objc_getAssociatedObject(self, _cmd);
}

- (BOOL)hy_isAtTop {
    if (((NSInteger)self.contentOffset.y) == -((NSInteger)self.hy_contentInset.top)) {
        return YES;
    }
    return NO;
}

- (BOOL)hy_isAtBottom {
    if (!self.hy_canScroll) {
        return YES;
    }
    if (((NSInteger)self.contentOffset.y) == ((NSInteger)self.contentSize.height + self.hy_contentInset.bottom - CGRectGetHeight(self.bounds))) {
        return YES;
    }
    return NO;
}

- (BOOL)hy_isAtLeft {
    if (((NSInteger)self.contentOffset.x) == -((NSInteger)self.hy_contentInset.left)) {
        return YES;
    }
    return NO;
}

- (BOOL)hy_isAtRight {
    if (!self.hy_canScroll) {
        return YES;
    }
    if (((NSInteger)self.contentOffset.x) == ((NSInteger)self.contentSize.width + self.hy_contentInset.left - CGRectGetWidth(self.bounds))) {
        return YES;
    }
    return NO;
}

- (BOOL)hy_canScroll {
    
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
        return NO;
    }
    BOOL canVerticalScroll = self.contentSize.height + self.hy_contentInset.top + self.hy_contentInset.bottom > CGRectGetHeight(self.bounds);
    BOOL canHorizontalScoll = self.contentSize.width + self.hy_contentInset.left + self.hy_contentInset.right > CGRectGetWidth(self.bounds);
    return canVerticalScroll || canHorizontalScoll;
}

- (UIEdgeInsets)hy_contentInset {
    if (@available(iOS 11, *)) {
        return self.adjustedContentInset;
    } else {
        return self.hy_contentInset;
    }
}

- (void)hy_scrollToTopAnimated:(BOOL)animated {
    
    CGPoint off = self.contentOffset;
    off.y = 0 - self.hy_contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)hy_scrollToBottomAnimated:(BOOL)animated {
    
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.hy_contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)hy_scrollToLeftAnimated:(BOOL)animated {
    
    CGPoint off = self.contentOffset;
    off.x = 0 - self.hy_contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)hy_scrollToRightAnimated:(BOOL)animated {
    
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.hy_contentInset.right;
    [self setContentOffset:off animated:animated];
}

@end
