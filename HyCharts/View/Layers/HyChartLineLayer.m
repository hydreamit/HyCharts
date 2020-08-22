//
//  HyChartLineLayer.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/25.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartLineLayer.h"
#import "HyChartLineConfigure.h"
#import <CoreText/CoreText.h>
#import "HyChartsMethods.h"
#import "HyChartKLineConfigure.h"


@interface HyChartLineLayer ()
@property (nonatomic, strong) NSDictionary<NSString *, NSArray *> *layerDict;
@property (nonatomic, strong) NSArray<HyChartLineOneConfigure *> *configures;
@end


@implementation HyChartLineLayer

- (void)setNeedsRendering {
    [super setNeedsRendering];
        
    if (!self.dataSource.modelDataSource.visibleModels.count) {
        return;
    }
        
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat scaleWidth = self.dataSource.configreDataSource.configure.scaleWidth;
    
    double maxValue = 0;
    double minValue = 0;
    if ([self.superlayer.superlayer isKindOfClass:NSClassFromString(@"HyChartKLineLayer")]) {
        maxValue = self.dataSource.axisDataSource.yAxisModelWityViewType(HyChartKLineViewTypeMain).yAxisMaxValue.doubleValue;
        minValue = self.dataSource.axisDataSource.yAxisModelWityViewType(HyChartKLineViewTypeMain).yAxisMinValue.doubleValue;
    } else {
        maxValue = self.dataSource.axisDataSource.yAxisModel.yAxisMaxValue.doubleValue;
        minValue = self.dataSource.axisDataSource.yAxisModel.yAxisMinValue.doubleValue;
    }
    
//    double maxValue = self.dataSource.axisDataSource.yAxisModel.yAxisMaxValue.doubleValue;
//    double minValue = self.dataSource.axisDataSource.yAxisModel.yAxisMinValue.doubleValue;
    double heightRate = maxValue != minValue ? height / (maxValue - minValue) : 0;
        
    NSMutableArray<UIBezierPath *> *shadePaths = @[].mutableCopy;
    NSMutableArray<UIBezierPath *> *paths = @[].mutableCopy;
    NSMutableArray<UIBezierPath *> *dotPaths = @[].mutableCopy;
    NSMutableArray<NSValue *> *startPs = @[].mutableCopy;
    NSMutableArray<NSValue *> *endPs = @[].mutableCopy;
    NSInteger valueCount = self.dataSource.modelDataSource.visibleModels.firstObject.values.count;
    NSInteger count = self.dataSource.modelDataSource.visibleModels.count;
    for (NSInteger index = 0; index < valueCount; index ++) {
       [paths addObject:UIBezierPath.bezierPath];
       [dotPaths addObject:UIBezierPath.bezierPath];
       [shadePaths addObject:UIBezierPath.bezierPath];
    }
    
    for (NSInteger i = 1; i < self.dataSource.modelDataSource.visibleModels.count; i++) {

        id<HyChartLineModelProtocol> startModel = self.dataSource.modelDataSource.visibleModels[i - 1];
        id<HyChartLineModelProtocol> endModel = self.dataSource.modelDataSource.visibleModels[i];
                
        for (NSInteger j = 0; j < valueCount; j ++) {
                       
           CGPoint startPoint = CGPointMake(startModel.visiblePosition + scaleWidth / 2, height - ((startModel.values[j].doubleValue - minValue) * heightRate));
           [self convertPoint:startPoint toLayer:self.layers[j]];
           if (i == 1) {
               [paths[j] moveToPoint:startPoint];
               [shadePaths[j] moveToPoint:startPoint];
               [startPs addObject:[NSValue valueWithCGPoint:startPoint]];
           }
           
           CGPoint endPoint = CGPointMake(endModel.visiblePosition + scaleWidth / 2, height - ((endModel.values[j].doubleValue - minValue) * heightRate));
           if (i == count - 1) {
              [endPs addObject:[NSValue valueWithCGPoint:endPoint]];
           }
           
           HyChartLineOneConfigure *configure = self.configures[j];
           if (configure.lineType == HyChartLineTypeStraight) {
                        
               if (startModel.breakpoints[j].boolValue && i > 1) {
                    [paths[j] moveToPoint:endPoint];
                } else {
                    [paths[j] addLineToPoint:endPoint];
                }
                [shadePaths[j] addLineToPoint:endPoint];
               
            } else {
                
                if (startModel.breakpoints[j].boolValue && i > 1) {
                    [paths[j] moveToPoint:endPoint];
                } else {
                    [paths[j] addCurveToPoint:endPoint
                    controlPoint1:CGPointMake((startPoint.x + endPoint.x) / 2, startPoint.y)
                    controlPoint2:CGPointMake((startPoint.x + endPoint.x) / 2, endPoint.y)];
                }
                [shadePaths[j] addCurveToPoint:endPoint
                controlPoint1:CGPointMake((startPoint.x + endPoint.x) / 2, startPoint.y)
                controlPoint2:CGPointMake((startPoint.x + endPoint.x) / 2, endPoint.y)];
            }
           
           if (configure.linePointType != HyChartLinePointTypeNone) {
               
               CGRect startRect = CGRectZero;
               if (i == 1) {
                   startRect = CGRectMake(startPoint.x - (configure.linePointSize.width / 2), startPoint.y - (configure.linePointSize.height / 2), configure.linePointSize.width, configure.linePointSize.height);
               }
               
               CGRect endRect = CGRectMake(endPoint.x - (configure.linePointSize.width / 2), endPoint.y - (configure.linePointSize.height / 2), configure.linePointSize.width, configure.linePointSize.height);
               
               if (configure.linePointType == HyChartLinePointTypeRect) {
                    if (i == 1) {
                        [dotPaths[j] appendPath:[UIBezierPath bezierPathWithRect:startRect]];
                    }
                    [dotPaths[j] appendPath:[UIBezierPath bezierPathWithRect:endRect]];
                } else  {
                   if (i == 1) {
                       [dotPaths[j] appendPath:[UIBezierPath bezierPathWithOvalInRect:startRect]];
                   }
                   [dotPaths[j] appendPath:[UIBezierPath bezierPathWithOvalInRect:endRect]];
                }
            }
       }
    }
    
    [self.layers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.path = paths[idx].CGPath;
        HyChartLineOneConfigure *configure = self.configures[idx];
        if (configure.linePointType != HyChartLinePointTypeNone) {
            self.dotLayers[idx].path = dotPaths[idx].CGPath;
        }

        if (configure.shadeColors.count > 1) {
            UIBezierPath *shadePath = [UIBezierPath bezierPathWithCGPath:shadePaths[idx].CGPath];
            [shadePath addLineToPoint:CGPointMake([endPs[idx] CGPointValue].x, CGRectGetMaxY(self.bounds))];
            [shadePath addLineToPoint:CGPointMake([startPs[idx] CGPointValue].x, CGRectGetMaxY(self.bounds))];
            [shadePath closePath];
            ((CAShapeLayer *)(self.shadeLayers[idx].mask)).path = shadePath.CGPath;
        }
        
        NSString *maxString = @"";
        NSString *mixString = @"";
        CGRect minRect = CGRectZero;
        CGRect maxRect = CGRectZero;
        
        if (configure.disPlayMaxMinValue) {
             
            NSInteger startIndex = self.dataSource.modelDataSource.visibleFromIndex;
            NSInteger endIndex = self.dataSource.modelDataSource.visibleToIndex;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, endIndex - startIndex + 1)];

            NSArray *marray = self.dataSource.modelDataSource.valuesArray[idx];
            NSArray<NSNumber *> *array = [marray objectsAtIndexes:indexSet];
            
            NSInteger maxIndex = [array indexOfObject:[array valueForKeyPath:@"@max.doubleValue"]];
            id<HyChartLineModelProtocol> maxModel = self.dataSource.modelDataSource.visibleModels[maxIndex];
            CGPoint maxPoint = CGPointMake(maxModel.visiblePosition + scaleWidth / 2, height - ((maxModel.values[idx].doubleValue - minValue) * heightRate));
            
            NSString *maxValueSting = [self.dataSource.modelDataSource.numberFormatter stringFromNumber:maxModel.values[idx]];
             maxString = [NSString stringWithFormat:@"↙ %@", SafetyString(maxValueSting)];
            CGSize maxSize = [maxString sizeWithAttributes:@{NSFontAttributeName : configure.maxminValueFont}];
            
            maxRect = CGRectMake(maxPoint.x, maxPoint.y - maxSize.height , maxSize.width, maxSize.height);
            if (CGRectGetMaxX(maxRect) > CGRectGetWidth(self.bounds)) {
                maxRect.origin.x = maxPoint.x - maxSize.width;
                maxString = [NSString stringWithFormat:@"%@ ↘", SafetyString(maxValueSting)];
            }
     
            NSInteger minIndex = [array indexOfObject:[array valueForKeyPath:@"@min.doubleValue"]];
            id<HyChartLineModelProtocol> minModel = self.dataSource.modelDataSource.visibleModels[minIndex];
            CGPoint minPoint = CGPointMake(minModel.visiblePosition + scaleWidth / 2, height - ((minModel.values[idx].doubleValue - minValue) * heightRate));
             NSString *minValueString = [self.dataSource.modelDataSource.numberFormatter stringFromNumber:minModel.values[idx]];
            
             mixString = [NSString stringWithFormat:@"↖ %@", SafetyString(minValueString)];
            CGSize minSize = [mixString sizeWithAttributes:@{NSFontAttributeName : configure.maxminValueFont}];
             minRect = CGRectMake(minPoint.x, minPoint.y , minSize.width, minSize.height);
             if (CGRectGetMaxX(minRect) > CGRectGetWidth(self.bounds)) {
                 minRect.origin.x = minPoint.x - minSize.width;
                 mixString = [NSString stringWithFormat:@"%@ ↗", SafetyString(minValueString)];
             }
        }
        
        NSString *newString = @"";
        CGRect newTextRect = CGRectZero;
        UIBezierPath *newPath = UIBezierPath.bezierPath;
        NSNumber *newValue = self.dataSource.modelDataSource.models.firstObject.values[idx];
        CGFloat changef = newValue.doubleValue - minValue;
        if (configure.disPlayNewvalue &&
            newValue.doubleValue < maxValue &&
            changef > 0) {
              CGFloat y = height - changef * heightRate;
               newString = SafetyString([self.dataSource.modelDataSource.numberFormatter stringFromNumber:newValue]);
                CGSize xSize = [newString sizeWithAttributes:@{NSFontAttributeName : configure.newvalueFont}];
               xSize = CGSizeMake(xSize.width + 6, xSize.height);
               newTextRect =  CGRectMake(CGRectGetMinX(self.bounds) , y - xSize.height / 2 , xSize.width, xSize.height);
               [newPath moveToPoint:CGPointMake(CGRectGetMaxX(newTextRect), y)];
               [newPath addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame), y)];
        }

        TransactionDisableActions(^{
            self.maxValueTextLayers[idx].frame = maxRect;
            self.maxValueTextLayers[idx].string = maxString;
            self.minValueTextLayers[idx].frame = minRect;
            self.minValueTextLayers[idx].string = mixString;
            self.newValueTextLayers[idx].frame = newTextRect;
            self.newValueTextLayers[idx].string = newString;
            self.newValueLineLayers[idx].path = newPath.CGPath;
        });
    }];
}

