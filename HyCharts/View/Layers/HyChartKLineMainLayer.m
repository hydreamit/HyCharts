//
//  HyChartKLineMainLayer.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartKLineMainLayer.h"
#import <CoreText/CoreText.h>
#import "HyChartsMethods.h"
#import "HyChartLineLayer.h"


@interface HyChartKLineMainLayer ()
@property (nonatomic, strong) CAShapeLayer *newpriceLayer;
@property (nonatomic, strong) CATextLayer *newpriceTextLayer;
@property (nonatomic, strong) CATextLayer *maxPriceTextLayer;
@property (nonatomic, strong) CATextLayer *minPriceTextLayer;
@property (nonatomic, strong) CAShapeLayer *trendUpLayer;
@property (nonatomic, strong) CAShapeLayer *trendDownLayer;
@property (nonatomic,strong) HyChartLineLayer *timeLineLayer;
@property (nonatomic, strong) CAShapeLayer *minScaleLineLayer;
@property (nonatomic, strong) CAGradientLayer *minScaleLineShadeLayer;
@property (nonatomic, strong) NSDictionary<NSNumber *, CAShapeLayer *> *smaLayerDict;
@property (nonatomic, strong) NSDictionary<NSNumber *, CAShapeLayer *> *emaLayerDict;
@property (nonatomic, strong) NSDictionary<NSNumber *, NSArray<CAShapeLayer *> *> *bollLayerDict;
@end


@implementation HyChartKLineMainLayer

