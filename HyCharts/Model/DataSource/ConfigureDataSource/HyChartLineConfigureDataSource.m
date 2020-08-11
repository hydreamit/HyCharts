//
//  HyChartLineConfigureDataSource.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartLineConfigureDataSource.h"
#import "HyChartConfigureDataSource.h"
#import "HyChartLineConfigure.h"

@interface HyChartLineConfigureDataSource ()
@property (nonatomic, strong) HyChartLineConfigure *configure;
@end


@implementation HyChartLineConfigureDataSource
@synthesize configure = _configure;

- (HyChartLineConfigure *)configure {
    if (!_configure){
        _configure = [[HyChartLineConfigure alloc] init];
    }
    return _configure;
}

@end
