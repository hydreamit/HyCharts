//
//  HyChartLineConfigureDataSource.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartLineConfigureDataSource.h"
#import "HyChartLineConfigure.h"

@interface HyChartLineConfigureDataSource ()
@property (nonatomic, strong) id<HyChartLineConfigureProtocol> configure;
@end


@implementation HyChartLineConfigureDataSource

- (id<HyChartLineConfigureDataSourceProtocol>)configConfigure:(void (^_Nullable)(id<HyChartLineConfigureProtocol> configure))block {
    !block ?: block(self.configure);
    return self;
}

- (id<HyChartLineConfigureProtocol>)configure {
    if (!_configure){
        _configure = [HyChartLineConfigure defaultConfigure];
    }
    return _configure;
}

@end
