//
//  HyChartsKLineDemoCursor.m
//  HyChartsDemo
//
//  Created by Hy on 2018/4/22.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartsKLineDemoCursor.h"
#import "HyChartCursor.h"
#import <HyCategoriess/HyCategories.h>


@interface HyChartsKLineDemoCursor ()
@property (nonatomic,strong) HyChartCursor *chartCursour ;
@end


@implementation HyChartsKLineDemoCursor
- (HyChartCursor *)chartCursour {
    if (!_chartCursour){
        _chartCursour = [HyChartCursor chartCursorWithLayer:self.showView.layer];
        _chartCursour.configure.cursorLineColor = UIColor.grayColor;
        _chartCursour.configure.cursorPointColor = UIColor.grayColor;
        _chartCursour.configure.cursorTextColor = Hy_ColorWithRGB(53, 117, 249);
        _chartCursour.configure.cursorTextFont = [UIFont systemFontOfSize:12];
        _chartCursour.frame = self.showView.layer.bounds;
    }
    return _chartCursour;
}

- (void(^)(CGPoint point, NSString *xText, NSString *yText, id<HyChartModelProtocol> model, HyChartView *chartView))show {
    return ^(CGPoint point, NSString *xText, NSString *yText, id<HyChartModelProtocol> model, HyChartView *chartView) {
        if (point.y < CGRectGetMaxY(chartView.frame)) {
            [self dismiss];
            [self.showView.layer addSublayer:self.chartCursour];
            self.chartCursour.show(point, xText, yText, model, chartView);
        }
    };
}

- (void)dismiss {
    [self.chartCursour dismiss];
    [self.chartCursour removeFromSuperlayer];
}

- (BOOL)isShowing {
    return self.chartCursour.superlayer;
}

@end
