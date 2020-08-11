//
//  HyChartBarConfigureDataSource.m
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartBarConfigureDataSource.h"
#import "HyChartBarConfigure.h"


@interface HyChartBarConfigureDataSource ()
@property (nonatomic, strong) HyChartBarConfigure *configure;
@end


@implementation HyChartBarConfigureDataSource
@synthesize configure = _configure;

- (HyChartBarConfigure *)configure {
    if (!_configure){
        _configure = [[HyChartBarConfigure alloc] init];
    }
    return _configure;
}

@end
