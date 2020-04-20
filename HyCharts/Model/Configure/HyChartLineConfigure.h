//
//  HyChartLineConfigure.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartLineConfigureProtocol.h"
#import "HyChartConfigure.h"


NS_ASSUME_NONNULL_BEGIN

@interface HyChartLineOneConfigure : NSObject<HyChartLineOneConfigureProtocol>
+ (instancetype)defaultConfigure;
@end

@interface HyChartLineConfigure : HyChartConfigure<HyChartLineConfigureProtocol>


@end

NS_ASSUME_NONNULL_END
