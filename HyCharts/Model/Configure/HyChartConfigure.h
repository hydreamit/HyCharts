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

+ (instancetype)defaultConfigure;

@end

NS_ASSUME_NONNULL_END
