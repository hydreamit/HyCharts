//
//  HyChartKLineConfigureDataSource.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartKLineConfigureDataSource.h"
#import "HyChartKLineConfigure.h"

@interface HyChartKLineConfigureDataSource ()
@property (nonatomic, strong) HyChartKLineConfigure *configure;
@end

@implementation HyChartKLineConfigureDataSource
@synthesize configure = _configure;

- (HyChartKLineConfigure *)configure {
    if (!_configure){
        _configure = [[HyChartKLineConfigure alloc] init];
    }
    return _configure;
}

@end
