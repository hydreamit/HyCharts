//
//  HyChartCursor.m
//  DemoCode
//
//  Created by Hy on 2018/4/1.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartCursor.h"
#import <CoreText/CoreText.h>
#import "HyChartCursorConfigure.h"
#import "HyChartsMethods.h"


@interface HyChartCursor ()
@property (nonatomic,assign) BOOL showing;
@property (nonatomic,strong) CATextLayer *xTextLayer;
@property (nonatomic,strong) CATextLayer *yTextLayer;
@property (nonatomic,strong) CAShapeLayer *layer;
@property (nonatomic,strong) CAShapeLayer *dotLayer;
@property (nonatomic,strong) id<HyChartCursorConfigureProtocol> configure;
@end


@implementation HyChartCursor
- (BOOL)isShowing {
    return self.showing;
}

+ (instancetype)chartCursorWithLayer:(CALayer *)layer {
    HyChartCursor *cursor = [self layer];
    cursor.configure = HyChartCursorConfigure.new;
    [layer addSublayer:cursor];
    cursor.zPosition = 999;
    return cursor;
}

- (void (^)(CGPoint, NSString * _Nonnull, NSString * _Nonnull, id<HyChartModelProtocol> _Nonnull, HyChartView *))show {
    return ^(CGPoint centerPoint, NSString *xText, NSString *yText, id<HyChartModelProtocol> model, HyChartView *chartView){
        
        self.showing = YES;
         
         if (!self.xTextLayer.superlayer) {
            [self.layer addSublayer:self.xTextLayer];
         }
         if (!self.yTextLayer.superlayer) {
            [self.layer addSublayer:self.yTextLayer];
         }
               
         CGSize xSize = [xText sizeWithAttributes:@{NSFontAttributeName : self.configure.cursorTextFont}];
         xSize = CGSizeMake(xSize.width + 6, xSize.height);
         CGRect xRect = CGRectMake(centerPoint.x - xSize.width / 2 , CGRectGetHeight(self.bounds) - xSize.height , xSize.width, xSize.height);
         CGSize ySize = [yText sizeWithAttributes:@{NSFontAttributeName : self.configure.cursorTextFont}];
          ySize = CGSizeMake(ySize.width + 6, ySize.height);
         CGRect yRect = CGRectMake(centerPoint.x - ySize.width / 2 , CGRectGetMinY(self.bounds) , ySize.width, ySize.height);
         
         UIBezierPath *path = UIBezierPath.bezierPath;
         CGPoint startX = CGPointMake(centerPoint.x, CGRectGetMinY(self.bounds)+ xSize.height);
         CGPoint endX = CGPointMake(centerPoint.x, CGRectGetMaxY(self.bounds) - ySize.height);
         CGPoint startY = CGPointMake(CGRectGetMinX(self.bounds), centerPoint.y);
         CGPoint endY = CGPointMake(CGRectGetMaxX(self.bounds), centerPoint.y);
         [path moveToPoint:[self convertPoint:startX toLayer:self.layer]];
         [path addLineToPoint:[self convertPoint:endX toLayer:self.layer]];
         [path moveToPoint:[self convertPoint:startY toLayer:self.layer]];
         [path addLineToPoint:[self convertPoint:endY toLayer:self.layer]];
         
         CGRect dotRect = CGRectMake(centerPoint.x - (self.configure.cursorPointSize.width) / 2, centerPoint.y - (self.configure.cursorPointSize.height) / 2, self.configure.cursorPointSize.width, self.configure.cursorPointSize.height);
         UIBezierPath *dotPath = [UIBezierPath bezierPathWithOvalInRect:dotRect];
        
         self.xTextLayer.string = xText;
         self.yTextLayer.string = yText;
        
        CATransactionDisableActions(^{
            self.dotLayer.path = dotPath.CGPath;
            self.layer.path = path.CGPath;
            self.xTextLayer.frame = xRect;
            self.yTextLayer.frame = yRect;
        });
    };
}

- (void)dismiss {
    
    self.dotLayer.path = UIBezierPath.bezierPath.CGPath;
    self.layer.path = UIBezierPath.bezierPath.CGPath;
    [self.xTextLayer removeFromSuperlayer];
    [self.yTextLayer removeFromSuperlayer];
    self.showing = NO;
}

- (CAShapeLayer *)layer {
    if (!_layer){
        _layer = [CAShapeLayer layer];
        _layer.strokeColor = self.configure.cursorLineColor.CGColor;
        _layer.lineWidth = self.configure.cursorLineWidth;
        _layer.fillColor = UIColor.clearColor.CGColor;
        _layer.lineCap = kCALineCapRound;
        _layer.lineJoin = kCALineCapRound;
        _layer.masksToBounds = YES;
        _layer.frame = self.bounds;
        [self addSublayer:_layer];
    }
    return _layer;
}

- (CATextLayer *)xTextLayer {
    if (!_xTextLayer){
        _xTextLayer = [CATextLayer layer];
        _xTextLayer.masksToBounds = YES;
        _xTextLayer.font = (__bridge CTFontRef)self.configure.cursorTextFont;
        _xTextLayer.fontSize = self.configure.cursorTextFont.pointSize;
        _xTextLayer.foregroundColor = self.configure.cursorTextColor.CGColor;
        _xTextLayer.contentsScale = UIScreen.mainScreen.scale;
        _xTextLayer.alignmentMode = kCAAlignmentCenter;
        _xTextLayer.borderWidth = 1;
        _xTextLayer.borderColor = self.configure.cursorTextColor.CGColor;
    }
    return _xTextLayer;
}

- (CATextLayer *)yTextLayer {
    if (!_yTextLayer){
        _yTextLayer = [CATextLayer layer];
        _yTextLayer.masksToBounds = YES;
        _yTextLayer.font = (__bridge CTFontRef)self.configure.cursorTextFont;
        _yTextLayer.fontSize = self.configure.cursorTextFont.pointSize;
        _yTextLayer.foregroundColor = self.configure.cursorTextColor.CGColor;
        _yTextLayer.contentsScale = UIScreen.mainScreen.scale;
        _yTextLayer.alignmentMode = kCAAlignmentCenter;
        _yTextLayer.borderWidth = 1;
        _yTextLayer.borderColor = self.configure.cursorTextColor.CGColor;
    }
    return _yTextLayer;
}

- (CAShapeLayer *)dotLayer {
    if (!_dotLayer){
        _dotLayer = [CAShapeLayer layer];
        _dotLayer.fillColor = self.configure.cursorPointColor.CGColor;
        _dotLayer.masksToBounds = YES;
        _dotLayer.frame = self.bounds;
        _dotLayer.zPosition = 999;
        [self addSublayer:_dotLayer];;
    }
    return _dotLayer;
}

@end
