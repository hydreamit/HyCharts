//
//  HyChartModelDataSource.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartModelDataSource.h"


@interface HyChartModelDataSource ()
@property (nonatomic, copy) NSInteger(^numberOfItemsBlock)(void);
@property (nonatomic, copy) void (^modelForItemAtIndexBlock)(HyChartModel *model, NSInteger index);
@end


@implementation HyChartModelDataSource

- (instancetype)configNumberOfItems:(NSInteger(^)(void))block {
    self.numberOfItemsBlock = [block copy];
    return self;
}

- (instancetype)configModelForItemAtIndex:(void (^_Nullable)(id<HyChartModelProtocol> model, NSInteger index))block {
    self.modelForItemAtIndexBlock = [block copy];
    return self;
}

- (NSArray<HyChartModel *> *)models {
    if (!_models){
        _models = @[].mutableCopy;
    }
    return _models;
}

@end
