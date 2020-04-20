//
//  HyChartBarModelDataSource.m
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartBarModelDataSource.h"


@interface HyChartBarModelDataSource ()
@property (nonatomic, copy) void (^modelForItemAtIndexBlock)(id<HyChartBarModelProtocol> model, NSInteger index);
@end


@implementation HyChartBarModelDataSource
@synthesize  visibleModels = _visibleModels, visibleXAxisModels = _visibleXAxisModels, visibleMaxModel = _visibleMaxModel, visibleMinModel = _visibleMinModel, models = _models;

- (instancetype)configModelForItemAtIndex:(void (^_Nullable)(id<HyChartBarModelProtocol> model, NSInteger index))block {
    
    self.modelForItemAtIndexBlock = [block copy];
    return self;
}

- (NSArray<id<HyChartBarModelProtocol>> *)models {
    if (!_models){
        _models = @[].mutableCopy;
    }
    return _models;
}

@end
