//
//  HyChartBarConfigureProtocol.h
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartConfigureProtocol.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyChartBarOneConfigureProtocol <NSObject>
/// 线条颜色
@property (nonatomic, strong) UIColor *strokeColor;
/// 填充颜色
@property (nonatomic, strong) UIColor *fillColor;
/// 线宽度 默认1.0
@property (nonatomic, assign) CGFloat lineWidth;
/// 虚线模板起始位置
@property (nonatomic, assign) CGFloat lineDashPhase;
/// 虚线模板数组
@property (nonatomic, strong) NSArray<NSNumber *> *lineDashPattern;

@end


@protocol HyChartBarConfigureProtocol <HyChartConfigureProtocol>

- (instancetype)configBarConfigureAtIndex:(void(^)(NSInteger index, id<HyChartBarOneConfigureProtocol> oneConfigure))block;

@property (nonatomic, copy, readonly) void(^barConfigureAtIndexBlock)(NSInteger, id<HyChartBarOneConfigureProtocol>);

@end

NS_ASSUME_NONNULL_END
