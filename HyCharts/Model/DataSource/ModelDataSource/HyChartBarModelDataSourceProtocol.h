//
//  HyChartBarModelDataSourceProtocol.h
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//


#import "HyChartBarModelProtocol.h"
#import "HyChartModelDataSourceProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyChartBarModelDataSourceProtocol <HyChartModelDataSourceProtocol>

- (instancetype)configModelForItemAtIndex:(void (^_Nullable)(id<HyChartBarModelProtocol> model, NSInteger index))block;

/// 模型数组
@property (nonatomic, strong,readonly) NSMutableArray<id<HyChartBarModelProtocol>> *models;
/// 可见跨度的模型数组
@property (nonatomic, strong,readonly) NSArray<id<HyChartBarModelProtocol>> *visibleModels;
/// 可见跨度的靠近X轴点的模型数组
@property (nonatomic, strong,readonly) NSArray<id<HyChartBarModelProtocol>> *visibleXAxisModels;
/// 可见最大值模型
@property (nonatomic, strong,readonly) id<HyChartBarModelProtocol> visibleMaxModel;
/// 可见最小值模型
@property (nonatomic, strong,readonly) id<HyChartBarModelProtocol> visibleMinModel;

@property (nonatomic, strong, readonly) NSNumberFormatter *numberFormatter;

@end

NS_ASSUME_NONNULL_END
