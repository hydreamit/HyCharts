//
//  HyChartYAxisInfo.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/20.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartYAxisInfoProtocol.h"
#import "HyChartAxisInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartYAxisInfo : HyChartAxisInfo<HyChartYAxisInfoProtocol>

@property (nonatomic, copy, readonly) id(^textAtIndexBlock)(NSInteger index, NSNumber *maxValue, NSNumber *minValue);

@end

NS_ASSUME_NONNULL_END
