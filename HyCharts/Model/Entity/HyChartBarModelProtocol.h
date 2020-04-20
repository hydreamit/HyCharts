//
//  HyChartBarModelProtocol.h
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyChartBarModelProtocol <HyChartModelProtocol>

/// 支持多条柱
@property (nonatomic, strong) NSArray<NSNumber *> *values;


@end

NS_ASSUME_NONNULL_END