- (NSDictionary<NSString *,NSArray *> *)layerDict {
    if (!_layerDict){
        
        [self.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        
        NSMutableArray<CAShapeLayer *> *layers = @[].mutableCopy;
        NSMutableArray<CAShapeLayer *> *dotLayers = @[].mutableCopy;
        NSMutableArray<CAGradientLayer *> *shadeLayers = @[].mutableCopy;
        NSMutableArray<CATextLayer *> *maxTextLayers = @[].mutableCopy;
        NSMutableArray<CATextLayer *> *minTextLayers = @[].mutableCopy;
        NSMutableArray<CATextLayer *> *newTextLayers = @[].mutableCopy;
        NSMutableArray<CAShapeLayer *> *newLineLayers = @[].mutableCopy;
        NSMutableArray<HyChartLineOneConfigure *> *configures = @[].mutableCopy;
        NSInteger count = self.dataSource.modelDataSource.models.firstObject.values.count;
//        if (self.dataSource.configreDataSource.configure.lineConfigureAtIndexBlock) {
           for (NSInteger i = 0; i < count; i++) {
               
               HyChartLineOneConfigure *configure = HyChartLineOneConfigure.defaultConfigure;
               if ([self.dataSource.configreDataSource.configure isKindOfClass:NSClassFromString(@"HyChartKLineConfigure")]) {
                   HyChartKLineConfigure *kconfigure = (HyChartKLineConfigure *)self.dataSource.configreDataSource.configure;
                   configure.disPlayNewvalue = kconfigure.disPlayNewprice;
                   configure.disPlayMaxMinValue = kconfigure.disPlayMaxMinPrice;
                   configure.maxminValueFont = kconfigure.maxminPriceFont;
                   configure.maxminValueColor = kconfigure.maxminPriceColor;
                   configure.newvalueFont = kconfigure.newpriceFont;
                   configure.newvalueColor = kconfigure.newpriceColor;
                   configure.lineWidth = kconfigure.lineWidth;
                   configure.lineColor = kconfigure.minScaleLineColor;
               }
               
               !self.dataSource.configreDataSource.configure.lineConfigureAtIndexBlock ?:
               self.dataSource.configreDataSource.configure.lineConfigureAtIndexBlock(i, configure);
               [configures addObject:configure];
           
               CAShapeLayer *layer = [CAShapeLayer layer];
               layer.strokeColor = configure.lineColor.CGColor;
               layer.lineWidth = configure.lineWidth;
               layer.fillColor = UIColor.clearColor.CGColor;
               layer.lineCap = kCALineCapRound;
               layer.lineJoin = kCALineCapRound;
               layer.masksToBounds = YES;
               layer.frame = self.bounds;
               [self addSublayer:layer];
               [layers addObject:layer];
               
               CAShapeLayer *dotLayer = [CAShapeLayer layer];
               dotLayer.lineWidth = configure.linePointWidth;
               dotLayer.fillColor = configure.linePointFillColor.CGColor;
               dotLayer.strokeColor = configure.linePointStrokeColor.CGColor;
               dotLayer.lineCap = kCALineCapRound;
               dotLayer.lineJoin = kCALineCapRound;
               dotLayer.zPosition = 999;
               dotLayer.masksToBounds = YES;
               dotLayer.frame = self.bounds;
               [self addSublayer:dotLayer];
               [dotLayers addObject:dotLayer];
               
               CAGradientLayer *shadeLayer = [CAGradientLayer layer];
               NSMutableArray *shadeColors = [NSMutableArray array];
               for (UIColor *color in configure.shadeColors) {
                   [shadeColors addObject:(__bridge id)color.CGColor];
               }
               shadeLayer.colors = shadeColors;
               shadeLayer.locations = @[@0.0, @0.2, @1.0];
               shadeLayer.startPoint = CGPointMake(0.5, 0.5);
               shadeLayer.endPoint = CGPointMake(0.5, 1);
               shadeLayer.mask = [CAShapeLayer layer];
               shadeLayer.frame = self.bounds;
               [self addSublayer:shadeLayer];
               [shadeLayers addObject:shadeLayer];
               
               [maxTextLayers addObject:[self textLayerWithColor:configure.maxminValueColor font:configure.maxminValueFont hasBorder:NO]];
               [minTextLayers addObject:[self textLayerWithColor:configure.maxminValueColor font:configure.maxminValueFont hasBorder:NO]];
               [newTextLayers addObject:
               [self textLayerWithColor:configure.newvalueColor font:configure.newvalueFont hasBorder:YES]];
               
               CAShapeLayer *lineLayer = [CAShapeLayer layer];
               lineLayer.strokeColor = configure.newvalueColor.CGColor;
               lineLayer.lineWidth = .5;
               lineLayer.fillColor = UIColor.clearColor.CGColor;
               lineLayer.lineCap = kCALineCapRound;
               lineLayer.lineJoin = kCALineCapRound;
               lineLayer.masksToBounds = YES;
               lineLayer.frame = self.bounds;
               lineLayer.lineDashPattern = @[@6, @3];
               lineLayer.zPosition = 999;
               [self addSublayer:lineLayer];
               [newLineLayers addObject:lineLayer];
           }
//       }
        _layerDict = @{@"layers" : layers.copy,
                       @"dotLayers" : dotLayers.copy,
                       @"shadeLayers" : shadeLayers.copy,
                       @"maxTextLayers" : maxTextLayers.copy,
                       @"minTextLayers" : minTextLayers.copy,
                       @"newTextLayers" : newTextLayers.copy,
                       @"newLineLayers" : newLineLayers.copy,
        };
        self.configures = configures.copy;
    }
    return _layerDict;
}

- (NSArray<CAShapeLayer *> *)layers {
    return self.layerDict[@"layers"];
}

- (NSArray<CAShapeLayer *> *)dotLayers {
    return self.layerDict[@"dotLayers"];
}

- (NSArray<CAGradientLayer *> *)shadeLayers {
    return self.layerDict[@"shadeLayers"];
}

- (NSArray<CATextLayer *> *)maxValueTextLayers {
    return self.layerDict[@"maxTextLayers"];
}

- (NSArray<CATextLayer *> *)minValueTextLayers {
    return self.layerDict[@"minTextLayers"];
}

- (NSArray<CATextLayer *> *)newValueTextLayers {
    return self.layerDict[@"newTextLayers"];
}

- (NSArray<CAShapeLayer *> *)newValueLineLayers {
    return self.layerDict[@"newLineLayers"];
}

- (CGFloat (^)(NSNumber * _Nonnull))valueHeight {
    return ^(NSNumber *value) {
        double maxValue = self.dataSource.axisDataSource.yAxisModel.yAxisMaxValue.doubleValue;
        double minValue = self.dataSource.axisDataSource.yAxisModel.yAxisMinValue.doubleValue;
        double heightRate = maxValue != minValue ? CGRectGetHeight(self.bounds) / (maxValue - minValue) : 0;
        CGFloat valueHeight = (value.doubleValue - minValue) * heightRate;
        return valueHeight;
    };
}

- (CATextLayer *)textLayerWithColor:(UIColor *)color font:(UIFont *)font hasBorder:(BOOL)hasBorder {
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.masksToBounds = YES;
    textLayer.font = CFBridgingRetain(font);
    textLayer.font = (__bridge CTFontRef)font;
    textLayer.fontSize = font.pointSize;
    textLayer.foregroundColor = color.CGColor;
    textLayer.contentsScale = UIScreen.mainScreen.scale;
    textLayer.alignmentMode = kCAAlignmentCenter;
    if (hasBorder) {
        textLayer.borderWidth = .5;
        textLayer.borderColor = color.CGColor;
    }
    textLayer.zPosition = 999;
    [self addSublayer:textLayer];
    return textLayer;
}

- (CGFloat (^)(NSNumber * _Nonnull))valuePositon {
    return ^(NSNumber *value){
        return CGRectGetHeight(self.bounds) - self.valueHeight(value);
    };
}

- (void)resetLayers {
    self.layerDict = nil;
}

@end
