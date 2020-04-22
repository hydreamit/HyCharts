//
//  HyChartKLineAuxiliaryLayer.m
//  DemoCode
//
//  Created by Hy on 2018/4/1.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartKLineAuxiliaryLayer.h"
#import "HyChartsMethods.h"


@interface HyChartKLineAuxiliaryLayer ()
@property (nonatomic, strong) NSArray<CAShapeLayer *> *layers;
@end


@implementation HyChartKLineAuxiliaryLayer

- (void)setNeedsRendering {
    [super setNeedsRendering];
    
    if (!self.dataSource.modelDataSource.visibleModels.count) {
        return;
    }
    
    CGFloat height = CGRectGetHeight(self.bounds);
     CGFloat width = self.dataSource.configreDataSource.configure.scaleWidth;
    double maxValue = 0;
    double minValue = 0;
    if ([self.superlayer isKindOfClass:NSClassFromString(@"HyChartKLineLayer")]) {
        maxValue = self.dataSource.axisDataSource.yAxisModelWityViewType(HyChartKLineViewTypeAuxiliary).yAxisMaxValue.doubleValue;
        minValue = self.dataSource.axisDataSource.yAxisModelWityViewType(HyChartKLineViewTypeAuxiliary).yAxisMinValue.doubleValue;
    } else {
        maxValue = self.dataSource.axisDataSource.yAxisModel.yAxisMaxValue.doubleValue;
        minValue = self.dataSource.axisDataSource.yAxisModel.yAxisMinValue.doubleValue;
    }
    double heightRate = maxValue != minValue ? height / (maxValue - minValue) : 0;
    
    id<HyChartKLineConfigureProtocol> configure = self.dataSource.configreDataSource.configure;
    NSArray<UIBezierPath *> *paths =
    @[UIBezierPath.bezierPath, UIBezierPath.bezierPath, UIBezierPath.bezierPath, UIBezierPath.bezierPath];
     
    __block CGFloat x;
    
    void(^block)(id<HyChartKLineModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop);
    switch (self.auxiliaryType) {
        case HyChartKLineAuxiliaryTypeMACD: {
            /**
            DIF(偏离值线) = 快的指数移动平均线EMA(12) - 慢的指数移动平均线 EMA(26)
            DEM(讯号线) =  DIF的N日指数移动平均值 EMA(9 DIF)
            MACD(柱) = DIF - DEM
            */
            NSArray<NSNumber *> *macdParams = configure.macdDict.allKeys.firstObject;
            __block CGPoint difPoint = CGPointZero;
            __block CGPoint demPoint = CGPointZero;
            __block CGRect macdRect = CGRectZero;
            block = ^(id<HyChartKLineModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                x = obj.visiblePosition;
                
                difPoint = CGPointMake(x, height - ((obj.priceDIF([macdParams.firstObject integerValue], [macdParams[1] integerValue]).doubleValue - minValue) * heightRate));
                
                demPoint = CGPointMake(x, height - ((obj.priceDEM([macdParams.firstObject integerValue], [macdParams[1] integerValue], [macdParams.lastObject integerValue]).doubleValue - minValue) * heightRate));
                
                if (idx == 0) {
                    [paths.firstObject moveToPoint:difPoint];
                    [paths[1] moveToPoint:demPoint];
                } else {
                    [paths.firstObject addLineToPoint:difPoint];
                    [paths[1] addLineToPoint:demPoint];
                }

                CGFloat macdValue = obj.priceMACD([macdParams.firstObject integerValue], [macdParams[1] integerValue], [macdParams.lastObject integerValue]).doubleValue;

                if (macdValue > 0) {
                    macdRect = CGRectMake(x, height - ((macdValue - minValue) * heightRate), width, macdValue * heightRate);
                    [paths[2] appendPath: [UIBezierPath bezierPathWithRect:macdRect]];
                } else {
                    CGFloat bottomH = (- minValue) * heightRate;
                    macdRect = CGRectMake(x, height - bottomH, width, - macdValue * heightRate );
                    [paths.lastObject appendPath:[UIBezierPath bezierPathWithRect:macdRect]];
                }

            };
        } break;
        case HyChartKLineAuxiliaryTypeKDJ: {
            /**
            RSV(n)=（今日收盘价－n日内最低价）÷（n日内最高价－n日内最低价）× 100
            K(n)=（当日RSV值 + 前一日K值）÷ n
            D(n)=（当日K值 + 前一日D值）÷ n
            J = 3K－2D
            */
            NSArray<NSNumber *> *kdjParams = configure.kdjDict.allKeys.firstObject;
            __block  CGPoint kPoint = CGPointZero, dPoint = CGPointZero, jPoint = CGPointZero;
            block = ^(id<HyChartKLineModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                x = obj.visiblePosition;
                
                kPoint = CGPointMake(x, height - (obj.priceK([kdjParams.firstObject integerValue], [kdjParams[1] integerValue]).doubleValue - minValue) * heightRate);
                
                dPoint = CGPointMake(x, height - (obj.priceD([kdjParams.firstObject integerValue], [kdjParams[1] integerValue], [kdjParams.lastObject integerValue]).doubleValue - minValue) * heightRate);
                
                jPoint = CGPointMake(x, height - (obj.priceJ([kdjParams.firstObject integerValue], [kdjParams[1] integerValue], [kdjParams.lastObject integerValue]).doubleValue - minValue) * heightRate);
                                
                if (idx == 0) {
                    [paths.firstObject moveToPoint:kPoint];
                    [paths[1] moveToPoint:dPoint];
                    [paths[2] moveToPoint:jPoint];
                } else {
                    [paths.firstObject addLineToPoint:kPoint];
                    [paths[1] addLineToPoint:dPoint];
                    [paths[2] addLineToPoint:jPoint];
                }
            };
        } break;
        case HyChartKLineAuxiliaryTypeRSI: {
            /**
              A(n) n个周期中所有收盘价上涨数之和 / n    n参数：周期数    n是用户自定义参数  6,12,24
              B(n) = n个周期中所有收盘价下跌数之和 / n (取绝对值)
              RSI(n) = A(n) /(A(n) + B(n)) * 100
              RSI(N) = SMA(MAX(Close-LastClose,0) , N, 1) / SMA( ABS(Close-LastClose), N ,1) * 100
            */
            NSNumber *rsiParams = configure.rsiDict.allKeys.firstObject;
            __block  CGPoint rsiPoint = CGPointZero;
           block = ^(id<HyChartKLineModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               x = obj.visiblePosition;
               rsiPoint = CGPointMake(x, height - (obj.priceRSI([rsiParams integerValue]).doubleValue - minValue) * heightRate);
               if (idx == 0) {
                   [paths.firstObject moveToPoint:rsiPoint];
               } else {
                   [paths.firstObject addLineToPoint:rsiPoint];
               }
            };
        } break;
        default:
        break;
    }
    [self.dataSource.modelDataSource.visibleModels enumerateObjectsUsingBlock:block];
    
    NSInteger maxIndex = 0;
    switch (self.auxiliaryType) {
        case HyChartKLineAuxiliaryTypeMACD: {
            maxIndex = 4;
        } break;
        case HyChartKLineAuxiliaryTypeKDJ: {
            maxIndex = 3;
        } break;
        case HyChartKLineAuxiliaryTypeRSI: {
            maxIndex = 1;
        } break;
        default:
        break;
    }
        
    [self.layers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < maxIndex) {
            obj.path = paths[idx].CGPath;
        }
    }];
}

