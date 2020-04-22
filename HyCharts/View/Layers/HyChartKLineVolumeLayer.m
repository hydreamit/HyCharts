//
//  HyChartKLineVolumeLayer.m
//  DemoCode
//
//  Created by Hy on 2018/3/31.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartKLineVolumeLayer.h"
#import "HyChartsMethods.h"


@interface HyChartKLineVolumeLayer ()
@property (nonatomic, strong) CAShapeLayer *trendUpLayer;
@property (nonatomic, strong) CAShapeLayer *trendDownLayer;
@property (nonatomic, strong) NSDictionary<NSNumber *, CAShapeLayer *> *smaLayerDict;
@property (nonatomic, strong) NSDictionary<NSNumber *, CAShapeLayer *> *emaLayerDict;
@property (nonatomic, strong) NSDictionary<NSNumber *, NSArray<CAShapeLayer *> *> *bollLayerDict;
@end


@implementation HyChartKLineVolumeLayer

- (void)setNeedsRendering {
    [super setNeedsRendering];
    
    if (!self.dataSource.modelDataSource.visibleModels.count) {
        return;
    }
    
    __block CGFloat x, y, height;
    CGFloat h = CGRectGetHeight(self.bounds);
    CGFloat width = self.dataSource.configreDataSource.configure.scaleWidth;
    double maxValue = 0;
    double minValue = 0;
    if ([self.superlayer isKindOfClass:NSClassFromString(@"HyChartKLineLayer")]) {
        maxValue = self.dataSource.axisDataSource.yAxisModelWityViewType(HyChartKLineViewTypeVolume).yAxisMaxValue.doubleValue;
        minValue = self.dataSource.axisDataSource.yAxisModelWityViewType(HyChartKLineViewTypeVolume).yAxisMinValue.doubleValue;
    } else {
        maxValue = self.dataSource.axisDataSource.yAxisModel.yAxisMaxValue.doubleValue;
        minValue = self.dataSource.axisDataSource.yAxisModel.yAxisMinValue.doubleValue;
    }
    double heightRate = maxValue != 0 ? h / maxValue : 0;

    UIBezierPath *trendUpPath = UIBezierPath.bezierPath;
    UIBezierPath *trendDownPath = UIBezierPath.bezierPath;

    NSMutableDictionary<NSNumber *, UIBezierPath *> *smaPathDict = nil;
    NSMutableDictionary<NSNumber *, UIBezierPath *> *emaPathDict =nil;
    NSMutableDictionary<NSNumber *, NSArray<UIBezierPath *> *> *bollPathDict = nil;

    switch (self.technicalType) {
       case HyChartKLineTechnicalTypeNone: {

       } break;
       case HyChartKLineTechnicalTypeSMA: {
           smaPathDict = @{}.mutableCopy;
           [self.dataSource.configreDataSource.configure.smaDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
               [smaPathDict setObject:UIBezierPath.bezierPath forKey:key];
           }];
       } break;
       case HyChartKLineTechnicalTypeEMA: {
           emaPathDict = @{}.mutableCopy;
           [self.dataSource.configreDataSource.configure.emaDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
               [emaPathDict setObject:UIBezierPath.bezierPath forKey:key];
           }];
       } break;
       case HyChartKLineTechnicalTypeBOLL: {
           bollPathDict = @{}.mutableCopy;
           [self.dataSource.configreDataSource.configure.bollDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSArray<UIColor *> * _Nonnull obj, BOOL * _Nonnull stop) {
               [bollPathDict setObject:@[UIBezierPath.bezierPath, UIBezierPath.bezierPath, UIBezierPath.bezierPath]
                                forKey:key];
           }];
       } break;
       default:
       break;
    }

    NSArray<id<HyChartKLineModelProtocol>> *visibleModels = self.dataSource.modelDataSource.visibleModels;
    [visibleModels enumerateObjectsUsingBlock:^(id<HyChartKLineModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        x = obj.visiblePosition;
        height = (obj.volume.doubleValue) * heightRate;
        y = h - height;

        CGRect rect = CGRectMake(x,  y, width, height);

        if (obj.trend == HyChartKLineTrendDown) {
            [trendDownPath appendPath:[UIBezierPath bezierPathWithRect:rect]];
        } else {
            [trendUpPath appendPath:[UIBezierPath bezierPathWithRect:rect]];
        }

        if (smaPathDict) {
            [smaPathDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIBezierPath * _Nonnull path, BOOL * _Nonnull stop) {
                CGPoint cuurentPoint = CGPointMake(x + width / 2, h - ((obj.volumeSMA([key integerValue]).doubleValue - minValue) * heightRate));
                if (idx == 0) {
                    [path moveToPoint:cuurentPoint];
                } else {
                   [path addLineToPoint:cuurentPoint];
                }
            }];

        } else if (emaPathDict) {
            [emaPathDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIBezierPath * _Nonnull path, BOOL * _Nonnull stop) {
                CGPoint cuurentPoint = CGPointMake(x + width / 2, h - ((obj.volumeEMA([key integerValue]).doubleValue - minValue) * heightRate));
                if (idx == 0) {
                    [path moveToPoint:cuurentPoint];
                } else {
                   [path addLineToPoint:cuurentPoint];
                }
            }];

        } else if (bollPathDict) {
            [bollPathDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSArray<UIBezierPath *> * _Nonnull paths, BOOL * _Nonnull stop) {
                [paths enumerateObjectsUsingBlock:^(UIBezierPath * _Nonnull path, NSUInteger pathIdx, BOOL * _Nonnull stop) {

                    CGFloat value = 0;
                    NSString *bollType = @"";
                    if (pathIdx == 0) {
                        bollType = @"mb";
                    } else if (pathIdx == 1) {
                        bollType = @"up";
                    } else {
                        bollType = @"dn";
                    }
                    value = obj.volumeBoll([key integerValue], bollType).doubleValue;
                    CGPoint cuurentPoint = CGPointMake(x + width / 2, h - ((value - minValue) * heightRate));
                    if (idx == 0) {
                        [path moveToPoint:cuurentPoint];
                    } else {
                       [path addLineToPoint:cuurentPoint];
                    }
                }];
            }];
        }
    }];

    if (smaPathDict) {
        [self.smaLayerDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, CAShapeLayer * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.path = smaPathDict[key].CGPath;
        }];
    } else if (emaPathDict) {
        [self.emaLayerDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, CAShapeLayer * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.path = emaPathDict[key].CGPath;
        }];
    } else if (bollPathDict) {
        [self.bollLayerDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSArray<CAShapeLayer *> * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull layer, NSUInteger layerIdx, BOOL * _Nonnull stop) {
                layer.path = bollPathDict[key][layerIdx].CGPath;
            }];
        }];
    }

    self.trendUpLayer.path = trendUpPath.CGPath;
    self.trendDownLayer.path = trendDownPath.CGPath;
}

