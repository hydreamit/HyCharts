//
//  HyChartLayer.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/20.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartLayer.h"


@interface HyChartLayer ()
@property (nonatomic, strong) id dataSource;
@end


@implementation HyChartLayer

+ (instancetype)layerWithDataSource:(id)dataSource {
    
    HyChartLayer *layer = [self layer];
    layer.backgroundColor = UIColor.clearColor.CGColor;
    layer.dataSource = dataSource;
    return layer;
}

- (void)setNeedsRendering {
    if (!self.dataSource) {
        return;
    }
}

- (CGFloat (^)(NSNumber * _Nonnull))valuePositon {
    return ^(NSNumber *value){
        CGFloat valuePositon = .0;
        return valuePositon;
    };
}

- (CGFloat (^)(NSNumber * _Nonnull))valueHeight {
    return ^(NSNumber *value){
        CGFloat valueHeight = .0;
        return valueHeight;
    };
}


@end
