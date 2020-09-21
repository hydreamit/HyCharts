//
//  HyChartViewProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartDataSourceProtocol.h"
#import "HyChartCursorProtocol.h"
#import "HyChartCursorConfigureProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@class HyChartView;
@protocol HyChartViewProtocol <NSObject>


/// 是否禁用点击手势
@property (nonatomic, assign) BOOL tapGestureDisabled;
/// 是否禁用长按手势
@property (nonatomic, assign) BOOL longPressGestureDisabled;
/// 是否禁用缩放手势
@property (nonatomic, assign) BOOL pinchGestureDisabled;


/// 点击手势事件
@property (nonatomic, copy) void(^tapGestureAction)(HyChartView *chartView, id<HyChartModelProtocol> model, NSUInteger index, CGPoint point);
/// 长按手势事件
@property (nonatomic, copy) void(^longGestureAction)(HyChartView *chartView, id<HyChartModelProtocol> model, NSUInteger index, CGPoint point, UIGestureRecognizerState state);
/// 缩放手势事件
@property (nonatomic, copy) void(^pinchGestureAction)(HyChartView *chartView, id<HyChartModelProtocol> model, NSUInteger index, CGFloat scale, UIGestureRecognizerState state);
/// 滚动事件 (分页加载数据)
@property (nonatomic, copy) void(^scrollAction)(CGFloat contentOffset, CGFloat chartWidth, CGFloat chartContentWidth);


/// 弹性属性
@property (nonatomic, assign) BOOL bounces;
/// 内边距
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
/// 图表宽度
@property (nonatomic, assign, readonly) CGFloat chartWidth;
/// 图表内容宽度
@property (nonatomic, assign, readonly) CGFloat chartContentWidth;
/// 缩放手势生效位置，默认手势点有内容才能缩放
@property (nonatomic,assign) HyChartPinchValidPosition pinchValidPosition;



/// 配置默认游标参数
- (void)configChartCursor:(void(^)(id<HyChartCursorConfigureProtocol> configure))block;
/// 自定义游标
- (void)resetChartCursor:(id<HyChartCursorProtocol>_Nullable)cursor;
/// 游标
@property (nonatomic, strong, readonly, nullable) id<HyChartCursorProtocol> chartCursor;
/// 游标状态
@property (nonatomic, copy) void(^chartCursorState)(HyChartCursorState state);


/// 数据整体渲染
- (void)setNeedsRendering;
/// 数据整体渲染及完成回调
- (void)setNeedsRenderingWithCompletion:(void(^ _Nullable)(void))completion;
/// 实时刷新最新价 或 添加/删除最前面数据 
- (void)refreshChartsView;


/// 滚动
- (void(^)(CGPoint contentOffset, BOOL animated))scroll;
/// 缩放  (index : 缩放第几个,  margin : 缩放的相对位置, scale : 缩放大小)
- (void(^)(NSInteger index, CGFloat margin, CGFloat scale))pinch;


/// 添加联动图表
+ (void(^)(NSArray<HyChartView *> *chartViews))addReactChains;
/// 删除联动图表
+ (void(^)(NSArray<HyChartView *> *chartViews))removeReactChains;


@end

NS_ASSUME_NONNULL_END
