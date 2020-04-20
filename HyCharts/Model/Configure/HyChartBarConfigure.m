//
//  HyChartBarConfigure.m
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartBarConfigure.h"

@implementation HyChartBarOneConfigure
@synthesize strokeColor = _strokeColor, fillColor = _fillColor, lineDashPhase = _lineDashPhase, lineDashPattern = _lineDashPattern, lineWidth = _lineWidth;

+ (instancetype)defaultConfigure {
    HyChartBarOneConfigure *configure = [[self alloc] init];
    configure.lineWidth = 1.0;
    return configure;
}

- (UIColor *)fillColor {
    return _fillColor ?: self.strokeColor;
}
@end


@interface HyChartBarConfigure()
@property (nonatomic, copy) void(^barConfigureAtIndexBlock)(NSInteger, id<HyChartBarOneConfigureProtocol>);
@end

@implementation HyChartBarConfigure
- (instancetype)configBarConfigureAtIndex:(void(^)(NSInteger, id<HyChartBarOneConfigureProtocol>))block {
    self.barConfigureAtIndexBlock = [block copy];
    return self;
}

@end

