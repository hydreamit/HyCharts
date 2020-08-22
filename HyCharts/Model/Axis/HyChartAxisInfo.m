//
//  HyChartAxisInfo.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartAxisInfo.h"

@implementation HyChartAxisInfo

@synthesize axisTextFont = _axisTextFont, axisTextColor = _axisTextColor, axisTextOffset = _axisTextOffset, axisLineColor = _axisLineColor, axisLineWidth = _axisLineWidth, axisLineType = _axisLineType, axisTextPosition = _axisTextPosition, axisLineDashPhase = _axisLineDashPhase, axisLineDashPattern = _axisLineDashPattern, rotateAngle = _rotateAngle, autoSetText = _autoSetText, displayAxisZeroText = _displayAxisZeroText;

- (instancetype)init{
    if (self = [super init]) {
        _axisTextFont = [UIFont systemFontOfSize:12];
        _axisTextColor = [UIColor grayColor];
        _axisTextOffset = CGPointZero;
        _axisLineColor = [UIColor grayColor];
        _axisLineWidth = .5;
        _axisLineDashPhase = 0;
        _axisLineDashPattern = @[@10, @5];
        _autoSetText = YES;
        _displayAxisZeroText = YES;
    }return self;
}

@end
