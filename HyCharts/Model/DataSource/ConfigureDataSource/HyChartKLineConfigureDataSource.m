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
@property (nonatomic, strong) id<HyChartKLineConfigureProtocol> configure;
@end

@implementation HyChartKLineConfigureDataSource

- (id<HyChartKLineConfigureDataSourceProtocol>)configConfigure:(void (^_Nullable)(id<HyChartKLineConfigureProtocol> configure))block {
    !block ?: block(self.configure);
    return self;
}

- (id<HyChartKLineConfigureProtocol>)configure {
    if (!_configure){
        _configure = [HyChartKLineConfigure defaultConfigure];
    }
    return _configure;
}

@end
