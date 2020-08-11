//
//  HyCycleView.h
//  HyCycleView
//  https://github.com/hydreamit/HyCycleView
//
//  Created by Hy on 16/5/3.
//  Copyright © 2016年 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+HyFrame.h"

@class HyCycleView;

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, HyCycleViewLoadStyle) {
    HyCycleViewLoadStyleWillAppear,
    HyCycleViewLoadStyleDidAppear
};

typedef NS_ENUM(NSUInteger, HyCycleViewDirection) {
    HyCycleViewDirectionLeft,
    HyCycleViewDirectionRight,
    HyCycleViewDirectionTop,
    HyCycleViewDirectionBottom
};

@class HyCycleView;
@protocol HyCycleViewScrollDelegate <NSObject>
@optional
- (void)scrollViewDidScroll:(UIScrollView *)scrollView cycleView:(HyCycleView *)cycleView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView cycleView:(HyCycleView *)cycleView;
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset cycleView:(HyCycleView *)cycleView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate cycleView:(HyCycleView *)cycleView;
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView cycleView:(HyCycleView *)cycleView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView cycleView:(HyCycleView *)cycleView;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView cycleView:(HyCycleView *)cycleView;
@end


@interface HyCycleViewProvider<__covariant CycleViewType> : NSObject
/// 是否引用数据源对象(已被其他对象引用不用设)
@property (nonatomic,assign) BOOL retainProvider;
/// 视图
- (instancetype)view:(UIView *(^)(CycleViewType cycleView))block;
/// 视图即将出现回调
- (instancetype)viewWillAppear:(void(^)(CycleViewType cycleView, id view, BOOL isFirstLoad))block;
/// 视图消失完成回调
- (instancetype)viewDidDisAppear:(void(^)(CycleViewType cycleView, id view))block;
/// 点击事件回调
- (instancetype)viewClickAction:(void(^)(CycleViewType cycleView, id view))block;
@end
@protocol HyCycleViewProviderProtocol <NSObject>
- (void)configCycleView:(HyCycleViewProvider<HyCycleView *> *)provider index:(NSInteger)index;
@end


@interface HyCycleViewConfigure<__covariant CycleViewType,
                                __covariant CycleViewProviderProtocolType> : NSObject

/// 是否无限循环 默认NO
- (instancetype)isCycle:(BOOL)isCycle;
/// 是否自动轮播 默认NO
- (instancetype)isAutoCycle:(BOOL)isAutoCycle;
/// 自动轮播时间间隔
- (instancetype)interval:(NSTimeInterval)interval;
/// 数据展示方向
- (instancetype)direction:(HyCycleViewDirection)direction;
/// 页面加载时机
- (instancetype)loadStyle:(HyCycleViewLoadStyle)loadStyle;
/// 开始页
- (instancetype)startIndex:(NSInteger (^)(CycleViewType cycleView))block;
/// 总页数
- (instancetype)totalIndexs:(NSInteger (^)(CycleViewType cycleView))block;
/// 视图提供源
- (instancetype)viewProviderAtIndex:(CycleViewProviderProtocolType(^)(CycleViewType cycleView, NSInteger index))block;
/// 视图即将出现回调
- (instancetype)viewWillAppearAtIndex:(void(^)(CycleViewType cycleView, id view, NSInteger index, BOOL isFirstLoad))block;
/// 视图消失完成回调
- (instancetype)viewDidDisAppearAtIndex:(void(^)(CycleViewType cycleView, id view, NSInteger index))block;
/// 点击事件回调
- (instancetype)clickActionAtIndex:(void(^)(CycleViewType cycleView, id view, NSInteger index))block;
/// 当前页改变回调
- (instancetype)currentIndexChange:(void(^)(CycleViewType cycleView, NSInteger indexs, NSInteger index))block;
/// 四舍五入页改变回调
- (instancetype)roundingIndexChange:(void(^)(CycleViewType cycleView, NSInteger indexs, NSInteger roundingIndex))block;
/// 滚动回调
- (instancetype)scrollProgress:(void(^)(CycleViewType cycleView, NSInteger fromIndex, NSInteger toIndex, CGFloat progress))block;
// 滚动代理
- (instancetype)scrollDelegate:(id<HyCycleViewScrollDelegate>)delegate;
@end



@interface HyCycleView : UIView

@property (nonatomic, strong, readonly) HyCycleViewConfigure<HyCycleView *,
                                                          id<HyCycleViewProviderProtocol>> *configure;

@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, strong, readonly) NSArray<UIView *> *visibleViews;
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *visibleIndexs;
@property (nonatomic, strong, readonly) NSIndexSet *didLoadIndexs;
@property (nonatomic, copy, readonly) UIView *(^viewAtIndex)(NSInteger);


- (void)reloadData;

- (void)scrollToNextIndexWithAnimated:(BOOL)animated;
- (void)scrollToLastIndexWithAnimated:(BOOL)animated;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
