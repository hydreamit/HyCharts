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
@property (nonatomic, copy) void(^tapGestureAction)(void);
/// 长按手势事件
@property (nonatomic, copy) void(^longGestureAction)(void);
/// 内边距
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;


/// 配置默认游标参数
- (void)configChartCursor:(void(^)(id<HyChartCursorConfigureProtocol> configure))block;
/// 自定义游标
- (void)resetChartCursor:(id<HyChartCursorProtocol>_Nullable)cursor;


/// 渲染
- (void)setNeedsRendering;


/// 滚动事件
- (void(^)(CGPoint contentOffset, BOOL animated))scrollAction;
/// 缩放  index : 缩放第几个,  margin : 缩放的相对位置, scale : 缩放大小
- (void(^)(NSInteger index, CGFloat margin, CGFloat scale))pinchAction;


/// 添加联动图表
+ (void(^)(NSArray<HyChartView *> *chartViews))addReactChains;
/// 删除联动图表
+ (void(^)(NSArray<HyChartView *> *chartViews))removeReactChains;



@end

NS_ASSUME_NONNULL_END
