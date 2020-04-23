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
#import "HyChartKLineModelProtocol.h"
#import "HyChartKLineDataSourceProtocol.h"
#import "HyChartKLineDataSource.h"
#import "HyChartView.h"
#import <UIKit/UIKit.h>


@interface HyChartCursor ()
@property (nonatomic, strong) CATextLayer *xTextLayer;
@property (nonatomic, strong) CATextLayer *yTextLayer;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) CAShapeLayer *dotLayer;
@property (nonatomic, strong) CALayer *klineContentLayer;
@property (nonatomic, strong) id<HyChartCursorConfigureProtocol> configure;
@end


@implementation HyChartCursor
- (BOOL)isShowing {
    return self.sublayers.count;
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
        
        [self dismiss];
        
        [self addSublayer:self.lineLayer];
        [self addSublayer:self.dotLayer];
        [self addSublayer:self.xTextLayer];
        [self addSublayer:self.yTextLayer];
        if ([chartView isKindOfClass:NSClassFromString(@"HyChartKLineView")] ||
            [chartView isKindOfClass:NSClassFromString(@"HyChartKLineMainView")]) {
            [self createKLineContentLayer:centerPoint model:(id)model chartView:chartView];
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
         [path moveToPoint:startX];
         [path addLineToPoint:endX];
         [path moveToPoint:startY];
         [path addLineToPoint:endY];
         
         CGRect dotRect = CGRectMake(centerPoint.x - (self.configure.cursorPointSize.width) / 2, centerPoint.y - (self.configure.cursorPointSize.height) / 2, self.configure.cursorPointSize.width, self.configure.cursorPointSize.height);
         UIBezierPath *dotPath = [UIBezierPath bezierPathWithOvalInRect:dotRect];
        
         self.xTextLayer.string = xText;
         self.yTextLayer.string = yText;
        
        TransactionDisableActions(^{
            self.dotLayer.path = dotPath.CGPath;
            self.lineLayer.path = path.CGPath;
            self.xTextLayer.frame = xRect;
            self.yTextLayer.frame = yRect;
        });
    };
}

