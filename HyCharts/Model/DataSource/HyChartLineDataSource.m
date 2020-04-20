//
//  HyChartLineDataSource.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartLineDataSource.h"
#import "HyChartLineConfigureDataSource.h"
#import "HyChartLineModelDataSource.h"


@interface HyChartLineDataSource ()
@property (nonatomic, strong) id<HyChartLineModelDataSourceProtocol> modelDataSource;
@property (nonatomic, strong) id<HyChartLineConfigureDataSourceProtocol> configreDataSource;
@end


@implementation HyChartLineDataSource

- (id<HyChartLineConfigureDataSourceProtocol>)configreDataSource {
    if (!_configreDataSource){
        _configreDataSource = [[HyChartLineConfigureDataSource alloc] init];
    }
    return _configreDataSource;
}

- (id<HyChartLineModelDataSourceProtocol>)modelDataSource {
    if (!_modelDataSource) {
        _modelDataSource = [[HyChartLineModelDataSource alloc] init];
    }
    return _modelDataSource;
}

@end
