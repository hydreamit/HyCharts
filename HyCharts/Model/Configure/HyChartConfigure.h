//
//  HyChartConfigure.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartConfigureProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartConfigure : NSObject<HyChartConfigureProtocol>

/*
 缩放过后的数据
 */
@property (nonatomic, assign) CGFloat scaleWidth;
@property (nonatomic, assign) CGFloat scaleMargin;
@property (nonatomic, assign) CGFloat scaleItemWidth;
@property (nonatomic, assign) CGFloat scaleEdgeInsetStart;
@property (nonatomic, assign) CGFloat scaleEdgeInsetEnd;


@property (nonatomic,assign) BOOL notEnough;


@end

NS_ASSUME_NONNULL_END
