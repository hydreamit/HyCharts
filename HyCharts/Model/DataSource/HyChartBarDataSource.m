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
@property (nonatomic, strong) HyChartBarModelDataSource * modelDataSource;
@property (nonatomic, strong) HyChartBarConfigureDataSource *configreDataSource;
@end


@implementation HyChartBarDataSource
@synthesize modelDataSource = _modelDataSource, configreDataSource = _configreDataSource;
- (HyChartBarConfigureDataSource *)configreDataSource {
    if (!_configreDataSource){
        _configreDataSource = [[HyChartBarConfigureDataSource alloc] init];
    }
    return _configreDataSource;
}

- (HyChartBarModelDataSource *)modelDataSource {
    if (!_modelDataSource) {
        _modelDataSource = [[HyChartBarModelDataSource alloc] init];
    }
    return _modelDataSource;
}

@end
