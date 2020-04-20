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
@end


@implementation HyChartKLineConfigure
@synthesize trendUpColor = _trendUpColor, trendDownColor = _trendDownColor, hatchWidth = _hatchWidth, trendUpKlineType = _trendUpKlineType, trendDownKlineType = _trendDownKlineType, smaDict = _smaDict, bollDict = _bollDict, emaDict = _emaDict, technicalLineWidth = _technicalLineWidth, macdDict = _macdDict, rsiDict = _rsiDict, kdjDict = _kdjDict, minScaleToLine = _minScaleToLine, minScaleLineColor = _minScaleLineColor, minScaleLineWidth = _minScaleLineWidth, timeLineColor = _timeLineColor, timeLineWidth = _timeLineWidth, timeLineShadeColors = _timeLineShadeColors, minScaleLineShadeColors = _minScaleLineShadeColors, priceDecimal = _priceDecimal, volumeDecimal = _volumeDecimal, disPlayNewprice = _disPlayNewprice, newpriceColor = _newpriceColor, newpriceFont = _newpriceFont, disPlayMaxMinPrice = _disPlayMaxMinPrice, maxminPriceColor = _maxminPriceColor, maxminPriceFont = _maxminPriceFont, klineViewDict = _klineViewDict;


+ (instancetype)defaultConfigure {
    
    HyChartKLineConfigure *configure = [super defaultConfigure];
    configure.trendUpColor = UIColor.redColor;
    configure.trendDownColor = UIColor.greenColor;
    configure.hatchWidth = 1.0;
    configure.technicalLineWidth = 1.0;
    configure.dataDirection = HyChartDataDirectionReverse;
    
//    configure.minScaleToLine = YES;
    configure.minScaleLineColor = UIColor.orangeColor;
    configure.minScaleLineWidth = 1;
    
    configure.timeLineColor = UIColor.blueColor;
    configure.timeLineWidth = 1;
    
    configure.disPlayNewprice = YES;
    configure.newpriceColor = UIColor.grayColor;
    configure.newpriceFont = [UIFont systemFontOfSize:12];
    
    configure.disPlayMaxMinPrice = YES;
    configure.maxminPriceColor = UIColor.grayColor;
    configure.maxminPriceFont = [UIFont systemFontOfSize:10];
    
    return configure;
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
