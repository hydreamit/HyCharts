//
//  HyChartConfigureDataSource.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartConfigureDataSourceProtocol.h"
#import "HyChartConfigure.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartConfigureDataSource : NSObject <HyChartConfigureDataSourceProtocol>

@property (nonatomic, strong, readonly) HyChartConfigure *configure;

@end

NS_ASSUME_NONNULL_END
