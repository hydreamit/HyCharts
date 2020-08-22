//
//  HyChartModel.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/17.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartModel.h"


@interface HyChartModel ()
@property (nonatomic,weak) id<HyChartValuePositonProviderProtocol> provider;
@end


@implementation HyChartModel
@synthesize text = _text, exData = _exData, numberFormatter = _numberFormatter, breakingPoint = _breakingPoint, ignorePoint = _ignorePoint;

- (CGFloat (^)(NSNumber * _Nonnull))valuePositon {
    return self.provider.valuePositon;
}

- (CGFloat (^)(NSNumber * _Nonnull))valueHeight {
    return self.provider.valueHeight;
}

- (void)setValuePositonProvider:(id<HyChartValuePositonProviderProtocol>)provider {
    self.provider = provider;
}

- (void)handleModel {}

@end
