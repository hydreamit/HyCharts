//
//  HyChartKLineDataSource.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartKLineDataSource.h"

@interface HyChartKLineDataSource ()
@property (nonatomic, strong) HyChartKLineModelDataSource *modelDataSource;
@property (nonatomic, strong) HyChartKLineConfigureDataSource *configreDataSource;
@end


@implementation HyChartKLineDataSource
@synthesize modelDataSource = _modelDataSource, configreDataSource = _configreDataSource;

- (HyChartKLineConfigureDataSource *)configreDataSource {
    if (!_configreDataSource){
        _configreDataSource = [[HyChartKLineConfigureDataSource alloc] init];
    }
    return _configreDataSource;
}

- (HyChartKLineModelDataSource *)modelDataSource {
    if (!_modelDataSource) {
        _modelDataSource = [[HyChartKLineModelDataSource alloc] init];
    }
    return _modelDataSource;
}

@end
