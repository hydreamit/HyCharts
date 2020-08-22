//
//  HyChartAxisLayer.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/19.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartAxisLayer.h"
#import <CoreText/CoreText.h>


@interface HyChartAxisLayer ()
@property (nonatomic, strong) HyChartXAxisModel *xAxisModel;
@property (nonatomic, strong) HyChartYAxisModel *yAxisModel;
@property (nonatomic, strong) NSMutableDictionary<NSString *, CAShapeLayer *> *axisLines;
@property (nonatomic, strong) NSMutableDictionary<NSString *, CAShapeLayer *> *axisGridLines;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<CATextLayer *> *> *axisTexts;
@property (nonatomic, strong) NSDictionary *attrDict;
@end


@implementation HyChartAxisLayer

+ (instancetype)layerWithDataSource:(HyChartDataSource *)dataSource {
    HyChartAxisLayer *layer = [super layerWithDataSource:dataSource];
    layer.xAxisModel = dataSource.axisDataSource.xAxisModel;
    layer.yAxisModel = dataSource.axisDataSource.yAxisModel;
    return layer;
}

+ (instancetype)layerWithDataSource:(HyChartDataSource *)dataSource
                         xAxisModel:(HyChartXAxisModel *)xAxisModel
                         yAxisModel:(HyChartYAxisModel *)yAxisModel {
    HyChartAxisLayer *layer = [super layerWithDataSource:dataSource];
    layer.xAxisModel = xAxisModel;
    layer.yAxisModel = yAxisModel;
    return layer;
}

- (void)setNeedsRendering {
    [super setNeedsDisplay];
    
    if (!self.axisGridLines.count) {
        NSArray<NSString *> *gridLinePosition = @[@"x", @"y"];
        [gridLinePosition enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            self.axisGridLineRendering(obj);
        }];
    }
    
    if (!self.axisLines.count || !self.axisTexts.count) {
        NSArray<NSString *> *linePosition = @[@"top", @"left", @"bottom", @"right"];
        [linePosition enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            self.axisLineRendering(obj);
            self.axisTextRendering(obj, idx);
        }];
    } else if (self.axisTexts.count) {
        
        NSArray<NSString *> *linePosition = @[@"top", @"left", @"bottom", @"right"];
        [linePosition enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            self.axisTextRendering(obj, idx);
        }];

        return;
        
//        [self.axisTexts enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray<CATextLayer *> * _Nonnull obj, BOOL * _Nonnull stop) {
//            id<HyChartAxisInfoProtocol> axisBaseInfo = self.axisBaseInfo(key);
//            [obj enumerateObjectsUsingBlock:^(CATextLayer * _Nonnull textLayer, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                 id text = @"";
//                 if ([axisBaseInfo conformsToProtocol:@protocol(HyChartXAxisInfoProtocol)]) {
//                     text = ((id<HyChartXAxisInfoProtocol>)axisBaseInfo).textAtIndexBlock(idx, self.dataSource.modelDataSource.visibleXAxisModels[idx]);
//                 }
//                if ([axisBaseInfo conformsToProtocol:@protocol(HyChartYAxisInfoProtocol)]) {
//                    text =
//                    ((id<HyChartYAxisInfoProtocol>)axisBaseInfo).textAtIndexBlock(idx, self.yAxisModel.yAxisMaxValue, self.yAxisModel.yAxisMinValue);
//                 }
//
//                CGSize size = CGSizeZero;
//                BOOL can = NO;
//                if ([text isKindOfClass:NSString.class]) {
//                    if (![((NSString *)text) isEqualToString:textLayer.string]) {
//                        size = [text sizeWithAttributes:self.attrDict];
//                        can = YES;
//                    }
//                } else {
//                    if (![((NSAttributedString *)text).string isEqualToString:textLayer.string]) {
//                        size = ((NSAttributedString *)text).size;
//                        can = YES;
//                    }
//                }
//                if (can) {
//                    textLayer.string = text;
//                    textLayer.frame = [self rectWithRect:textLayer.frame
//                                                position:key
//                                             textPositon:axisBaseInfo.axisTextPosition
//                                                 newSize:size];
//                }
//            }];
//        }];
    }
}

