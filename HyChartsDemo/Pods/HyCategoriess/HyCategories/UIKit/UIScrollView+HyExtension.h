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
- (instancetype)configScrollViewDidScroll:(void (^)(UIScrollView *scrollView))block;
- (instancetype)configScrollViewDidZoom:(void (^)(UIScrollView *scrollView))block;
- (instancetype)configScrollViewWillBeginDragging:(void (^)(UIScrollView *scrollView))block;
- (instancetype)configScrollViewWillBeginDecelerating:(void (^)(UIScrollView *scrollView))block;
- (instancetype)configScrollViewDidEndDecelerating:(void (^)(UIScrollView *scrollView))block;
- (instancetype)configScrollViewDidEndScrollingAnimation:(void (^)(UIScrollView *scrollView))block;
- (instancetype)configScrollViewDidScrollToTop:(void (^)(UIScrollView *scrollView))block;
- (instancetype)configScrollViewDidChangeAdjustedContentInset:(void (^)(UIScrollView *scrollView))block;
- (instancetype)configScrollViewShouldScrollToTop:(BOOL (^)(UIScrollView *scrollView))block;
- (instancetype)configScrollViewForZoomingInScrollView:(UIView *(^)(UIScrollView *scrollView))block;
- (instancetype)configScrollViewWillBeginZooming:(void (^)(UIScrollView *scrollView, UIView *view))block;
- (instancetype)configScrollViewDidEndZooming:(void (^)(UIScrollView *scrollView, UIView *view, CGFloat scale))block;
- (instancetype)configScrollViewWillEndDragging:(void (^)(UIScrollView *scrollView, CGPoint velocity, CGPoint targetContentOffset))block;
- (instancetype)configScrollViewDidEndDragging:(void (^)(UIScrollView *scrollView, BOOL willDecelerate))block;
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
