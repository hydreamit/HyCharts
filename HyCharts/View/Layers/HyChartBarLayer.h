//
//  HyChartBarLayer.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/23.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartBarDataSourceProtocol.h"
#import "HyChartLayer.h"


NS_ASSUME_NONNULL_BEGIN

@interface HyChartBarLayer : HyChartLayer<id<HyChartBarDataSourceProtocol>>


@end

NS_ASSUME_NONNULL_END