- (CGRect)rectWithRect:(CGRect)rect
              position:(NSString *)position
           textPositon:(HyChartAxisTextPosition)textPosition
               newSize:(CGSize)size {
    
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;

    if ([position isEqualToString:@"top"]) {
        if (textPosition == HyChartAxisTextPositionBinus) {
            x = CGRectGetMidX(rect) - size.width / 2;
        }
    } else if ([position isEqualToString:@"left"]) {
        if (textPosition == HyChartAxisTextPositionBinus) {
            x = CGRectGetMaxX(rect) - size.width;
        }
    } else if ([position isEqualToString:@"bottom"]) {
        if (textPosition == HyChartAxisTextPositionPlus) {
            x = CGRectGetMidX(rect) - size.width / 2;
        }
    } else if ([position isEqualToString:@"right"]) {
        if (textPosition == HyChartAxisTextPositionBinus) {
            x = CGRectGetMaxX(rect) - size.width;
        }
    }
    return CGRectMake(x, y , size.width, size.height);
}

- (void(^)(NSString *axisLinePosition))axisLineRendering {
    return ^(NSString *axisLinePosition) {
        [self createAxisLineWithPosition:axisLinePosition];
    };
}

- (void(^)(NSString *axisGridLineType))axisGridLineRendering {
    return ^(NSString *axisGridLineType){
        [self createAxisGridLineWithAxisType:axisGridLineType];
    };
}

- (void(^)(NSString *axisLinePosition, NSInteger index))axisTextRendering {
    return ^(NSString *axisLinePosition, NSInteger index){
        [self createAxisTextWithAxisLinePosition:axisLinePosition];
    };
}

- (void)createAxisLineWithPosition:(NSString *)position {
    
    if ([self axisLineDisabledWithPosition:position]) {
        return;
    }

    HyChartAxisInfo *baseInfo = self.axisBaseInfo(position);
    if (baseInfo.axisLineType == HyChartAxisLineTypeNone) {
        return;
    }
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    if ([position isEqualToString:@"top"]) {
        
        startPoint = CGPointMake(CGRectGetMinX(self.contentRect), CGRectGetMinY(self.contentRect));
        endPoint = CGPointMake(CGRectGetMaxX(self.contentRect), CGRectGetMinY(self.contentRect));
        
    } else if ([position isEqualToString:@"left"]) {
        
        startPoint = CGPointMake(CGRectGetMinX(self.contentRect), CGRectGetMaxY(self.contentRect));
        endPoint = CGPointMake(CGRectGetMinX(self.contentRect), CGRectGetMinY(self.contentRect));
        
    } else if ([position isEqualToString:@"bottom"]) {
        
        startPoint = CGPointMake(CGRectGetMinX(self.contentRect), CGRectGetMaxY(self.contentRect));
        endPoint = CGPointMake(CGRectGetMaxX(self.contentRect), CGRectGetMaxY(self.contentRect));
        
    } else if ([position isEqualToString:@"right"]) {
        startPoint = CGPointMake(CGRectGetMaxX(self.contentRect), CGRectGetMaxY(self.contentRect));
        endPoint = CGPointMake(CGRectGetMaxX(self.contentRect), CGRectGetMinY(self.contentRect));
    }
    
    CAShapeLayer *axisLineLayer = self.axisLines[position];
    if (!axisLineLayer) {
        axisLineLayer = [CAShapeLayer layer];
        axisLineLayer.frame = self.bounds;
        axisLineLayer.masksToBounds = YES;
        [self addSublayer:axisLineLayer];
        [self.axisLines setObject:axisLineLayer forKey:position];
    }
    
    UIBezierPath *path = UIBezierPath.bezierPath;
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    axisLineLayer.strokeColor = baseInfo.axisLineColor.CGColor;
    axisLineLayer.lineWidth = baseInfo.axisLineWidth;
    axisLineLayer.path = path.CGPath;
    if (baseInfo.axisLineType == HyChartAxisLineTypeDash) {
        axisLineLayer.lineDashPhase = baseInfo.axisLineDashPhase;
        axisLineLayer.lineDashPattern = baseInfo.axisLineDashPattern;
    }
}