- (void)setNeedsRendering {
    [super setNeedsRendering];
    
    if (!self.dataSource.modelDataSource.visibleModels.count) {
        return;
    }

    [self handleDisPlayLayer];
    
    if (self.timeLine) {
        [self.timeLineLayer setNeedsRendering];
        return;
    }
        
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat left = CGRectGetMinX(self.bounds);
    CGFloat bottom = CGRectGetMaxY(self.bounds);
    
    double maxValue = 0;
    double minValue = 0;
    if ([self.superlayer isKindOfClass:NSClassFromString(@"HyChartKLineLayer")]) {
        maxValue = self.dataSource.axisDataSource.yAxisModelWityViewType(HyChartKLineViewTypeMain).yAxisMaxValue.doubleValue;
        minValue = self.dataSource.axisDataSource.yAxisModelWityViewType(HyChartKLineViewTypeMain).yAxisMinValue.doubleValue;
    } else {
        maxValue = self.dataSource.axisDataSource.yAxisModel.yAxisMaxValue.doubleValue;
        minValue = self.dataSource.axisDataSource.yAxisModel.yAxisMinValue.doubleValue;
    }
    double heightRate = maxValue != minValue ? height / (maxValue - minValue) : 0;
    NSArray<id<HyChartKLineModelProtocol>> *visibleModels = self.dataSource.modelDataSource.visibleModels;
    

    __block CGPoint maxPriceP = CGPointZero;
    __block CGPoint minPriceP = CGPointZero;

    BOOL minScaleToLine =
    self.dataSource.configreDataSource.configure.minScaleToLine &&
    self.dataSource.configreDataSource.configure.scale < self.dataSource.configreDataSource.configure.minScale + 0.1;
    
   if (minScaleToLine) {
      
        __block CGFloat maxV = -MAXFLOAT;
        __block CGFloat minV = MAXFLOAT;
        __block CGPoint shadeStartP = CGPointZero;
        __block CGPoint shadeEndP = CGPointZero;
        UIBezierPath *path = UIBezierPath.bezierPath;
        [visibleModels enumerateObjectsUsingBlock:^(id<HyChartKLineModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            CGPoint point = CGPointMake(obj.visiblePosition + self.dataSource.configreDataSource.configure.scaleWidth / 2, height - (obj.closePrice.doubleValue - minValue) * heightRate);

            if (obj.closePrice.doubleValue > maxV) {
              maxV = obj.closePrice.doubleValue;
              maxPriceP = point;
            }
            if (obj.closePrice.doubleValue < minV) {
              minV = obj.closePrice.doubleValue;
              minPriceP = point;
            }

            if (idx == 0) {
              shadeStartP = point;
              [path moveToPoint:point];
            }
            if (idx == visibleModels.count - 1) {
              shadeEndP = point;
            }
            [path addLineToPoint:point];
        }];
      
        CAShapeLayer *currentLayer =  self.minScaleLineLayer;
        currentLayer.path = path.CGPath;

        CAGradientLayer *currentShadeLayer = self.minScaleLineShadeLayer;
        if (currentShadeLayer) {
          UIBezierPath *shadePath = [UIBezierPath bezierPathWithCGPath:path.CGPath];
          [shadePath addLineToPoint:CGPointMake(shadeEndP.x, bottom)];
          [shadePath addLineToPoint:CGPointMake(shadeStartP.x, bottom)];
          ((CAShapeLayer *)(currentShadeLayer.mask)).path = shadePath.CGPath;
        }
      
    } else {

        // 上影线
        __block CGPoint highHatchPointTop , highHatchPointBottom;
        // 下影线
        __block CGPoint lowHatchPointTop , lowHatchPointBottom;
        // 实体
        __block CGFloat entityX, entityY, entityHeight, entityWidth = self.dataSource.configreDataSource.configure.scaleWidth;

        UIBezierPath *upPath = UIBezierPath.bezierPath;
        UIBezierPath *downPath = UIBezierPath.bezierPath;
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

        NSInteger visibleMaxIndex = [visibleModels indexOfObject:self.dataSource.modelDataSource.visibleMaxPriceModel];
        NSInteger visibleMinIndex = [visibleModels indexOfObject:self.dataSource.modelDataSource.visibleMinPriceModel];
        [visibleModels enumerateObjectsUsingBlock:^(id<HyChartKLineModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

          entityX = obj.visiblePosition;
          entityHeight = fabs(obj.openPrice.doubleValue - obj.closePrice.doubleValue) * heightRate;

          CALayer *currentLayer;
          UIBezierPath *currentPath;

          switch (obj.trend) {
              case HyChartKLineTrendUp:
              case HyChartKLineTrendEqual: {
                  currentPath = upPath;
                  currentLayer = self.trendUpLayer;
                  entityY = height - (obj.closePrice.doubleValue - minValue) * heightRate;
              } break;
              case HyChartKLineTrendDown: {
                  currentPath = downPath;
                  currentLayer = self.trendDownLayer;
                  entityY = height - (obj.openPrice.doubleValue - minValue) * heightRate;
              } break;
              default:
              break;
          }

          CGRect entityRect = CGRectMake(entityX, entityY, entityWidth, entityHeight);
          highHatchPointTop = CGPointMake(entityX + entityWidth / 2, height - (obj.highPrice.doubleValue - minValue) * heightRate);
          highHatchPointBottom = CGPointMake(entityX + entityWidth / 2, entityY);
          lowHatchPointTop = CGPointMake(entityX + entityWidth / 2, CGRectGetMaxY(entityRect));
          lowHatchPointBottom = CGPointMake(entityX + entityWidth / 2, height - (obj.lowPrice.doubleValue - minValue) * heightRate);
          
          if (idx == visibleMaxIndex) {
              maxPriceP = highHatchPointTop;
          }
          
          if (idx == visibleMinIndex) {
              minPriceP = lowHatchPointBottom;
          }
          
          [currentPath moveToPoint:highHatchPointTop];
          [currentPath addLineToPoint:highHatchPointBottom];
          [currentPath appendPath:[UIBezierPath bezierPathWithRect:entityRect]];
          [currentPath moveToPoint:lowHatchPointTop];
          [currentPath addLineToPoint:lowHatchPointBottom];

          if (smaPathDict) {
              [smaPathDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIBezierPath * _Nonnull path, BOOL * _Nonnull stop) {
                  CGPoint cuurentPoint = CGPointMake(entityX + entityWidth / 2, height - ((obj.priceSMA([key integerValue]).doubleValue - minValue) * heightRate));
                  if (idx == 0) {
                      [path moveToPoint:cuurentPoint];
                  } else {
                     [path addLineToPoint:cuurentPoint];
                  }
              }];
              
          } else if (emaPathDict) {
              [emaPathDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIBezierPath * _Nonnull path, BOOL * _Nonnull stop) {
                  CGPoint cuurentPoint = CGPointMake(entityX + entityWidth / 2, height - ((obj.priceEMA([key integerValue]).doubleValue - minValue) * heightRate));
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
                      
                      value = obj.priceBoll([key integerValue], bollType).doubleValue;
                      CGPoint cuurentPoint = CGPointMake(entityX + entityWidth / 2, height - ((value - minValue) * heightRate));
                      if (idx == 0) {
                          [path moveToPoint:cuurentPoint];
                      } else {
                         [path addLineToPoint:cuurentPoint];
                      }
                  }];
              }];
          }
    }];
        
