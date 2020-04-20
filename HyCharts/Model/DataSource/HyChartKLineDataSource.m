//
//  HyChartKLineDataSource.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartKLineDataSource.h"
#import "HyChartKLineConfigureDataSource.h"
#import "HyChartKLineModelDataSource.h"


@interface HyChartKLineDataSource ()
@property (nonatomic, strong) id<HyChartKLineModelDataSourceProtocol> modelDataSource;
@property (nonatomic, strong) id<HyChartKLineConfigureDataSourceProtocol> configreDataSource;
@end


@implementation HyChartKLineDataSource

- (id<HyChartKLineConfigureDataSourceProtocol>)configreDataSource {
    if (!_configreDataSource){
        _configreDataSource = [[HyChartKLineConfigureDataSource alloc] init];
    }
    return _configreDataSource;
}

- (id<HyChartKLineModelDataSourceProtocol>)modelDataSource {
    if (!_modelDataSource) {
        _modelDataSource = [[HyChartKLineModelDataSource alloc] init];
    }
    return _modelDataSource;
}

@end
