//
//  HyChartXAxisInfo.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/20.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartXAxisInfoProtocol.h"
#import "HyChartAxisInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartXAxisInfo : HyChartAxisInfo<HyChartXAxisInfoProtocol>

@property (nonatomic, copy, readonly) id(^textAtIndexBlock)(NSInteger, id<HyChartModelProtocol>);

@end

NS_ASSUME_NONNULL_END
