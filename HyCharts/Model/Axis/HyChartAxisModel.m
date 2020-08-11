//
//  HyChartAxisModel.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/20.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartAxisModel.h"
#import "HyChartAxisGridLineInfo.h"


@interface HyChartAxisModel ()
@property (nonatomic, assign) NSInteger indexs;
@property (nonatomic, strong) HyChartAxisGridLineInfo *axisGridLineInfo;
@end


@implementation HyChartAxisModel

- (instancetype)configNumberOfIndexs:(NSInteger)indexs {
    self.indexs = indexs;
    return self;
}

- (instancetype (^)(NSInteger))numberOfIndexs {
    return ^(NSInteger indexs){
        self.indexs = indexs;
        return self;
    };
}

- (instancetype)configAxisGridLineInfo:(void(^)(id<HyChartAxisGridLineInfoProtocol> axisGridLineInfo))block {
    !block ?: block(self.axisGridLineInfo);
    return self;
}

- (HyChartAxisGridLineInfo *)axisGridLineInfo {
    if (!_axisGridLineInfo){
        _axisGridLineInfo = [[HyChartAxisGridLineInfo alloc] init];
    }
    return _axisGridLineInfo;
}

@end
