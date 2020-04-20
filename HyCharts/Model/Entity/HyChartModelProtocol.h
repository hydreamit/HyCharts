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
/// y 轴上的值(X轴点对应最大Y值)
@property (nonatomic, strong) NSNumber *value;

/// 总下标
@property (nonatomic, assign) NSInteger index;
/// 可见数据下标
@property (nonatomic, assign) NSInteger visibleIndex;

/// 图层上的绝对位置
@property (nonatomic, assign) CGFloat position;
/// 图层上的可见相对位置
@property (nonatomic, assign) CGFloat visiblePosition;


/// 用来保存自己需要的额外数据
@property (nonatomic, strong) id exData;


@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@end

NS_ASSUME_NONNULL_END
