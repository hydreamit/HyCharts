//
//  HyChartAxisGridLineInfo.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/20.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartAxisGridLineInfo.h"

@implementation HyChartAxisGridLineInfo
@synthesize axisGridLineColor = _axisGridLineColor, axisGridLineWidth = _axisGridLineWidth, axisGridLineDashPhase = _axisGridLineDashPhase, axisGridLineDashPattern = _axisGridLineDashPattern, axisGridLineType = _axisGridLineType;

- (instancetype)init{
    if (self = [super init]) {
        _axisGridLineColor = [UIColor groupTableViewBackgroundColor];
        _axisGridLineWidth = .5;
    }return self;
}


@end