- (void)createAxisGridLineWithAxisType:(NSString *)axisType {
        
    HyChartAxisModel *axisModel = self.axisModel(axisType);
    if (axisModel.axisGridLineInfo.axisGridLineType == HyChartAxisLineTypeNone || !axisModel.indexs) {
        return;
    }

    CGFloat spaceMargin =  ([axisType isEqualToString:@"x"] ? self.contentRect.size.width : self.contentRect.size.height) / (axisModel.indexs);

    CAShapeLayer *axisGridLineLayer = self.axisGridLines[axisType];
    if (!axisGridLineLayer) {
        axisGridLineLayer = [CAShapeLayer layer];
        axisGridLineLayer.frame = self.bounds;
        axisGridLineLayer.masksToBounds = YES;
        [self addSublayer:axisGridLineLayer];
        [self.axisGridLines setObject:axisGridLineLayer forKey:axisType];
    }
        
    UIBezierPath *path = UIBezierPath.bezierPath;
    for (int i = 1; i < axisModel.indexs; i++) {
        
        CGFloat xy = spaceMargin * i;
        CGPoint startPoint = CGPointZero;
        CGPoint endPoint = CGPointZero;
        
        if ([axisType isEqualToString:@"x"]) {
            
            startPoint = CGPointMake(xy + CGRectGetMinX(self.contentRect), CGRectGetMaxY(self.contentRect));
            endPoint = CGPointMake(xy + CGRectGetMinX(self.contentRect), CGRectGetMinY(self.contentRect));
            
        } else if ([axisType isEqualToString:@"y"]) {
            
            startPoint = CGPointMake(CGRectGetMinX(self.contentRect), xy + CGRectGetMinY(self.contentRect));
            endPoint = CGPointMake(CGRectGetMaxX(self.contentRect), xy + CGRectGetMinY(self.contentRect));
        }
        
        [path moveToPoint:startPoint];
        [path addLineToPoint:endPoint];
    }
    axisGridLineLayer.strokeColor = axisModel.axisGridLineInfo.axisGridLineColor.CGColor;
    axisGridLineLayer.lineWidth = axisModel.axisGridLineInfo.axisGridLineWidth;
    axisGridLineLayer.path = path.CGPath;
    if (axisModel.axisGridLineInfo.axisGridLineType == HyChartAxisLineTypeDash) {
        axisGridLineLayer.lineDashPhase = axisModel.axisGridLineInfo.axisGridLineDashPhase;
        axisGridLineLayer.lineDashPattern = axisModel.axisGridLineInfo.axisGridLineDashPattern;
    }
}

