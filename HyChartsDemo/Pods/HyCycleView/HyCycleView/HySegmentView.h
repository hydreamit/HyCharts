//
//  HySegmentView.h
//  HyCycleView
//  https://github.com/hydreamit/HyCycleView
//
//  Created by Hy on 2016/5/22.
//  Copyright © 2016年 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, HySegmentViewItemPosition) {
    HySegmentViewItemPositionLeft,
    HySegmentViewItemPositionCenter,
    HySegmentViewItemPositionRight
};


@class HySegmentView;
@interface HySegmentViewConfigure : NSObject

- (NSInteger)getCurrentIndex;
- (UIEdgeInsets)getInset;
- (CGFloat)getItemMargin;

/// 内边距
@property (nonatomic, copy, readonly) HySegmentViewConfigure *(^inset)(UIEdgeInsets);
/// 左右边距和中间间隔的比例
@property (nonatomic, copy, readonly) HySegmentViewConfigure *(^insetAndMarginRatio)(CGFloat);
/// 标签间距 默认是平均分配, 不够分默认值30
@property (nonatomic, copy, readonly) HySegmentViewConfigure *(^itemMargin)(CGFloat);
/// 是否保持margin/inset不变(外部自定义itemView变化时)
@property (nonatomic, copy, readonly) HySegmentViewConfigure *(^keepingMarginAndInset)(BOOL);
/// 开始选中的标签数
@property (nonatomic, copy, readonly) HySegmentViewConfigure *(^startIndex)(NSInteger);
/// 标签总数
@property (nonatomic, copy, readonly) HySegmentViewConfigure *(^numberOfItems)(NSInteger);
/// 点击回调 返回YES内部实现点击动画逻辑, NO外部自己通过调用方法clickItemFromIndex:实现
@property (nonatomic, copy, readonly) HySegmentViewConfigure *(^clickItemAtIndex)(BOOL(^)(NSInteger index, BOOL isRepeat));
/// 每个标签 对应的视图
@property (nonatomic, copy, readonly) HySegmentViewConfigure *(^viewForItemAtIndex)(UIView *(^)(UIView *currentView, NSInteger index, CGFloat progress, HySegmentViewItemPosition position, NSArray<UIView *> *animationViews));
/// 动画视图
@property (nonatomic, copy, readonly) HySegmentViewConfigure *(^animationViews)(NSArray<UIView *> *(^)(NSArray<UIView *> *currentAnimationViews, UICollectionViewCell *fromCell, UICollectionViewCell *toCell, NSInteger fromIndex, NSInteger toIndex, CGFloat progress));
@end


@interface HySegmentView : UIView

+ (instancetype)segmentViewWithFrame:(CGRect)frame
                      configureBlock:(void (^)(HySegmentViewConfigure *configure))configureBlock;

@property (nonatomic,strong,readonly) HySegmentViewConfigure *configure;

- (void)clickItemAtIndex:(NSInteger)index;
- (void)clickItemFromIndex:(NSInteger)fromIndex
                   toIndex:(NSInteger)toIndex
                  progress:(CGFloat)progress;

- (void)reloadData;

@end