- (NSArray<CAShapeLayer *> *)layers {
    if (!_layers){
        CAShapeLayer *(^layer)(void) =
        ^{ return ({
            CAShapeLayer *shapLayer = [CAShapeLayer layer];
            shapLayer.frame = self.bounds;
            shapLayer.lineCap = kCALineCapRound;
            shapLayer.lineJoin = kCALineCapRound;
            shapLayer.masksToBounds = YES;
           [self addSublayer:shapLayer];
            shapLayer;
        });};
        _layers = @[layer(), layer(), layer(), layer()];
        _layers.firstObject.zPosition = 999;
        _layers[1].zPosition = 999;
        [self setAuxiliaryLayers];
    }
    return _layers;
}

- (void)setAuxiliaryType:(HyChartKLineAuxiliaryType)auxiliaryType {
    
    HyChartKLineAuxiliaryType lastType = _auxiliaryType;

    _auxiliaryType = auxiliaryType;
    
    if (!self.sublayers.count || lastType == auxiliaryType) { return; }
    [self.layers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self setAuxiliaryLayers];
}

- (void)setAuxiliaryLayers {
    
    id<HyChartKLineConfigureProtocol> configure = self.dataSource.configreDataSource.configure;
       switch (_auxiliaryType) {
           case HyChartKLineAuxiliaryTypeMACD: {
               if (configure.macdDict.allKeys.count) {
                   NSArray<UIColor *> *colors = configure.macdDict.allValues.firstObject;
                   if (colors.count == 4) {
                       for (CAShapeLayer *layer in _layers) {
                           NSInteger index = [_layers indexOfObject:layer];
                           TransactionDisableActions(^{
                               layer.path = UIBezierPath.bezierPath.CGPath;
                               layer.strokeColor = colors[index].CGColor;
                               layer.lineWidth = configure.technicalLineWidth;
                               if (index == 0 || index == 1) {
                                   layer.fillColor= UIColor.clearColor.CGColor;
                               } else {
                                   if (index == 2) {
                                       if (self.dataSource.configreDataSource.configure.trendUpKlineType == HyChartKLineTypeFill) {
                                           layer.fillColor = colors[index].CGColor;
                                       } else {
                                           layer.fillColor= UIColor.clearColor.CGColor;
                                       }
                                   } else {
                                      if (self.dataSource.configreDataSource.configure.trendDownKlineType == HyChartKLineTypeFill) {
                                           layer.fillColor = colors[index].CGColor;
                                       } else {
                                           layer.fillColor= UIColor.clearColor.CGColor;
                                       }
                                   }
                               }
                               [self addSublayer:layer];
                           });
                       }
                   }
               }
           }break;
           case HyChartKLineAuxiliaryTypeKDJ: {
               if (configure.kdjDict.allKeys.count) {
                   NSArray<UIColor *> *colors = configure.kdjDict.allValues.firstObject;
                   if (colors.count == 3) {
                       for (UIColor *color in colors) {
                           NSInteger index = [colors indexOfObject:color];
                           CAShapeLayer *layer = _layers[index];
                           TransactionDisableActions(^{
                               layer.strokeColor = color.CGColor;
                               layer.fillColor = UIColor.clearColor.CGColor;
                               layer.lineWidth = configure.technicalLineWidth;
                               layer.path = UIBezierPath.bezierPath.CGPath;
                               [self addSublayer:layer];
                           });
                       }
                   }
               }
           }break;
           case HyChartKLineAuxiliaryTypeRSI: {
               if (configure.rsiDict.allKeys.count) {
                   CAShapeLayer *layer = _layers.firstObject;
                   TransactionDisableActions(^{
                       layer.strokeColor = configure.rsiDict.allValues.firstObject.CGColor;
                       layer.fillColor = UIColor.clearColor.CGColor;
                       layer.lineWidth = configure.technicalLineWidth;
                       layer.path = UIBezierPath.bezierPath.CGPath;
                       [self addSublayer:layer];
                   });
               }
           }break;
           default:
           break;
       }
}

@end
