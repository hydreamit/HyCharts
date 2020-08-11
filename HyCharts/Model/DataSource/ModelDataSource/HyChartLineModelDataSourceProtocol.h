//
//  HyChartLineModelDataSourceProtocol.h
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartLineModelProtocol.h"
#import "HyChartModelDataSourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyChartLineModelDataSourceProtocol <HyChartModelDataSourceProtocol>

- (instancetype)configModelForItemAtIndex:(void (^_Nullable)(id<HyChartLineModelProtocol> model, NSInteger index))block;

/// 模型数组
@property (nonatomic, strong, readonly) NSMutableArray<id<HyChartLineModelProtocol>> *models;
/// 可见跨度的模型数组
@property (nonatomic, strong, readonly) NSArray<id<HyChartLineModelProtocol>> *visibleModels;
/// 可见跨度的靠近X轴点的模型数组
@property (nonatomic, strong, readonly) NSArray<id<HyChartLineModelProtocol>> *visibleXAxisModels;
/// 可见最大值模型
@property (nonatomic, strong, readonly) id<HyChartLineModelProtocol> visibleMaxModel;
/// 可见最小值模型
@property (nonatomic, strong, readonly) id<HyChartLineModelProtocol> visibleMinModel;

@property (nonatomic, strong, readonly) NSNumberFormatter *numberFormatter;

@end

NS_ASSUME_NONNULL_END
