//
//  HyChartCursorProtocol.h
//  DemoCode
//
//  Created by Hy on 2018/4/8.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HyChartModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class HyChartView;
@protocol HyChartCursorProtocol <NSObject>
@required

- (void(^)(CGPoint point,
           NSString *xText,
           NSString *yText,
           id<HyChartModelProtocol> model,
           HyChartView *chartView))show;

- (void)dismiss;

- (BOOL)isShowing;

@end

NS_ASSUME_NONNULL_END
