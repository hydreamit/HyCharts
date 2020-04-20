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
@property (nonatomic, strong) id<HyChartBarConfigureProtocol> configure;
@end


@implementation HyChartBarConfigureDataSource

- (id<HyChartBarConfigureDataSourceProtocol>)configConfigure:(void (^_Nullable)(id<HyChartBarConfigureProtocol> configure))block {
    !block ?: block(self.configure);
    return self;
}

- (id<HyChartBarConfigureProtocol>)configure {
    if (!_configure){
        _configure = [HyChartBarConfigure defaultConfigure];
    }
    return _configure;
}

@end
