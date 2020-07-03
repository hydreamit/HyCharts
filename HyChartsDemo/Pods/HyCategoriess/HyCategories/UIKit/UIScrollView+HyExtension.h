//
//  UIScrollView+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/8/29.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HyScrollViewDelegateConfigure : NSObject
@property (nonatomic,copy,readonly) HyScrollViewDelegateConfigure *(^configScrollViewDidScroll)(void (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HyScrollViewDelegateConfigure *(^configScrollViewDidZoom)(void (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HyScrollViewDelegateConfigure *(^configScrollViewWillBeginDragging)(void (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HyScrollViewDelegateConfigure *(^configScrollViewWillBeginDecelerating)(void (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HyScrollViewDelegateConfigure *(^configScrollViewDidEndDecelerating)(void (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HyScrollViewDelegateConfigure *(^configScrollViewDidEndScrollingAnimation)(void (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HyScrollViewDelegateConfigure *(^configScrollViewDidScrollToTop)(void (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HyScrollViewDelegateConfigure *(^configScrollViewDidChangeAdjustedContentInset)(void (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HyScrollViewDelegateConfigure *(^configScrollViewShouldScrollToTop)(BOOL (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HyScrollViewDelegateConfigure *(^configScrollViewForZoomingInScrollView)(UIView *(^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HyScrollViewDelegateConfigure *(^configScrollViewWillBeginZooming)(void (^)(UIScrollView *scrollView, UIView *view));
@property (nonatomic,copy,readonly) HyScrollViewDelegateConfigure *(^configScrollViewDidEndZooming)(void (^)(UIScrollView *scrollView, UIView *view, CGFloat scale));
@property (nonatomic,copy,readonly) HyScrollViewDelegateConfigure *(^configScrollViewWillEndDragging)(void (^)(UIScrollView *scrollView, CGPoint velocity, CGPoint targetContentOffset));
@property (nonatomic,copy,readonly) HyScrollViewDelegateConfigure *(^configScrollViewDidEndDragging)(void (^)(UIScrollView *scrollView, BOOL willDecelerate));
@end



@interface UIScrollView (HyExtension)

@property (nonatomic,assign,readonly) BOOL hy_canScroll;
@property (nonatomic,assign,readonly) BOOL hy_isAtTop;
@property (nonatomic,assign,readonly) BOOL hy_isAtBottom;
@property (nonatomic,assign,readonly) BOOL hy_isAtLeft;
@property (nonatomic,assign,readonly) BOOL hy_isAtRight;
@property (nonatomic,assign,readonly) UIEdgeInsets hy_contentInset;
@property (nonatomic,strong,readonly) HyScrollViewDelegateConfigure *hy_delegateConfigure;


+ (instancetype)hy_scrollViewWithFrame:(CGRect)frame
                              delegate:(id<UIScrollViewDelegate>)delegate;

+ (instancetype)hy_scrollViewWithFrame:(CGRect)frame
                     delegateConfigure:(void(^)(HyScrollViewDelegateConfigure *configure))delegateConfigure;


- (void)hy_scrollToTopAnimated:(BOOL)animated;
- (void)hy_scrollToBottomAnimated:(BOOL)animated;
- (void)hy_scrollToLeftAnimated:(BOOL)animated;
- (void)hy_scrollToRightAnimated:(BOOL)animated;

@end
