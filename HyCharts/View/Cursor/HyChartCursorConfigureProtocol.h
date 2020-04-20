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

@property (nonatomic, assign) CGFloat cursorLineWidth;

@property (nonatomic, assign) CGSize cursorPointSize;

@property (nonatomic, strong) UIColor *cursorPointColor;

@property (nonatomic, strong) UIColor *cursorLineColor;

@property (nonatomic, strong) UIColor *cursorTextColor;

@property (nonatomic, strong) UIFont *cursorTextFont;

@end

NS_ASSUME_NONNULL_END
