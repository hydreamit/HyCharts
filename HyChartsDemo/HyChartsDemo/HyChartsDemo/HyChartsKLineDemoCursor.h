//
//  HyChartsKLineDemoCursor.h
//  HyChartsDemo
//
//  Created by huangyi on 2020/4/20.
//  Copyright © 2020 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyCharts.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartsKLineDemoCursor : NSObject<HyChartCursorProtocol>

@property (nonatomic,weak) UIView *showView;

@end

NS_ASSUME_NONNULL_END
