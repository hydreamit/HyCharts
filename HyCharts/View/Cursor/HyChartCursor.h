//
//  HyChartCursor.h
//  DemoCode
//
//  Created by Hy on 2018/4/1.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HyChartCursorConfigureProtocol.h"
#import "HyChartCursorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartCursor : CALayer<HyChartCursorProtocol>

+ (instancetype)chartCursorWithLayer:(CALayer *)layer;

@property (nonatomic, strong, readonly) id<HyChartCursorConfigureProtocol> configure;

@end

NS_ASSUME_NONNULL_END