- (void)createAxisTextWithAxisLinePosition:(NSString *)position {
    
    HyChartAxisModel *axisModel = self.axisModel(position);
    if (!axisModel.indexs) {
        return;
    }
    
    if ([axisModel conformsToProtocol:@protocol(HyChartXAxisModelProtocol)]) {
        HyChartXAxisModel *xAxisModel = (id)axisModel;
        if ([position isEqualToString:@"top"] && xAxisModel.topXaxisDisabled) {
            return;
        }
        
        if ([position isEqualToString:@"bottom"] && xAxisModel.bottomXaxisDisabled) {
            return;
        }
    }
    
    if ([axisModel conformsToProtocol:@protocol(HyChartYAxisModelProtocol)]) {
        HyChartYAxisModel *yAxisModel = (id)axisModel;
        if ([position isEqualToString:@"left"] && yAxisModel.leftYAxisDisabled) {
            return;
        }
        if ([position isEqualToString:@"right"] && yAxisModel.rightYAaxisDisabled) {
            return;
        }
    }
    
    HyChartAxisInfo *axisBaseInfo = self.axisBaseInfo(position);
    if ([axisBaseInfo conformsToProtocol:@protocol(HyChartXAxisInfoProtocol)]) {
        if (!((HyChartXAxisInfo *)axisBaseInfo).textAtIndexBlock) {
            return;
        }
    }
    if ([axisBaseInfo conformsToProtocol:@protocol(HyChartYAxisInfoProtocol)]) {
        if (!((HyChartYAxisInfo *)axisBaseInfo).textAtIndexBlock) {
            return;
        }
    }
    
    CGFloat xy = 0;
    CGFloat xSpaceMargin = 0;
    CGFloat ySpaceMargin = 0;
    CGPoint anchor = CGPointZero;
    CGPoint offset = CGPointZero;
     CGFloat baseOffset = 3;
        
    if ([position isEqualToString:@"top"]) {
        
        xSpaceMargin = self.contentRect.size.width / axisModel.indexs;
        if (axisBaseInfo.axisTextPosition == HyChartAxisTextPositionPlus) {
            anchor = CGPointMake(0, 0);
            offset = CGPointMake(axisBaseInfo.axisTextOffset.x + baseOffset,
                                 axisBaseInfo.axisTextOffset.y + baseOffset);
            xy = CGRectGetMinY(self.contentRect);
        } else {
            anchor = CGPointMake(0.5, 1);
            offset = CGPointMake(axisBaseInfo.axisTextOffset.x,
                                 axisBaseInfo.axisTextOffset.y - baseOffset);
            xy = CGRectGetMinY(self.contentRect);
        }
        
    } else if ([position isEqualToString:@"left"]) {
        
        ySpaceMargin = self.contentRect.size.height / axisModel.indexs;
        if (axisBaseInfo.axisTextPosition == HyChartAxisTextPositionPlus) {
            anchor = CGPointMake(0, 0);
            offset = CGPointMake(axisBaseInfo.axisTextOffset.x + baseOffset,
                                 axisBaseInfo.axisTextOffset.y + baseOffset);
            xy = CGRectGetMinX(self.contentRect);
        } else {
            anchor = CGPointMake(1, .5);
            offset = CGPointMake(axisBaseInfo.axisTextOffset.x - baseOffset,
                                 axisBaseInfo.axisTextOffset.y);
            xy = CGRectGetMinX(self.contentRect);
        }
        
    } else if ([position isEqualToString:@"bottom"]) {

        xSpaceMargin = self.contentRect.size.width / axisModel.indexs;
        if (axisBaseInfo.axisTextPosition == HyChartAxisTextPositionPlus) {
            anchor = CGPointMake(0.5, 0);
            offset = CGPointMake(axisBaseInfo.axisTextOffset.x,
                                 axisBaseInfo.axisTextOffset.y + baseOffset);
            xy = CGRectGetMaxY(self.contentRect);
        } else {
            anchor = CGPointMake(0, 1);
            offset = CGPointMake(axisBaseInfo.axisTextOffset.x + baseOffset,
                                 axisBaseInfo.axisTextOffset.y - baseOffset);
            xy = CGRectGetMaxY(self.contentRect);
        }
        
    } else if ([position isEqualToString:@"right"]) {
        
        ySpaceMargin = self.contentRect.size.height / axisModel.indexs;
        if (axisBaseInfo.axisTextPosition == HyChartAxisTextPositionPlus) {
            anchor = CGPointMake(0, 0.5);
            offset = CGPointMake(axisBaseInfo.axisTextOffset.x + baseOffset,
                                 axisBaseInfo.axisTextOffset.y);
            xy = CGRectGetMaxX(self.contentRect);
        } else {
            anchor = CGPointMake(1, 0);
            offset = CGPointMake(axisBaseInfo.axisTextOffset.x - baseOffset,
                                 axisBaseInfo.axisTextOffset.y + baseOffset);
            xy = CGRectGetMaxX(self.contentRect);
        }
    }
    
    BOOL changeFirst =
    ([position isEqualToString:@"left"] && axisBaseInfo.axisTextPosition == HyChartAxisTextPositionPlus) ||
    ([position isEqualToString:@"right"] && axisBaseInfo.axisTextPosition == HyChartAxisTextPositionBinus);
    
    NSMutableArray<CATextLayer *> *mArray = @[].mutableCopy;
    for (int i = 0; i < axisModel.indexs + 1; i++) {
    
        CATextLayer *textlayer;
        if (self.axisTexts[position].count != axisModel.indexs + 1) {
            textlayer = [CATextLayer layer];
            textlayer.font = (__bridge CTFontRef)axisBaseInfo.axisTextFont;
            textlayer.fontSize = axisBaseInfo.axisTextFont.pointSize;
            textlayer.foregroundColor = axisBaseInfo.axisTextColor.CGColor;
            textlayer.contentsScale = UIScreen.mainScreen.scale;
            textlayer.alignmentMode = kCAAlignmentCenter;
            textlayer.zPosition = 9999;
            [self addSublayer:textlayer];
            [mArray addObject:textlayer];
        } else {
            textlayer = [self.axisTexts[position] objectAtIndex:i];
            textlayer.affineTransform = CGAffineTransformMakeRotation(0);
        }

        id text = @"";
        if ([axisBaseInfo conformsToProtocol:@protocol(HyChartXAxisInfoProtocol)]) {
            
            NSInteger currentIndex = i;
            
            if (self.dataSource.configreDataSource.configure.renderingDirection == HyChartRenderingDirectionReverse) {
                if (!(self.dataSource.configreDataSource.configure.notEnoughSide == HyChartNotEnoughSideLeft && self.dataSource.configreDataSource.configure.notEnough)) {
                    currentIndex = axisModel.indexs - currentIndex;
                }
            } else
            
            if (self.dataSource.configreDataSource.configure.renderingDirection == HyChartRenderingDirectionForward) {
                if ((self.dataSource.configreDataSource.configure.notEnoughSide == HyChartNotEnoughSideRight && self.dataSource.configreDataSource.configure.notEnough)) {
                    currentIndex = axisModel.indexs - currentIndex;
                }
            }
          
            if (currentIndex < self.dataSource.modelDataSource.visibleXAxisModels.count) {
                text = ((HyChartXAxisInfo *)axisBaseInfo).textAtIndexBlock(currentIndex, self.dataSource.modelDataSource.visibleXAxisModels[currentIndex]);
            }
        }
        if ([axisBaseInfo conformsToProtocol:@protocol(HyChartYAxisInfoProtocol)]) {
            text =
            ((HyChartYAxisInfo *)axisBaseInfo).textAtIndexBlock(i, self.yAxisModel.yAxisMaxValue, self.yAxisModel.yAxisMinValue);
        }
        textlayer.string = text;
        
        NSDictionary<NSAttributedStringKey,id> *attr = @{NSFontAttributeName:axisBaseInfo.axisTextFont,
        NSForegroundColorAttributeName:axisBaseInfo.axisTextColor};
        self.attrDict = attr;
        
        CGSize textSize = CGSizeZero;
        if ([text isKindOfClass:NSString.class]) {
           textSize = [text sizeWithAttributes:attr];
        } else {
           textSize = ((NSAttributedString *)text).size;
        }
        
        CGFloat rotateAngle = axisBaseInfo.rotateAngle;
        rotateAngle -= ((NSInteger)(rotateAngle / (M_PI))) * (M_PI);
        if (rotateAngle < - M_PI / 2) {
            rotateAngle = M_PI + rotateAngle;
        } else if (rotateAngle >  M_PI / 2) {
            rotateAngle =  - M_PI + rotateAngle;
        }
                
        BOOL isRotate = NO;
        CGFloat angleOffsetX = 0;
        CGFloat angleOffsetY = 0;
        if (rotateAngle != 0) {
            if (xSpaceMargin) {
                CGFloat angleW = sqrt(pow(textSize.width,2) + pow(textSize.height, 2)) / 2;
                CGFloat angle =  fabs(rotateAngle) + atan(textSize.height / textSize.width);
                if ([position isEqualToString:@"top"] &&
                   axisBaseInfo.axisTextPosition == HyChartAxisTextPositionBinus) {
                   isRotate = YES;
                   if (rotateAngle > 0) {
                       angleOffsetX =  cos(angle) * angleW;
                       angleOffsetY =  sin(rotateAngle) * textSize.width / 2;
                   } else {
                       angleOffsetX = - cos(angle) * angleW;
                       angleOffsetY = - sin(rotateAngle) * textSize.width / 2;
                   }
                } else if ([position isEqualToString:@"bottom"] &&
                          axisBaseInfo.axisTextPosition == HyChartAxisTextPositionPlus) {
                   isRotate = YES;
                   if (rotateAngle > 0) {
                       angleOffsetX = - cos(angle) * angleW;
                       angleOffsetY = - sin(rotateAngle) * textSize.width / 2;
                   } else {
                       angleOffsetX = cos(angle) * angleW;
                       angleOffsetY = sin(rotateAngle) * textSize.width / 2;
                   }
                }
            } else {
                CGFloat angleW = sqrt(pow(textSize.width,2) + pow(textSize.height, 2)) / 2;
                CGFloat angle =  atan(textSize.height / textSize.width) - fabs(rotateAngle);
                if ([position isEqualToString:@"left"] &&
                   axisBaseInfo.axisTextPosition == HyChartAxisTextPositionBinus) {
                   isRotate = YES;
                   if (rotateAngle > 0) {
                       angleOffsetX =  cos(angle) * angleW - textSize.width / 2;
                       angleOffsetY =  - sin(angle) * angleW;
                   } else {
                       angleOffsetX =  cos(angle) * angleW - textSize.width / 2;
                       angleOffsetY =  sin(angle) * angleW;
                   }
                } else if ([position isEqualToString:@"right"] &&
                          axisBaseInfo.axisTextPosition == HyChartAxisTextPositionPlus) {
                   isRotate = YES;
                   if (rotateAngle > 0) {
                       angleOffsetX =  textSize.width / 2 - cos(angle) * angleW ;
                       angleOffsetY =  sin(angle) * angleW;
                   } else {
                       angleOffsetX =  - cos(angle) * angleW + textSize.width / 2;
                       angleOffsetY =  - sin(angle) * angleW;
                   }
                }
            }
        }
      
        CGPoint point = CGPointZero;
        if (xSpaceMargin) {
            point = CGPointMake(xSpaceMargin * i + CGRectGetMinX(self.contentRect) , xy);
        } else {
            point = CGPointMake(xy ,CGRectGetMaxY(self.contentRect) - ySpaceMargin * i);
        }
        point.x -= (textSize.width * anchor.x - offset.x + angleOffsetX);
        point.y -= (textSize.height * anchor.y - offset.y + angleOffsetY);
        if (i == 0 && changeFirst) {
            point.y -= (textSize.height + 2 * offset.y);
        }
        textlayer.frame = CGRectMake(point.x, point.y, textSize.width, textSize.height);
        if (isRotate) {
            textlayer.transform = CATransform3DMakeRotation(rotateAngle, 0, 0, 1);
        }
    }
    
    if (!self.axisTexts[position].count) {
        [self.axisTexts setObject:mArray.copy forKey:position];
    }
}

