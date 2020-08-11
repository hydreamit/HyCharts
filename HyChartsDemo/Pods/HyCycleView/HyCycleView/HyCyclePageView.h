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
#import "UIView+HyFrame.h"


typedef NS_ENUM(NSUInteger, HyCyclePageViewHeaderViewUpAnimation) {
    HyCyclePageViewHeaderViewUpAnimationNone,
    HyCyclePageViewHeaderViewUpAnimationCover
};

typedef NS_ENUM(NSUInteger, HyCyclePageViewHeaderViewDownAnimation) {
    HyCyclePageViewHeaderViewDownAnimationNone,
    HyCyclePageViewHeaderViewDownAnimationScale
};

typedef NS_ENUM(NSUInteger, HyCyclePageViewHeaderRefreshPosition) {
    HyCyclePageViewHeaderRefreshPositionTop,
    HyCyclePageViewHeaderRefreshPositionCenter
};


NS_ASSUME_NONNULL_BEGIN
@class HyCyclePageView;

/// 滚动监听协议
@protocol HyCyclePageViewScrollProgressProtocol <NSObject>
@optional
@property (nonatomic,copy,readonly) void(^hy_horizontalScrollProgress)(HyCyclePageView *cyclePageView, NSInteger fromIndex, NSInteger toIndex, CGFloat progress);
@property (nonatomic,copy,readonly) void(^hy_verticalScrollProgress)(HyCyclePageView *cyclePageView, UIView *view, NSInteger index, CGFloat offset);
@end


@protocol HyCyclePageViewProviderProtocol <NSObject>
- (void)configCyclePageView:(HyCycleViewProvider<HyCyclePageView *> *)provider index:(NSInteger)index;
@end


@interface HyCyclePageViewConfigure : HyCycleViewConfigure<HyCyclePageView *,
                                                        id<HyCyclePageViewProviderProtocol>>
/// 头部刷新位置
- (instancetype)headerRefreshPositon:(HyCyclePageViewHeaderRefreshPosition)positon;
/// 头部刷新设置
- (instancetype)headerRefreshAtIndex:(void(^)(HyCyclePageView *cyclePageView, UIScrollView *scrollView, id view, NSInteger index))block;
/// 尾部刷新设置
- (instancetype)footerRefreshAtIndex:(void(^)(HyCyclePageView *cyclePageView, UIScrollView *scrollView, id view, NSInteger index))block;

/// 头部视图
- (instancetype)headerView:(UIView *)view;
/// 头部视图高度
- (instancetype)headerViewHeight:(CGFloat)height;
/// 头部视图向上滑动动画
- (instancetype)headerViewUpAnimation:(HyCyclePageViewHeaderViewUpAnimation)animation;
/// 头部视图向下滑动动画
- (instancetype)headerViewDownAnimation:(HyCyclePageViewHeaderViewDownAnimation)animation;

/// 悬停视图
- (instancetype)hoverView:(UIView *)view;
/// 悬停视图高度
- (instancetype)hoverViewHeight:(CGFloat)height;
/// 悬停偏移量
- (instancetype)hoverViewOffset:(CGFloat)offset;

/// 垂直滑动回调
- (instancetype)verticalScrollProgress:(void(^)(HyCyclePageView *cyclePageView, UIView *view, NSInteger index, CGFloat offset))block;
@end



@interface HyCyclePageView : UIView

@property (nonatomic, strong, readonly) HyCyclePageViewConfigure *configure;

@property (nonatomic, strong, readonly) UIView *hoverView;
@property (nonatomic, strong, readonly) UIView *headerView;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, strong, readonly) NSArray<UIView *> *visibleViews;
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *visibleIndexs;
@property (nonatomic, strong, readonly) NSIndexSet *didLoadIndexs;
@property (nonatomic, copy, readonly) UIView *(^viewAtIndex)(NSInteger);


- (void)reloadData;
- (void)updateContentInsetTop:(CGFloat)top;
- (void)updateContentOffSetY:(CGFloat)contentOffsetY
                   animation:(BOOL)flag;

- (void)scrollToNextIndexWithAnimated:(BOOL)animated;
- (void)scrollToLastIndexWithAnimated:(BOOL)animated;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

@end


NS_ASSUME_NONNULL_END
