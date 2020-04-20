//
//  HyChartLineModelDataSource.m
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartLineModelDataSource.h"


@interface HyChartLineModelDataSource ()
@property (nonatomic, copy) void (^modelForItemAtIndexBlock)(id<HyChartLineModelProtocol> model, NSInteger index);
@end


@implementation HyChartLineModelDataSource
@synthesize  visibleModels = _visibleModels, visibleXAxisModels = _visibleXAxisModels, visibleMaxModel = _visibleMaxModel, visibleMinModel = _visibleMinModel, models = _models;

- (instancetype)configModelForItemAtIndex:(void (^_Nullable)(id<HyChartLineModelProtocol> model, NSInteger index))block {
    
    self.modelForItemAtIndexBlock = [block copy];
    return self;
}

- (NSArray<id<HyChartLineModelProtocol>> *)models {
    if (!_models){
        _models = @[].mutableCopy;
    }
    return _models;
}

@end