- (NSMutableDictionary<NSString *,CAShapeLayer *> *)axisLines {
    if (!_axisLines){
        _axisLines = @{}.mutableCopy;
    }
    return _axisLines;
}

- (NSMutableDictionary<NSString *, CAShapeLayer *> *)axisGridLines {
    if (!_axisGridLines){
        _axisGridLines = @{}.mutableCopy;
    }
    return _axisGridLines;
}

- (NSMutableDictionary<NSString *,NSArray<CATextLayer *> *> *)axisTexts {
    if (!_axisTexts){
        _axisTexts = @{}.mutableCopy;
    }
    return _axisTexts;
}

- (NSInteger)xIndexs {
    return self.xAxisModel.indexs;
}

- (NSInteger)yIndexs {
    return self.yAxisModel.indexs;
}

- (HyChartAxisInfo *(^)(NSString *position))axisBaseInfo {
    return ^HyChartAxisInfo *(NSString *position){
        if ([position isEqualToString:@"top"]) {
            return self.xAxisModel.topXAxisInfo;
        } else if ([position isEqualToString:@"left"]) {
            return self.yAxisModel.leftYAxisInfo;
        } else if ([position isEqualToString:@"bottom"]) {
            return self.xAxisModel.bottomXAxisInfo;
        } else if ([position isEqualToString:@"right"]) {
            return self.yAxisModel.rightYAxisInfo;
        };
        return nil;
    };
}

