//
//  HyChartAxisModelProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/20.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartAxisGridLineInfoProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyChartAxisModelProtocol <NSObject>

/// 设置总个数
- (instancetype)configNumberOfIndexs:(NSInteger)indexs;
/// 总个数
@property (nonatomic, assign, readonly) NSInteger indexs;


/// 设置网格数据
- (instancetype)configAxisGridLineInfo:(void(^)(id<HyChartAxisGridLineInfoProtocol> axisGridLineInfo))block;
/// 网格数据
@property (nonatomic, strong, readonly) id<HyChartAxisGridLineInfoProtocol> axisGridLineInfo;


@end

NS_ASSUME_NONNULL_END
