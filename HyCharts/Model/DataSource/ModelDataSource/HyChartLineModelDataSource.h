//
//  HyChartLineModelDataSource.h
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartModelDataSource.h"
#import "HyChartLineModelDataSourceProtocol.h"
#import "HyChartLineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartLineModelDataSource : HyChartModelDataSource<HyChartLineModel *><HyChartLineModelDataSourceProtocol>

@end

NS_ASSUME_NONNULL_END
