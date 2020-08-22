//
//  HyChartBarModelDataSource.h
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartModelDataSource.h"
#import "HyChartBarModelDataSourceProtocol.h"
#import "HyChartBarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartBarModelDataSource : HyChartModelDataSource<HyChartBarModel *><HyChartBarModelDataSourceProtocol>

@property (nonatomic, strong) NSArray<NSNumber *> *visibleVaxVlaues;
@property (nonatomic, strong) NSArray<NSNumber *> *visibleMinVlaues;

@end

NS_ASSUME_NONNULL_END
