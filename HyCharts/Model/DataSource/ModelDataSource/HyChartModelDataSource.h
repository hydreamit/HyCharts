//
//  HyChartModelDataSource.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartModelDataSourceProtocol.h"
#import "HyChartModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartModelDataSource<__covariant ModelType : HyChartModel *> : NSObject<HyChartModelDataSourceProtocol>

@property (nonatomic, copy, readonly) NSInteger(^numberOfItemsBlock)(void);
- (void(^)(ModelType, NSInteger index))modelForItemAtIndexBlock;

@property (nonatomic, strong) NSMutableArray<ModelType> *models;
@property (nonatomic, strong) NSArray<ModelType> *visibleModels;
@property (nonatomic, strong) NSArray<ModelType> *visibleXAxisModels;
@property (nonatomic, strong) ModelType visibleMaxModel;
@property (nonatomic, strong) ModelType visibleMinModel;
@property (nonatomic, assign) NSInteger visibleFromIndex;
@property (nonatomic, assign) NSInteger visibleToIndex;
@property (nonatomic, strong) NSNumber *maxValue;
@property (nonatomic, strong) NSNumber *minValue;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@end

NS_ASSUME_NONNULL_END