- (CAShapeLayer *)trendUpLayer {
    if (!_trendUpLayer){
        _trendUpLayer = [self layerWithTrend:HyChartKLineTrendUp];
    }
    return _trendUpLayer;
}

- (CAShapeLayer *)trendDownLayer {
    if (!_trendDownLayer){
        _trendDownLayer = [self layerWithTrend:HyChartKLineTrendDown];
    }
    return _trendDownLayer;
}

- (CAShapeLayer *)layerWithTrend:(HyChartKLineTrend)trend {
    
    id<HyChartKLineConfigureProtocol> configure = self.dataSource.configreDataSource.configure;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = configure.hatchWidth;
    
    layer.strokeColor = trend == HyChartKLineTrendUp ?
    configure.trendUpColor.CGColor : configure.trendDownColor.CGColor;
    
    HyChartKLineType klineType = trend == HyChartKLineTrendUp ?
    configure.trendUpKlineType : configure.trendDownKlineType;
    
    layer.fillColor = klineType == HyChartKLineTypeFill ?
    layer.strokeColor : UIColor.clearColor.CGColor;
    
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineCapRound;
    layer.masksToBounds = YES;
    layer.frame = self.bounds;
    [self addSublayer:layer];
    return layer;
}

- (NSDictionary<NSNumber *,CAShapeLayer *> *)smaLayerDict {
    if (!_smaLayerDict){
        NSMutableDictionary *mDict = @{}.mutableCopy;
        [self.dataSource.configreDataSource.configure.smaDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
            CAShapeLayer *smaLayer = [CAShapeLayer layer];
            smaLayer.strokeColor = obj.CGColor;
            smaLayer.lineWidth = self.dataSource.configreDataSource.configure.technicalLineWidth;;
            smaLayer.fillColor = UIColor.clearColor.CGColor;
            smaLayer.lineCap = kCALineCapRound;
            smaLayer.lineJoin = kCALineCapRound;
            smaLayer.masksToBounds = YES;
            smaLayer.frame = self.bounds;
            [self addSublayer:smaLayer];
            [mDict setObject:smaLayer forKey:key];
        }];
        _smaLayerDict = mDict.copy;
    }
    return _smaLayerDict;
}

