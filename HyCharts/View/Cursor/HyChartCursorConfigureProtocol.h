//
//  HyChartCursorProtocol.h
//  DemoCode
//
//  Created by Hy on 2018/4/1.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartModelProtocol.h"
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol HyChartCursorConfigureProtocol <NSObject>

/// 线宽
@property (nonatomic, assign) CGFloat cursorLineWidth;
/// 线条颜色
@property (nonatomic, strong) UIColor *cursorLineColor;
/// 游标中心圆点大小
@property (nonatomic, assign) CGSize cursorPointSize;
/// 游标中心圆点颜色
@property (nonatomic, strong) UIColor *cursorPointColor;
/// 游标文字颜色
@property (nonatomic, strong) UIColor *cursorTextColor;
/// 游标文字字体
@property (nonatomic, strong) UIFont *cursorTextFont;

@end

NS_ASSUME_NONNULL_END