- (void)dismiss {
    [self.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

- (CAShapeLayer *)dotLayer {
    if (!_dotLayer){
        _dotLayer = [CAShapeLayer layer];
        _dotLayer.fillColor = self.configure.cursorPointColor.CGColor;
        _dotLayer.masksToBounds = YES;
        _dotLayer.frame = self.bounds;
        _dotLayer.zPosition = 999;
    }
    return _dotLayer;
}

- (CAShapeLayer *)lineLayer {
    if (!_lineLayer){
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.strokeColor = self.configure.cursorLineColor.CGColor;
        _lineLayer.lineWidth = self.configure.cursorLineWidth;
        _lineLayer.fillColor = UIColor.clearColor.CGColor;
        _lineLayer.lineCap = kCALineCapRound;
        _lineLayer.lineJoin = kCALineCapRound;
        _lineLayer.masksToBounds = YES;
        _lineLayer.frame = self.bounds;
    }
    return _lineLayer;
}

- (CATextLayer *)xTextLayer {
    if (!_xTextLayer){
        _xTextLayer = self.textLayer;
        _xTextLayer.borderWidth = 1;
        _xTextLayer.borderColor = self.configure.cursorTextColor.CGColor;
    }
    return _xTextLayer;
}

- (CATextLayer *)yTextLayer {
    if (!_yTextLayer){
        _yTextLayer = self.textLayer;
        _yTextLayer.borderWidth = 1;
        _yTextLayer.borderColor = self.configure.cursorTextColor.CGColor;
    }
    return _yTextLayer;
}

- (CATextLayer *)textLayer {
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.masksToBounds = YES;
    textLayer.font = (__bridge CTFontRef)self.configure.cursorTextFont;
    textLayer.fontSize = self.configure.cursorTextFont.pointSize;
    textLayer.foregroundColor = self.configure.cursorTextColor.CGColor;
    textLayer.contentsScale = UIScreen.mainScreen.scale;
    textLayer.alignmentMode = kCAAlignmentCenter;
    return textLayer;
}

- (void)createKLineContentLayer:(CGPoint)point
                          model:(id<HyChartKLineModelProtocol>)model
                      chartView:(HyChartView<id<HyChartKLineDataSourceProtocol>> *)chartView{
    
    if (self.klineContentLayer.superlayer) {
        return;
    }
    
    CALayer *layer = CALayer.layer;
    layer.backgroundColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.75].CGColor;
    layer.cornerRadius = 3;
    layer.borderWidth = 1.0;
    layer.borderColor = [UIColor colorWithWhite:1 alpha:.65].CGColor;
    layer.zPosition = 999;
    
    [self addSublayer:layer];
    
    self.klineContentLayer = layer;
    
    CGFloat width = 160;
    NSArray<NSString *> *leftTitleArray = @[@"时间 ", @"开 ", @"高 ", @"低 ", @"收 ", @"涨跌额", @"涨跌幅", @"成交量"];
    NSArray<NSString *> *rightTitleArray = @[model.time,
                                             [model.priceNunmberFormatter stringFromNumber:model.openPrice],
                                             [model.priceNunmberFormatter stringFromNumber:model.highPrice],
                                             [model.priceNunmberFormatter stringFromNumber:model.lowPrice],
                                             [model.priceNunmberFormatter stringFromNumber:model.closePrice],
                                             [model.priceNunmberFormatter stringFromNumber:model.trendChanging],
                                             [NSString stringWithFormat:@"%.2f%@", model.trendPercent.floatValue * 100, @"%"],
                                             [model.volumeNunmberFormatter stringFromNumber:model.volume]];
    
    UIColor *trendColor = UIColor.whiteColor;
    if (model.trend == HyChartKLineTrendUp) {
        trendColor = chartView.dataSource.configreDataSource.configure.trendUpColor;
    }
    if (model.trend == HyChartKLineTrendDown) {
        trendColor = chartView.dataSource.configreDataSource.configure.trendDownColor;
    }
    
    CGFloat top = 5, left = 5;
    for (NSString *title in leftTitleArray) {
        
        NSInteger index = [leftTitleArray indexOfObject:title];
        
        CATextLayer *leftTextLayer = self.textLayer;
        leftTextLayer.foregroundColor = UIColor.whiteColor.CGColor;
        leftTextLayer.string = title;
        [layer addSublayer:leftTextLayer];
        CGSize leftSize = [title sizeWithAttributes:@{NSFontAttributeName : (__bridge UIFont *)leftTextLayer.font}];
        leftTextLayer.frame = CGRectMake(left, top, leftSize.width, leftSize.height);
        
        CATextLayer *rightTextLayer = self.textLayer;
        rightTextLayer.foregroundColor = UIColor.whiteColor.CGColor;
        rightTextLayer.string = rightTitleArray[index];
        [layer addSublayer:rightTextLayer];
        CGSize rightSize = [rightTextLayer.string sizeWithAttributes:@{NSFontAttributeName : (__bridge UIFont *)leftTextLayer.font}];
        rightTextLayer.frame = CGRectMake(width - rightSize.width - left, top, rightSize.width, rightSize.height);
        
        top = (leftSize.height + top + 5);
        
        if (index == 5 || index == 6) {
            rightTextLayer.foregroundColor = trendColor.CGColor;
        }
    }
    
    CGFloat x, y;
    if (point.x < CGRectGetWidth(self.bounds) / 2) {
        x = point.x + 5;
    } else {
        x = point.x - width - 5;
    }
    y = point.y - top - 5;
    if (y < 20) {
        y = point.y + 5;
    }
    layer.frame = CGRectMake(x, y, width, top);
}

@end
