//
//  HyChartLineConfigure.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartLineConfigure.h"


@implementation HyChartLineOneConfigure
@synthesize lineWidth = _lineWidth, lineType = _lineType, linePointStrokeColor = _linePointStrokeColor, linePointFillColor = _linePointFillColor,linePointType = _linePointType, linePointSize = _linePointSize, shadeColors = _shadeColors, linePointWidth = _linePointWidth, lineColor = _lineColor, lineDashPhase = _lineDashPhase, lineDashPattern = _lineDashPattern, disPlayNewvalue = _disPlayNewvalue, newvalueFont = _newvalueFont, newvalueColor = _newvalueColor, disPlayMaxMinValue = _disPlayMaxMinValue, maxminValueColor = _maxminValueColor, maxminValueFont = _maxminValueFont;

+ (instancetype)defaultConfigure {
    HyChartLineOneConfigure *configure = [[self alloc] init];
    configure.lineWidth = 1.0;
    configure.linePointWidth = 1.0;
    configure.linePointSize = CGSizeMake(10, 10);
    configure.lineColor = UIColor.orangeColor;
    
    configure.disPlayNewvalue = NO;
    configure.newvalueColor = UIColor.grayColor;
    configure.newvalueFont = [UIFont systemFontOfSize:12];
    
    configure.disPlayMaxMinValue = NO;
    configure.maxminValueColor = UIColor.grayColor;
    configure.maxminValueFont = [UIFont systemFontOfSize:10];
    
    return configure;
}

- (UIColor *)linePointStrokeColor {
    return _linePointStrokeColor ?: self.lineColor;
}

@end


@interface HyChartLineConfigure()
@property (nonatomic, copy) void(^lineConfigureAtIndexBlock)(NSInteger, id<HyChartLineOneConfigureProtocol>);
@end

@implementation HyChartLineConfigure

- (instancetype)configLineConfigureAtIndex:(void(^)(NSInteger, id<HyChartLineOneConfigureProtocol>))block {
    self.lineConfigureAtIndexBlock = [block copy];
    return self;
}

@end
