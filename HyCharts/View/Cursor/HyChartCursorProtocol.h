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

- (void(^)(HyChartView *chartView,
           id<HyChartModelProtocol> model,
           NSString *xText,
           NSString *yText,
           CGPoint point))show;

- (void)dismiss;

- (BOOL)isShowing;

@end

NS_ASSUME_NONNULL_END
