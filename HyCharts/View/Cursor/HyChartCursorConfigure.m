//
//  HyChartCursor.m
//  DemoCode
//
//  Created by Hy on 2018/4/1.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartCursorConfigure.h"

@implementation HyChartCursorConfigure
@synthesize cursorLineWidth = _cursorLineWidth, cursorPointSize = _cursorPointSize, cursorPointColor = _cursorPointColor, cursorLineColor = _cursorLineColor, cursorTextColor = _cursorTextColor, cursorTextFont = _cursorTextFont;

- (instancetype)init {
    if (self = [super init]) {
        _cursorLineWidth = .5;
        _cursorLineColor = UIColor.whiteColor;
        _cursorPointSize = CGSizeMake(6, 6);
        _cursorTextColor = UIColor.whiteColor;
        _cursorTextFont = [UIFont systemFontOfSize:12];
        _cursorPointColor = UIColor.whiteColor;
    }return self;
}

@end
