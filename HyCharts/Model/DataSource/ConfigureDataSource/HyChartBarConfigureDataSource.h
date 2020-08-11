//
//  HyChartBarConfigureDataSource.h
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartConfigureDataSource.h"
#import "HyChartBarConfigureDataSourceProtocol.h"
#import "HyChartBarConfigure.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartBarConfigureDataSource : HyChartConfigureDataSource<HyChartBarConfigureDataSourceProtocol>

@property (nonatomic, strong, readonly) HyChartBarConfigure *configure;

@end

NS_ASSUME_NONNULL_END
