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
@property (nonatomic, strong) HyChartLineModelDataSource *modelDataSource;
@property (nonatomic, strong) HyChartLineConfigureDataSource *configreDataSource;
@end


@implementation HyChartLineDataSource
@synthesize modelDataSource = _modelDataSource, configreDataSource = _configreDataSource;

- (HyChartLineConfigureDataSource *)configreDataSource {
    if (!_configreDataSource){
        _configreDataSource = [[HyChartLineConfigureDataSource alloc] init];
    }
    return _configreDataSource;
}

- (HyChartLineModelDataSource *)modelDataSource {
    if (!_modelDataSource) {
        _modelDataSource = [[HyChartLineModelDataSource alloc] init];
    }
    return _modelDataSource;
}

@end