- (BOOL)isKLineAxis {
    return [self.superlayer isKindOfClass:NSClassFromString(@"HyChartKLineAxisLayer")];
}

- (HyChartAxisModel *(^)(NSString *axisType))axisModel {
    return ^HyChartAxisModel *(NSString *axisType){
        if ([axisType isEqualToString:@"x"] ||
            [axisType isEqualToString:@"top"] ||
            [axisType isEqualToString:@"bottom"]) {
            return self.xAxisModel;
        } else if ([axisType isEqualToString:@"y"] ||
                   [axisType isEqualToString:@"left"] ||
                   [axisType isEqualToString:@"right"]) {
            return self.yAxisModel;
        }
        return nil;
    };
}

- (BOOL)axisLineDisabledWithPosition:(NSString *)position {
    HyChartAxisModel *axisModel = self.axisModel(position);
    if ([position isEqualToString:@"top"]) {
        return ((id<HyChartXAxisModelProtocol>)axisModel).topXaxisDisabled;
    } else if ([position isEqualToString:@"left"]) {
        return ((id<HyChartYAxisModelProtocol>)axisModel).leftYAxisDisabled;
    } else if ([position isEqualToString:@"bottom"]) {
        return ((id<HyChartXAxisModelProtocol>)axisModel).bottomXaxisDisabled;
    } else if ([position isEqualToString:@"right"]) {
        return ((id<HyChartYAxisModelProtocol>)axisModel).rightYAaxisDisabled;
    }
    return NO;
}

- (CGRect)contentRect {
    return CGRectMake(self.contentEdgeInsets.left, self.contentEdgeInsets.top, self.bounds.size.width - (self.contentEdgeInsets.left + self.contentEdgeInsets.right), self.bounds.size.height - (self.contentEdgeInsets.top + self.contentEdgeInsets.bottom));
}

@end
