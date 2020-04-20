//
//  HyChartXAxisModelProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartAxisModelProtocol.h"
#import "HyChartXAxisInfoProtocol.h"



NS_ASSUME_NONNULL_BEGIN

@protocol HyChartXAxisModelProtocol <HyChartAxisModelProtocol>

/// 配置top X 轴信息
- (id<HyChartXAxisModelProtocol>)configTopXAxisInfo:(void(^)(id<HyChartXAxisInfoProtocol> xAxisInfo))block;

/// 配置 bottom X 轴信息
- (id<HyChartXAxisModelProtocol>)configBottomXAxisInfo:(void(^)(id<HyChartXAxisInfoProtocol> xAxisInfo))block;


@property (nonatomic, strong, readonly) id<HyChartXAxisInfoProtocol> topXAxisInfo;
@property (nonatomic, strong, readonly) id<HyChartXAxisInfoProtocol> bottomXAxisInfo;


/// 是否禁用上X轴 默认为YES
@property (nonatomic, assign) BOOL topXaxisDisabled;
/// 是否禁用下X轴 默认为NO
@property (nonatomic, assign) BOOL bottomXaxisDisabled;

@end



NS_ASSUME_NONNULL_END