//     if (self.dataSource.configreDataSource.configure.lineWidthCanScale) {
//        CGFloat scale = self.dataSource.configreDataSource.configure.scale;
//        if (scale > 1) {
//            scale = 1;
//        }
//        CGFloat lineWidth = self.dataSource.configreDataSource.configure.lineWidth * scale;
//        self.trendUpLayer.lineWidth = lineWidth;
//        self.trendDownLayer.lineWidth = lineWidth;
//     }

      self.trendUpLayer.path = upPath.CGPath;
      self.trendDownLayer.path = downPath.CGPath;

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
    }
    
    CGRect newPriceTextRect = CGRectZero;
    NSString *newPriceString = @"";
    UIBezierPath *newPricePath = UIBezierPath.bezierPath;
    CGFloat changef = self.dataSource.modelDataSource.models.firstObject.closePrice.doubleValue - minValue;
    if (self.dataSource.configreDataSource.configure.disPlayNewprice &&
        self.dataSource.modelDataSource.models.firstObject.closePrice.doubleValue < maxValue &&
        changef > 0) {
        
        CGFloat y = height - changef * heightRate;
        newPriceString = SafetyString([self.dataSource.modelDataSource.priceNunmberFormatter stringFromNumber:self.dataSource.modelDataSource.models.firstObject.closePrice]);
     
        CGSize xSize = [newPriceString sizeWithAttributes:@{NSFontAttributeName : self.dataSource.configreDataSource.configure.newpriceFont}];
        xSize = CGSizeMake(xSize.width + 6, xSize.height);
        newPriceTextRect =  CGRectMake(left , y - xSize.height / 2 , xSize.width, xSize.height);
     
        [newPricePath moveToPoint:CGPointMake(CGRectGetMaxX(newPriceTextRect), y)];
        [newPricePath addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), y)];
    }
    
    NSString *maxString = @"";
    NSString *mixString = @"";
    CGRect minRect = CGRectZero;
    CGRect maxRect = CGRectZero;
    if (self.dataSource.configreDataSource.configure.disPlayMaxMinPrice) {
        
        id<HyChartKLineModelProtocol> maxPriceModel = self.dataSource.modelDataSource.visibleMaxPriceModel;
        NSString *highPrice = [self.dataSource.modelDataSource.priceNunmberFormatter stringFromNumber:maxPriceModel.highPrice];
         maxString = [NSString stringWithFormat:@"↙ %@", SafetyString(highPrice)];
        CGSize maxSize = [maxString sizeWithAttributes:@{NSFontAttributeName : self.dataSource.configreDataSource.configure.maxminPriceFont}];
        maxRect = CGRectMake(maxPriceP.x, maxPriceP.y - maxSize.height , maxSize.width, maxSize.height);
        if (CGRectGetMaxX(maxRect) > width) {
            maxRect.origin.x = maxPriceP.x - maxSize.width;
            maxString = [NSString stringWithFormat:@"%@ ↘", SafetyString(highPrice)];
        }
        
        id<HyChartKLineModelProtocol> minPriceModel = self.dataSource.modelDataSource.visibleMinPriceModel;
         NSString *lowPrice = [self.dataSource.modelDataSource.priceNunmberFormatter stringFromNumber:minPriceModel.lowPrice];
         mixString = [NSString stringWithFormat:@"↖ %@", SafetyString(lowPrice)];
         CGSize minSize = [mixString sizeWithAttributes:@{NSFontAttributeName : self.dataSource.configreDataSource.configure.maxminPriceFont}];
         minRect = CGRectMake(minPriceP.x, minPriceP.y , minSize.width, minSize.height);
         if (CGRectGetMaxX(minRect) > width) {
             minRect.origin.x = minPriceP.x - minSize.width;
             mixString = [NSString stringWithFormat:@"%@ ↗", SafetyString(lowPrice)];
         }
    }

    TransactionDisableActions(^{
        self.newpriceTextLayer.frame = newPriceTextRect;
        self.newpriceTextLayer.string = newPriceString;
        self.newpriceLayer.path = newPricePath.CGPath;
        self.minPriceTextLayer.string = mixString;
        self.maxPriceTextLayer.string = maxString;
        self.maxPriceTextLayer.frame = maxRect;
        self.minPriceTextLayer.frame = minRect;
    });
}

