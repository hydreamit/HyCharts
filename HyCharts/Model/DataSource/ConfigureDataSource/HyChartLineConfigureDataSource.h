//
//  HyChartLineConfigureDataSource.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartConfigureDataSource.h"
#import "HyChartLineConfigureDataSourceProtocol.h"
#import "HyChartLineConfigure.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartLineConfigureDataSource : HyChartConfigureDataSource<HyChartLineConfigureDataSourceProtocol>

@property (nonatomic, strong, readonly) HyChartLineConfigure *configure;

@end

NS_ASSUME_NONNULL_END
