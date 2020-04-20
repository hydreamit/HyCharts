//
//  HyChartBarDataSource.m
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartBarDataSource.h"
#import "HyChartBarConfigureDataSource.h"
#import "HyChartBarModelDataSource.h"


@interface HyChartBarDataSource ()
@property (nonatomic, strong) id<HyChartBarModelDataSourceProtocol> modelDataSource;
@property (nonatomic, strong) id<HyChartBarConfigureDataSourceProtocol> configreDataSource;
@end


@implementation HyChartBarDataSource

- (id<HyChartBarConfigureDataSourceProtocol>)configreDataSource {
    if (!_configreDataSource){
        _configreDataSource = [[HyChartBarConfigureDataSource alloc] init];
    }
    return _configreDataSource;
}

- (id<HyChartBarModelDataSourceProtocol>)modelDataSource {
    if (!_modelDataSource) {
        _modelDataSource = [[HyChartBarModelDataSource alloc] init];
    }
    return _modelDataSource;
}

@end
