//
//  HyChartXAxisModel.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartXAxisModel.h"
#import "HyChartXAxisInfo.h"


@interface HyChartXAxisModel ()
@property (nonatomic, strong) id<HyChartXAxisInfoProtocol> topXAxisInfo;
@property (nonatomic, strong) id<HyChartXAxisInfoProtocol> bottomXAxisInfo;
@end


@implementation HyChartXAxisModel
@synthesize topXaxisDisabled = _topXaxisDisabled, bottomXaxisDisabled = _bottomXaxisDisabled;

- (instancetype)init {
    if (self = [super init]) {
        _topXaxisDisabled = YES;
        _bottomXaxisDisabled = NO;
    }
    return self;
}

- (id<HyChartXAxisModelProtocol>)configTopXAxisInfo:(void(^)(id<HyChartXAxisInfoProtocol> xAxisInfo))block {
    !block ?: block(self.topXAxisInfo);
    return self;
}

- (id<HyChartXAxisModelProtocol>)configBottomXAxisInfo:(void(^)(id<HyChartXAxisInfoProtocol> xAxisInfo))block {
    !block ?: block(self.bottomXAxisInfo);
    return self;
}

- (id<HyChartXAxisInfoProtocol>)topXAxisInfo {
    if (self.topXaxisDisabled) {
        return nil;
    }
    if (!_topXAxisInfo){
        _topXAxisInfo = [[HyChartXAxisInfo alloc] init];
    }
    return _topXAxisInfo;
}

- (id<HyChartXAxisInfoProtocol>)bottomXAxisInfo {
    if (self.bottomXaxisDisabled) {
        return nil;
    }
    if (!_bottomXAxisInfo){
        _bottomXAxisInfo = [[HyChartXAxisInfo alloc] init];
    }
    return _bottomXAxisInfo;
}

@end