- (NSDictionary<NSNumber *,CAShapeLayer *> *)emaLayerDict {
    if (!_emaLayerDict){
        NSMutableDictionary *mDict = @{}.mutableCopy;
        [self.dataSource.configreDataSource.configure.emaDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
            CAShapeLayer *emaLayer = [CAShapeLayer layer];
            emaLayer.strokeColor = obj.CGColor;
            emaLayer.lineWidth = self.dataSource.configreDataSource.configure.technicalLineWidth;;
            emaLayer.fillColor = UIColor.clearColor.CGColor;
            emaLayer.lineCap = kCALineCapRound;
            emaLayer.lineJoin = kCALineCapRound;
            emaLayer.masksToBounds = YES;
            emaLayer.frame = self.bounds;
            [self addSublayer:emaLayer];
            [mDict setObject:emaLayer forKey:key];
        }];
        _emaLayerDict = mDict.copy;
    }
    return _emaLayerDict;
}

- (NSDictionary<NSNumber *,NSArray<CAShapeLayer *> *> *)bollLayerDict {
    if (!_bollLayerDict){
        NSMutableDictionary *mDict = @{}.mutableCopy;
        [self.dataSource.configreDataSource.configure.bollDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSArray<UIColor *> * _Nonnull colors, BOOL * _Nonnull stop) {
            NSMutableArray *layers = @[].mutableCopy;
            if (colors.count == 3) {
                for (UIColor *color in colors) {
                    CAShapeLayer *bollLayer = [CAShapeLayer layer];
                    bollLayer.strokeColor = color.CGColor;
                    bollLayer.lineWidth = self.dataSource.configreDataSource.configure.technicalLineWidth;
                    bollLayer.fillColor = UIColor.clearColor.CGColor;
                    bollLayer.lineCap = kCALineCapRound;
                    bollLayer.lineJoin = kCALineCapRound;
                    bollLayer.masksToBounds = YES;
                    bollLayer.frame = self.bounds;
                    [self addSublayer:bollLayer];
                    [layers addObject:bollLayer];
                }
            }
            if (layers.count) {
                [mDict setObject:layers forKey:key];
            }
        }];
        _bollLayerDict = mDict.copy;
    }
    return _bollLayerDict;
}

- (void)setTechnicalType:(HyChartKLineTechnicalType)technicalType {

    HyChartKLineTechnicalType lastType = _technicalType;
    
    if (lastType == technicalType) {
        return;
    }
    
    switch (lastType) {
        case HyChartKLineTechnicalTypeSMA: {
            [self.smaLayerDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, CAShapeLayer * _Nonnull obj, BOOL * _Nonnull stop) {
                [obj removeFromSuperlayer];
            }];
            self.smaLayerDict = nil;
        } break;
            
        case HyChartKLineTechnicalTypeEMA: {
            [self.emaLayerDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, CAShapeLayer * _Nonnull obj, BOOL * _Nonnull stop) {
                [obj removeFromSuperlayer];
            }];
            self.emaLayerDict = nil;
        } break;
            
        case HyChartKLineTechnicalTypeBOLL: {
            [self.bollLayerDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSArray<CAShapeLayer *> * _Nonnull obj, BOOL * _Nonnull stop) {
                [obj makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
            }];
            self.bollLayerDict = nil;
        } break;
        default:
        break;
    }
    
    _technicalType = technicalType;
}

@end