- (void)renderingNewprice {
    
    if (!self.dataSource.configreDataSource.configure.disPlayNewprice) {
        self.newpriceTextLayer.frame = CGRectZero;
        self.newpriceTextLayer.string = @"";
        return;
    }
    
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat left = CGRectGetMinX(self.bounds);
    
    double maxValue = 0;
    double minValue = 0;
    if ([self.superlayer isKindOfClass:NSClassFromString(@"HyChartKLineLayer")]) {
        maxValue = self.dataSource.axisDataSource.yAxisModelWityViewType(HyChartKLineViewTypeMain).yAxisMaxValue.doubleValue;
        minValue = self.dataSource.axisDataSource.yAxisModelWityViewType(HyChartKLineViewTypeMain).yAxisMinValue.doubleValue;
    } else {
        maxValue = self.dataSource.axisDataSource.yAxisModel.yAxisMaxValue.doubleValue;
        minValue = self.dataSource.axisDataSource.yAxisModel.yAxisMinValue.doubleValue;
    }
    double heightRate = maxValue != minValue ? height / (maxValue - minValue) : 0;

    CGRect newPriceTextRect = CGRectZero;
    NSString *newPriceString = @"";
    UIBezierPath *newPricePath = UIBezierPath.bezierPath;
    CGFloat changef = self.dataSource.modelDataSource.models.firstObject.closePrice.doubleValue - minValue;
    if (self.dataSource.modelDataSource.models.firstObject.closePrice.doubleValue < maxValue &&
        changef > 0) {
        
        CGFloat y = height - changef * heightRate;
        newPriceString = SafetyString([self.dataSource.modelDataSource.priceNunmberFormatter stringFromNumber:self.dataSource.modelDataSource.models.firstObject.closePrice]);
     
        CGSize xSize = [newPriceString sizeWithAttributes:@{NSFontAttributeName : self.dataSource.configreDataSource.configure.newpriceFont}];
        xSize = CGSizeMake(xSize.width + 6, xSize.height);
        newPriceTextRect =  CGRectMake(left , y - xSize.height / 2 , xSize.width, xSize.height);
     
        [newPricePath moveToPoint:CGPointMake(CGRectGetMaxX(newPriceTextRect), y)];
        [newPricePath addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), y)];
    }
    
    TransactionDisableActions(^{
        self.newpriceTextLayer.frame = newPriceTextRect;
        self.newpriceTextLayer.string = newPriceString;
        self.newpriceLayer.path = newPricePath.CGPath;
    });
}


- (void)handleDisPlayLayer {
    
    BOOL flag = YES;
    if (self.timeLine) {
        
        self.timeLineLayer.hidden = NO;
        self.minScaleLineLayer.hidden = YES;
        self.minScaleLineShadeLayer.hidden = YES;
        self.newpriceTextLayer.hidden = YES;
        self.minPriceTextLayer.hidden = YES;
        self.maxPriceTextLayer.hidden = YES;
        self.newpriceLayer.hidden = YES;
        
    } else {
        self.timeLineLayer.hidden = YES;
        flag =
        self.dataSource.configreDataSource.configure.minScaleToLine &&
        self.dataSource.configreDataSource.configure.scale < self.dataSource.configreDataSource.configure.minScale + 0.1;
        self.minScaleLineLayer.hidden =
        self.minScaleLineShadeLayer.hidden = !flag;
        self.newpriceTextLayer.hidden = NO;
        self.minPriceTextLayer.hidden = NO;
        self.maxPriceTextLayer.hidden = NO;
        self.newpriceLayer.hidden = NO;
    }
    
    self.trendUpLayer.hidden =
    self.trendDownLayer.hidden = flag;
    [self.smaLayerDict.allValues enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = flag;
    }];
    [self.emaLayerDict.allValues enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = flag;
    }];
    [self.bollLayerDict.allValues enumerateObjectsUsingBlock:^(NSArray<CAShapeLayer *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull layer, NSUInteger idx, BOOL * _Nonnull stop) {
            layer.hidden = flag;
        }];
    }];
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

