//
//  HyChartDataSource.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartDataSource.h"
#import "HyChartAxisDataSource.h"


@interface HyChartDataSource ()
@property (nonatomic, strong) id<HyChartAxisDataSourceProtocol> axisDataSource;
@end


@implementation HyChartDataSource
- (id<HyChartAxisDataSourceProtocol>)axisDataSource {
    if (!_axisDataSource) {
        _axisDataSource = [[HyChartAxisDataSource alloc] init];
    }
    return _axisDataSource;
}

- (id<HyChartConfigureDataSourceProtocol>)configreDataSource {
    return nil;
}

- (id<HyChartModelDataSourceProtocol>)modelDataSource {
    return nil;
}

@end
