//
//  HyChartConfigureDataSource.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartConfigureDataSource.h"
#import "HyChartConfigure.h"


@interface HyChartConfigureDataSource ()
@property (nonatomic, strong) id<HyChartConfigureProtocol> configure;
@end


@implementation HyChartConfigureDataSource

- (id<HyChartConfigureDataSourceProtocol>)configConfigure:(void (^_Nullable)(id<HyChartConfigureProtocol> configure))block {
    !block ?: block(self.configure);
    return self;
}

- (id<HyChartConfigureProtocol>)configure {
    if (!_configure){
        _configure = [HyChartConfigure defaultConfigure];
    }
    return _configure;
}

@end
