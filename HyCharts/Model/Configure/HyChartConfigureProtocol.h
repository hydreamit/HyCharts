//
//  HyChartConfigureProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HyChartsTypedef.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyChartConfigureProtocol <NSObject>

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) BOOL autoMargin;
@property (nonatomic, assign) CGFloat edgeInsetStart;
@property (nonatomic, assign) CGFloat edgeInsetEnd;
@property (nonatomic, assign) HyChartDataDirection dataDirection;


@property (nonatomic, assign) CGFloat trans;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat maxScale;
@property (nonatomic, assign) CGFloat minScale;


@property (nonatomic, assign) NSInteger decimal;
@property (nonatomic, strong, readonly) NSNumberFormatter *numberFormatter;


/*
 缩放过后的数据
 */
@property (nonatomic, assign) CGFloat scaleWidth;
@property (nonatomic, assign) CGFloat scaleMargin;
@property (nonatomic, assign) CGFloat scaleItemWidth;
@property (nonatomic, assign) CGFloat scaleEdgeInsetStart;
@property (nonatomic, assign) CGFloat scaleEdgeInsetEnd;

@end



NS_ASSUME_NONNULL_END