- (NSDictionary<NSNumber *,CAShapeLayer *> *)smaLayerDict {
    if (!_smaLayerDict){
        NSMutableDictionary *mDict = @{}.mutableCopy;
        [self.dataSource.configreDataSource.configure.smaDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
            CAShapeLayer *smaLayer = [CAShapeLayer layer];
            smaLayer.strokeColor = obj.CGColor;
            smaLayer.lineWidth = self.dataSource.configreDataSource.configure.lineWidth;;
            smaLayer.fillColor = UIColor.clearColor.CGColor;
            smaLayer.lineCap = kCALineCapRound;
            smaLayer.lineJoin = kCALineCapRound;
            smaLayer.masksToBounds = YES;
            smaLayer.frame = self.bounds;
            [self addSublayer:smaLayer];
            [mDict setObject:smaLayer forKey:key];
        }];
        if (mDict.allKeys.count) {
            _smaLayerDict = mDict.copy;
        }
    }
    return _smaLayerDict;
}

- (NSDictionary<NSNumber *,CAShapeLayer *> *)emaLayerDict {
    if (!_emaLayerDict){
        NSMutableDictionary *mDict = @{}.mutableCopy;
        [self.dataSource.configreDataSource.configure.emaDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
            CAShapeLayer *emaLayer = [CAShapeLayer layer];
            emaLayer.strokeColor = obj.CGColor;
            emaLayer.lineWidth = self.dataSource.configreDataSource.configure.lineWidth;;
            emaLayer.fillColor = UIColor.clearColor.CGColor;
            emaLayer.lineCap = kCALineCapRound;
            emaLayer.lineJoin = kCALineCapRound;
            emaLayer.masksToBounds = YES;
            emaLayer.frame = self.bounds;
            [self addSublayer:emaLayer];
            [mDict setObject:emaLayer forKey:key];
        }];
        if (mDict.allKeys.count) {
            _emaLayerDict = mDict.copy;
        }
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
                    bollLayer.lineWidth = self.dataSource.configreDataSource.configure.lineWidth;;
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
        if (mDict.allKeys.count) {
            _bollLayerDict = mDict.copy;
        }
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
            [self.smaLayerDict.allValues makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
            self.smaLayerDict = nil;
        } break;
            
        case HyChartKLineTechnicalTypeEMA: {
            [self.emaLayerDict.allValues makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
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

- (CATextLayer *)maxPriceTextLayer {
    if (!_maxPriceTextLayer){
        _maxPriceTextLayer = self.maxMinPriceTextLayer;
    }
    return _maxPriceTextLayer;
}

- (CATextLayer *)minPriceTextLayer {
    if (!_minPriceTextLayer){
        _minPriceTextLayer = self.maxMinPriceTextLayer;
    }
    return _minPriceTextLayer;
}

- (CATextLayer *)maxMinPriceTextLayer {
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.masksToBounds = YES;
    textLayer.font = (__bridge CTFontRef)self.dataSource.configreDataSource.configure.maxminPriceFont;
    textLayer.fontSize  = self.dataSource.configreDataSource.configure.maxminPriceFont.pointSize;
    textLayer.foregroundColor = self.dataSource.configreDataSource.configure.maxminPriceColor.CGColor;
    textLayer.contentsScale = UIScreen.mainScreen.scale;
    textLayer.alignmentMode = kCAAlignmentCenter;
    [self addSublayer:textLayer];
    return textLayer;
}

- (CAShapeLayer *)layerWithTrend:(HyChartKLineTrend)trend {
    
    id<HyChartKLineConfigureProtocol> configure = self.dataSource.configreDataSource.configure;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = configure.lineWidth;
    
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

- (CAShapeLayer *)newpriceLayer {
    if (!_newpriceLayer){
        _newpriceLayer = [CAShapeLayer layer];
        _newpriceLayer.strokeColor = self.dataSource.configreDataSource.configure.newpriceColor.CGColor;
        _newpriceLayer.lineWidth = .5;
        _newpriceLayer.fillColor = UIColor.clearColor.CGColor;
        _newpriceLayer.lineCap = kCALineCapRound;
        _newpriceLayer.lineJoin = kCALineCapRound;
        _newpriceLayer.masksToBounds = YES;
        _newpriceLayer.frame = self.bounds;
        _newpriceLayer.lineDashPattern = @[@6, @3];
        [self addSublayer:_newpriceLayer];
    }
    return _newpriceLayer;
}

- (CATextLayer *)newpriceTextLayer {
    if (!_newpriceTextLayer){
        _newpriceTextLayer = [CATextLayer layer];
        _newpriceTextLayer.masksToBounds = YES;
        UIFont *font = self.dataSource.configreDataSource.configure.newpriceFont;
        UIColor *color = self.dataSource.configreDataSource.configure.newpriceColor;
        _newpriceTextLayer.font = (__bridge CTFontRef)font;
        _newpriceTextLayer.fontSize = font.pointSize;
        _newpriceTextLayer.foregroundColor = color.CGColor;
        _newpriceTextLayer.contentsScale = UIScreen.mainScreen.scale;
        _newpriceTextLayer.alignmentMode = kCAAlignmentCenter;
        _newpriceTextLayer.borderWidth = .5;
        _newpriceTextLayer.borderColor = color.CGColor;
        _newpriceTextLayer.zPosition = 999;
        [self addSublayer:_newpriceTextLayer];
    }
    return _newpriceTextLayer;
}

- (CAShapeLayer *)minScaleLineLayer {
    if (!_minScaleLineLayer){
        _minScaleLineLayer = [CAShapeLayer layer];
        _minScaleLineLayer.lineWidth = self.dataSource.configreDataSource.configure.minScaleLineWidth;
        _minScaleLineLayer.strokeColor =  self.dataSource.configreDataSource.configure.minScaleLineColor.CGColor;
        _minScaleLineLayer.fillColor = UIColor.clearColor.CGColor;
        _minScaleLineLayer.lineCap = kCALineCapRound;
        _minScaleLineLayer.lineJoin = kCALineCapRound;
        _minScaleLineLayer.masksToBounds = YES;
        _minScaleLineLayer.frame = self.bounds;
        [self addSublayer:_minScaleLineLayer];
    }
    return _minScaleLineLayer;
}

- (CAGradientLayer *)minScaleLineShadeLayer {
    if (!_minScaleLineShadeLayer){
        _minScaleLineShadeLayer = [self shadeLayerWithColors:self.dataSource.configreDataSource.configure.minScaleLineShadeColors];
    }
    return _minScaleLineShadeLayer;
}

- (CAGradientLayer *)shadeLayerWithColors:(NSArray *)colors {
    
    if (colors.count < 2) {
        return nil;
    }
    
    CAGradientLayer *shadeLayer = [CAGradientLayer layer];
    NSMutableArray *shadesColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [shadesColors addObject:(__bridge id)color.CGColor];
    }
    shadeLayer.colors = shadesColors;
    shadeLayer.locations = @[@0.0,@0.2,@1.0];
    shadeLayer.startPoint = CGPointMake(0.5,0.5);
    shadeLayer.endPoint = CGPointMake(0.5,1);
    shadeLayer.mask = [CAShapeLayer layer];
    shadeLayer.frame = self.bounds;
    [self addSublayer:shadeLayer];
    return shadeLayer;
}

- (CGFloat (^)(NSNumber * _Nonnull))valuePositon {
    return ^(NSNumber *value) {    
        return CGRectGetHeight(self.bounds) - self.valueHeight(value);
    };
}

- (CGFloat (^)(NSNumber * _Nonnull))valueHeight {
    return ^(NSNumber *value) {
        double maxValue = 0;
        double minValue = 0;
        if ([self.superlayer isKindOfClass:NSClassFromString(@"HyChartKLineLayer")]) {
           maxValue = self.dataSource.axisDataSource.yAxisModelWityViewType(HyChartKLineViewTypeMain).yAxisMaxValue.doubleValue;
           minValue = self.dataSource.axisDataSource.yAxisModelWityViewType(HyChartKLineViewTypeMain).yAxisMinValue.doubleValue;
        } else {
           maxValue = self.dataSource.axisDataSource.yAxisModel.yAxisMaxValue.doubleValue;
           minValue = self.dataSource.axisDataSource.yAxisModel.yAxisMinValue.doubleValue;
        }
        double heightRate = maxValue != minValue ? CGRectGetHeight(self.bounds) / (maxValue - minValue) : 0;
        CGFloat valueHeight = (value.doubleValue - minValue) * heightRate;
        return valueHeight;
    };
}

- (HyChartLineLayer *)timeLineLayer {
    if (!_timeLineLayer) {
        _timeLineLayer = [HyChartLineLayer layerWithDataSource:(id)self.dataSource];
        _timeLineLayer.frame = self.bounds;
        [self addSublayer:_timeLineLayer];
    }
    return _timeLineLayer;
}

//- (void)setTimeLine:(BOOL)timeLine {
//    _timeLine = timeLine;
//    [self.timeLineLayer removeFromSuperlayer];
//    self.timeLineLayer = nil;
//}

@end
