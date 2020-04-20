//
//  HyChartModelDataSourceProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartModelProtocol.h"
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol HyChartModelDataSourceProtocol <NSObject>

- (instancetype)configNumberOfItems:(NSInteger(^)(void))block;
@property (nonatomic, copy, readonly) NSInteger(^numberOfItemsBlock)(void);

- (instancetype)configModelForItemAtIndex:(void (^_Nullable)(id<HyChartModelProtocol> model, NSInteger index))block;
- (void(^)(id<HyChartModelProtocol> model, NSInteger index))modelForItemAtIndexBlock;

@property (nonatomic, strong) NSMutableArray<id<HyChartModelProtocol>> *models;
@property (nonatomic, strong) NSArray<id<HyChartModelProtocol>> *visibleModels;
@property (nonatomic, strong) NSArray<id<HyChartModelProtocol>> *visibleXAxisModels;

@property (nonatomic, strong) NSNumber *maxValue;
@property (nonatomic, strong) NSNumber *minValue;


@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@end

NS_ASSUME_NONNULL_END
