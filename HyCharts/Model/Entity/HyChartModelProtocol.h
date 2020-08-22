//
//  HyChartModelProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


@protocol HyChartModelProtocol <NSObject>

/// X轴上显示内容
@property (nonatomic, copy) NSString *text;
/// 用来保存自己需要的额外数据
@property (nonatomic, strong) id exData;

/// 图层上x轴上的绝对位置
@property (nonatomic, assign,readonly) CGFloat position;
/// 图层上x轴上的可见相对位置
@property (nonatomic, assign,readonly) CGFloat visiblePosition;

/// 图层上数据y轴上位置
@property (nonatomic,copy, readonly) CGFloat (^valuePositon)(NSNumber *value);
/// 图层上数据y轴上高度值
@property (nonatomic,copy, readonly) CGFloat (^valueHeight)(NSNumber *value);

/// 是否为段点 默认为NO
@property (nonatomic,assign) BOOL breakingPoint;
/// 是否忽略这个点
@property (nonatomic,assign) BOOL ignorePoint;

@end

NS_ASSUME_NONNULL_END
