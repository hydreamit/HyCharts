//
//  HyCyclePageView.h
//  HyCycleView
//  https://github.com/hydreamit/HyCycleView
//
//  Created by Hy on 2016/5/15.
//  Copyright © 2016年 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyCycleView.h"


/// gesture style(内部手势处理方式)
typedef NS_ENUM(NSUInteger, HyCyclePageViewGestureStyle) {
    /// only gesture(一个手势,不需解决手势冲突)
    HyCyclePageViewGestureStyleOnly,
    /// multiple gestures(多个手势,需解决手势冲突)
    HyCyclePageViewGestureStyleMultiple
};

typedef NS_ENUM(NSUInteger, HyCyclePageViewHeaderViewUpAnimation) {
    /// UpAnimationNone
    HyCyclePageViewHeaderViewUpAnimationNone,
    /// UpAnimationCover
    HyCyclePageViewHeaderViewUpAnimationCover
};

typedef NS_ENUM(NSUInteger, HyCyclePageViewHeaderViewDownAnimation) {
    /// DownAnimationNone
    HyCyclePageViewHeaderViewDownAnimationNone,
    /// AnimationScale
    HyCyclePageViewHeaderViewDownAnimationScale
};

typedef NS_ENUM(NSUInteger, HyCyclePageViewHeaderRefreshStyle) {
    /// top refresh
    HyCyclePageViewHeaderRefreshStyleTop,
    /// center refresh
    HyCyclePageViewHeaderRefreshStyleCenter
};


@class HyCyclePageView;
@interface HyCyclePageViewConfigure : NSObject

/// currentPage
@property (nonatomic,assign,readonly) NSInteger currentPage;
@property (nonatomic,weak,readonly) HyCyclePageView *cyclePageView;

/// gesture Style(需要悬停嵌套scrollView时的 手势处理方式)
- (HyCyclePageViewConfigure *(^)(HyCyclePageViewGestureStyle))gestureStyle;
/// header refresh style
- (HyCyclePageViewConfigure *(^)(HyCyclePageViewHeaderRefreshStyle))headerRefreshStyle;

/// header view (头部视图)
- (HyCyclePageViewConfigure *(^)(UIView *))headerView;
/// header view height (头部视图高度)
- (HyCyclePageViewConfigure *(^)(CGFloat ))headerViewHeight;
/// header view up Animation(头部视图上滑动画)
- (HyCyclePageViewConfigure *(^)(HyCyclePageViewHeaderViewUpAnimation))headerViewUpAnimation;
/// header view down Animation(头部视图下拉动画)
- (HyCyclePageViewConfigure *(^)(HyCyclePageViewHeaderViewDownAnimation))headerViewDownAnimation;

/// hover view (悬停视图)
- (HyCyclePageViewConfigure *(^)(UIView *))hoverView;
/// hover view (悬停视图高度)
- (HyCyclePageViewConfigure *(^)(CGFloat))hoverViewHeight;
/// hover offset default 0 (悬停位置偏移量 默认为0)
- (HyCyclePageViewConfigure *(^)(CGFloat))hoverOffset;

/// cycle page loop default yes (是否为无限循环 默认为YES)
- (HyCyclePageViewConfigure *(^)(BOOL))isCycleLoop;
/// start page (开始页)
- (HyCyclePageViewConfigure *(^)(NSInteger))startPage;
/// total Pages (总页数)
- (HyCyclePageViewConfigure *(^)(NSInteger))totalPage;

/// cycle page view load style (view/Controller加载方式: 滑动出现立即加载/滑动到整个页面再加载)
- (HyCyclePageViewConfigure *(^)(HyCycleViewScrollLoadStyle))loadStyle;
/// cycle views/controllers of class (传入的是class)
- (HyCyclePageViewConfigure *(^)(Class (^)(HyCyclePageView *, NSInteger)))cyclePageClass;
/// cycle page views/controllers (传入的是实例对象)
- (HyCyclePageViewConfigure *(^)(id (^)(HyCyclePageView *, NSInteger)))cyclePageInstance;


/// one page view will appear callback (view 即将出现的回调)
- (HyCyclePageViewConfigure *(^)(void(^)(HyCyclePageView *,  // HyCyclePageView
                                         id,                // cycleView
                                         NSInteger,        // currentIndex
                                         BOOL))           // is first load
                                         )viewWillAppear;

/// totalPage and currentPage change (总页/当前页发生改变的回调)
- (HyCyclePageViewConfigure *(^)(void(^)(HyCyclePageView *, // HyCycleView
                                         NSInteger,        // totalPage
                                         NSInteger))      // currentPage
                                         )currentPageChange;

/// totalPage and roundingPage change (总页/当前页(四舍五入)发生改变的回调)
- (HyCyclePageViewConfigure *(^)(void(^)(HyCyclePageView *, // HyCycleView
                                         NSInteger,        // totalPage
                                         NSInteger))      // roundingPage
                                         )roundingPageChange;


/// horizontal scroll progress (水平滑动进度的回调)
- (HyCyclePageViewConfigure *(^)(void(^)(HyCyclePageView *, // HyCyclePageView
                                         NSInteger,        // fromPage
                                         NSInteger,       // toPage
                                         CGFloat))       // progress
                                         )horizontalScroll;

/// vertical scroll  (上下滑动的回调)
- (HyCyclePageViewConfigure *(^)(void(^)(HyCyclePageView *, // HyCyclePageView
                                         CGFloat ,         // contentOffset y
                                         NSInteger))      // currentPage
                                         )verticalScroll;

- (HyCyclePageViewConfigure *(^)(void(^)(HyCyclePageView *, // HyCyclePageView
                                         BOOL))            // state begin or end
                                         )horizontalScrollState;

/// header refresh
- (HyCyclePageViewConfigure *(^)(void(^)(HyCyclePageView *, // HyCyclePageView
                                         UIScrollView *,   // scrollView
                                         NSInteger))      // currentPage
                                         )headerRefresh;

/// footer refresh
- (HyCyclePageViewConfigure *(^)(void(^)(HyCyclePageView *, // HyCyclePageView
                                         UIScrollView *,   // scrollView
                                         NSInteger))      // currentPage
                                         )footerRefresh;

@end


@interface HyCyclePageView : UIView

/**
 create cyclePageView
 
 @param frame frame
 @param configureBlock config the params
 @return HyCyclePageView
 */
+ (instancetype)cyclePageViewWithFrame:(CGRect)frame
                        configureBlock:(void (^)(HyCyclePageViewConfigure *configure))configureBlock;


/// configure
@property (nonatomic, strong, readonly) HyCyclePageViewConfigure *configure;


/**
 scroll to next page
 
 @param animated animated
 */
- (void)scrollToNextPageWithAnimated:(BOOL)animated;


/**
 scroll to last page
 
 @param animated animated
 */
- (void)scrollToLastPageWithAnimated:(BOOL)animated;


/**
 scroll to the page
 
 @param page page
 @param animated animated
 */
- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;


/**
 reload initialize configure block
 */
- (void)reloadConfigureBlock;


/**
 changed configure with reload
 */
- (void)reloadConfigureChange;


/**
 reload headerView or hoverView
 */
- (void)reloadHeaderViewAndHoverView;


/**
 updateContentInsetTop
 
 @param top inset top
 */
- (void)updateContentInsetTop:(CGFloat)top;


/**
 updateContentOffSetY
 
 @param contentOffsetY contentOffset y
 @param flag animation
 */
- (void)updateContentOffSetY:(CGFloat)contentOffsetY
                   animation:(BOOL)flag;

@end


