//
//  HyChartConfigure.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartConfigure.h"


@interface HyChartConfigure ()
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@end

@implementation HyChartConfigure
@synthesize width = _width, margin = _margin, edgeInsetStart = _edgeInsetStart, edgeInsetEnd = _edgeInsetEnd, trans = _trans, scale = _scale, maxScale = _maxScale, minScale = _minScale, scaleWidth = _scaleWidth, scaleMargin = _scaleMargin, scaleItemWidth = _scaleItemWidth, scaleEdgeInsetStart = _scaleEdgeInsetStart, scaleEdgeInsetEnd = _scaleEdgeInsetEnd, autoMargin = _autoMargin, dataDirection = _dataDirection, decimal = _decimal;


+ (instancetype)defaultConfigure {
    
    HyChartConfigure *configure = [[self alloc] init];
    
    configure.margin = 5;
    configure.width = 10;
    configure.edgeInsetStart = 5;
    configure.edgeInsetEnd = 5;

    configure.trans = 0;
    configure.scale = 1;
    configure.maxScale = 5;
    configure.minScale = .3;
    
    return configure;
}

- (void)setDecimal:(NSInteger)decimal {
    _decimal = decimal;
    self.numberFormatter.maximumFractionDigits = decimal;
    self.numberFormatter.minimumFractionDigits = decimal;
}

- (NSNumberFormatter *)numberFormatter {
    if (!_numberFormatter){
        _numberFormatter  = [NSNumberFormatter new];
        _numberFormatter.roundingMode = NSNumberFormatterRoundDown;
        _numberFormatter.maximumFractionDigits = 0;
        _numberFormatter.minimumFractionDigits = 0;
        _numberFormatter.minimumIntegerDigits = 1;
        _numberFormatter.groupingSeparator = @"";
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _numberFormatter.decimalSeparator = @".";;
    }
    return _numberFormatter;
}

@end
