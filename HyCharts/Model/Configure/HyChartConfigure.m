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
@synthesize width = _width, margin = _margin, edgeInsetStart = _edgeInsetStart, edgeInsetEnd = _edgeInsetEnd, trans = _trans, scale = _scale, maxScale = _maxScale, minScale = _minScale, autoMargin = _autoMargin, renderingDirection = _renderingDirection, decimal = _decimal, minDisplayWidth = _minDisplayWidth, maxDisplayWidth = _maxDisplayWidth, displayWidth = _displayWidth, notEnoughSide = _notEnoughSide;

- (instancetype)init {
    if (self = [super init]) {
        
        self.margin = 5;
        self.width = 10;
        self.edgeInsetStart = 5;
        self.edgeInsetEnd = 5;

        self.trans = 0;
        self.scale = 1;
        self.maxScale = 5;
        self.minScale = .3;
    }
    return self;
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
