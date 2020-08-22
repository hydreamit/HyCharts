//
//  HyChartKLineConfigure.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartKLineConfigure.h"


@interface HyChartKLineConfigure ()
@property (nonatomic, strong) NSNumberFormatter *priceNunmberFormatter;
@property (nonatomic, strong) NSNumberFormatter *volumeNunmberFormatter;
@property (nonatomic, copy) void(^lineConfigureAtIndexBlock)(NSInteger, id<HyChartLineOneConfigureProtocol>);
@end


@implementation HyChartKLineConfigure
@synthesize trendUpColor = _trendUpColor, trendDownColor = _trendDownColor, trendUpKlineType = _trendUpKlineType, trendDownKlineType = _trendDownKlineType, smaDict = _smaDict, bollDict = _bollDict, emaDict = _emaDict,  macdDict = _macdDict, rsiDict = _rsiDict, kdjDict = _kdjDict, minScaleToLine = _minScaleToLine, minScaleLineColor = _minScaleLineColor, minScaleLineWidth = _minScaleLineWidth, minScaleLineShadeColors = _minScaleLineShadeColors, priceDecimal = _priceDecimal, volumeDecimal = _volumeDecimal, disPlayNewprice = _disPlayNewprice, newpriceColor = _newpriceColor, newpriceFont = _newpriceFont, disPlayMaxMinPrice = _disPlayMaxMinPrice, maxminPriceColor = _maxminPriceColor, maxminPriceFont = _maxminPriceFont, klineViewDict = _klineViewDict, lineWidth = _lineWidth, timeLineHandleTechnicalData = _timeLineHandleTechnicalData;


- (instancetype)init {
    if (self = [super init]) {
        
        self.trendUpColor = UIColor.redColor;
        self.trendDownColor = UIColor.greenColor;
        self.lineWidth = 1.0;
//        self.lineWidthCanScale=  NO;
        self.renderingDirection = HyChartRenderingDirectionReverse;
        
    //    self.minScaleToLine = YES;
        self.minScaleLineColor = UIColor.orangeColor;
        self.minScaleLineWidth = 1;
        
        self.disPlayNewprice = YES;
        self.newpriceColor = UIColor.grayColor;
        self.newpriceFont = [UIFont systemFontOfSize:12];
        
        self.disPlayMaxMinPrice = YES;
        self.maxminPriceColor = UIColor.grayColor;
        self.maxminPriceFont = [UIFont systemFontOfSize:10];
    }
    return self;
}

- (instancetype)configLineConfigureAtIndex:(void(^)(NSInteger, id<HyChartLineOneConfigureProtocol>))block {
    self.lineConfigureAtIndexBlock = [block copy];
    return self;
}

- (void)setPriceDecimal:(NSInteger)priceDecimal {
    _priceDecimal = priceDecimal;
    self.priceNunmberFormatter.maximumFractionDigits = priceDecimal;
    self.priceNunmberFormatter.minimumFractionDigits = priceDecimal;
}

- (void)setVolumeDecimal:(NSInteger)volumeDecimal {
    _volumeDecimal = volumeDecimal;
    self.volumeNunmberFormatter.maximumFractionDigits = volumeDecimal;
    self.volumeNunmberFormatter.minimumFractionDigits = volumeDecimal;
}

- (NSNumberFormatter *)priceNunmberFormatter {
    if (!_priceNunmberFormatter){
        _priceNunmberFormatter  = [NSNumberFormatter new];
        _priceNunmberFormatter.roundingMode = NSNumberFormatterRoundDown;
        _priceNunmberFormatter.maximumFractionDigits = 0;
        _priceNunmberFormatter.minimumFractionDigits = 0;
        _priceNunmberFormatter.minimumIntegerDigits = 1;
        _priceNunmberFormatter.groupingSeparator = @"";
        _priceNunmberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _priceNunmberFormatter.decimalSeparator = @".";
    }
    return _priceNunmberFormatter;
}

- (NSNumberFormatter *)volumeNunmberFormatter {
    if (!_volumeNunmberFormatter){
        _volumeNunmberFormatter  = [NSNumberFormatter new];
        _volumeNunmberFormatter.roundingMode = NSNumberFormatterRoundDown;
        _volumeNunmberFormatter.maximumFractionDigits = 0;
        _volumeNunmberFormatter.minimumFractionDigits = 0;
        _volumeNunmberFormatter.minimumIntegerDigits = 1;
        _volumeNunmberFormatter.groupingSeparator = @"";
        _volumeNunmberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _volumeNunmberFormatter.decimalSeparator = @".";;
    }
    return _volumeNunmberFormatter;
}

@end
