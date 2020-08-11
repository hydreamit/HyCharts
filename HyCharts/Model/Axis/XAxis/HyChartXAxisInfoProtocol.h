//
//  HyChartXAxisInfoProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/20.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartAxisInfoProtocol.h"
#import "HyChartModelProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyChartXAxisInfoProtocol <HyChartAxisInfoProtocol>

/// 每个坐标点对应的内容 (NSString NSAttributedString)
- (instancetype)configTextAtIndex:(id(^)(NSInteger index, id<HyChartModelProtocol> model))block;

@end

NS_ASSUME_NONNULL_END
