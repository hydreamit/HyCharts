//
//  HyChartLineModelProtocol.h
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyChartLineModelProtocol <HyChartModelProtocol>

/// 支持多条线
@property (nonatomic, strong) NSArray<NSNumber *> *values;

/// 每条线的断点设置, 默认为NO  —— @(YES) \ @(NO)
@property (nonatomic, strong) NSArray<NSNumber *> *breakpoints;


@end

NS_ASSUME_NONNULL_END
