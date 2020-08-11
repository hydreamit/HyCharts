//
//  HyChartXAxisModel.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import "HyChartXAxisModelProtocol.h"
#import "HyChartAxisModel.h"
#import "HyChartXAxisInfo.h"


NS_ASSUME_NONNULL_BEGIN

/// X 轴数据
@interface HyChartXAxisModel : HyChartAxisModel<HyChartXAxisModelProtocol>

@property (nonatomic, strong, readonly) HyChartXAxisInfo *topXAxisInfo;

@property (nonatomic, strong, readonly) HyChartXAxisInfo *bottomXAxisInfo;

@end

NS_ASSUME_NONNULL_END
