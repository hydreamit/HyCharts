//
//  HyChartYAxisInfoProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/20.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartAxisInfoProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyChartYAxisInfoProtocol <HyChartAxisInfoProtocol>

/// 每个坐标点对应的t内容 (NSString NSAttributedString)
- (instancetype)configTextAtIndex:(id(^)(NSInteger index, NSNumber *maxValue, NSNumber *minValue))block;

/// NSString NSAttributedString
@property (nonatomic, copy, readonly) id(^textAtIndexBlock)(NSInteger index, NSNumber *maxValue, NSNumber *minValue);

@end

NS_ASSUME_NONNULL_END
