//
//  HyChartKLineConfigure.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartConfigure.h"
#import "HyChartKLineConfigureProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface HyChartKLineConfigure : HyChartConfigure<HyChartKLineConfigureProtocol>

@property (nonatomic, copy, readonly) void(^lineConfigureAtIndexBlock)(NSInteger, id<HyChartLineOneConfigureProtocol>);

@end

NS_ASSUME_NONNULL_END
