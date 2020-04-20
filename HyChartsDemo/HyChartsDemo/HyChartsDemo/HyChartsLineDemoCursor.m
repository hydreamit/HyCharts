//
//  HyChartsLineDemoCursor.m
//  DemoCode
//
//  Created by Hy on 2018/4/13.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartsLineDemoCursor.h"
#import <HyCategoriess/HyCategories.h>


@implementation HyChartsLineDemoCursor

- (void(^)(CGPoint point, NSString *xText, NSString *yText, id<HyChartModelProtocol> model, HyChartView *chartView))show {
    return ^(CGPoint point, NSString *xText, NSString *yText, id<HyChartModelProtocol> model, HyChartView *chartView) {
        
        [self dismiss];
        
        id<HyChartLineModelProtocol> chartLineModel = (id)model;
        UIEdgeInsets edgeInset = chartView.contentEdgeInsets;
               
        UIView *line = UIView.new;
        line.tag = 666;
        line.backgroundColor = UIColor.grayColor;
        line.alpha = .8;
        line.width = 1;
        line.top = 0;
        line.left = chartLineModel.visiblePosition + edgeInset.left;
        line.height = self.showView.height - edgeInset.bottom;
        [self.showView addSubview:line];
        
        UIView *contentView = [UIView new];
        contentView.backgroundColor = UIColor.blackColor;
        contentView.alpha = .8;
        contentView.tag = 999;
        contentView.layer.cornerRadius = 5.0;
        [self.showView addSubview:contentView];

        UILabel *titleL = UILabel.new;
        titleL.text = xText;
        titleL.textColor = UIColor.whiteColor;
        titleL.font = [UIFont systemFontOfSize:12];
        [contentView addSubview:titleL];
        [titleL sizeToFit];
        titleL.top = titleL.left = 5;

        UIView *lastView = titleL;
        CGFloat maxWidth = titleL.width;

        for (NSNumber *number in chartLineModel.values) {

            NSInteger index = [chartLineModel.values indexOfObject:number];

            UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            colorView.backgroundColor = (UIColor *)((NSArray *)chartLineModel.exData[@"colors"])[index];
            colorView.layer.cornerRadius = 2;
            [contentView addSubview:colorView];
            colorView.leftIsEqualTo(titleL);
            colorView.top = lastView.bottom + 3;

            NSString *text = @"";
            NSArray<NSString *> *texts = chartLineModel.exData[@"texts"];
            if (texts) {
                text = texts[index];
            }

            UILabel *tLable = UILabel.new;
            tLable.text = [NSString stringWithFormat:@"%@ %@",text, number];
            tLable.textColor = UIColor.whiteColor;
            tLable.font = [UIFont systemFontOfSize:10];
            [tLable sizeToFit];
            tLable.left = colorView.right + 3;
            tLable.centerYIsEqualTo(colorView);
            [contentView addSubview:tLable];

            maxWidth = MAX(maxWidth, tLable.right);
            lastView = colorView;
        }
        
        contentView.width = maxWidth + 5;
        contentView.height = lastView.bottom + 8;
        contentView.left = chartLineModel.visiblePosition + edgeInset.left + 1;
        CGFloat y = point.y;
        if (y + contentView.height > self.showView.height) {
            y = self.showView.height - contentView.height;
        }
        contentView.top = y;
    };
}

- (void)dismiss {
    [[self.showView viewWithTag:999] removeFromSuperview];
    [[self.showView viewWithTag:666] removeFromSuperview];
}

- (BOOL)isShowing {
    return [self.showView viewWithTag:999] ? YES : NO;
}

@end
