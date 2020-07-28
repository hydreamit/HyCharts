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
@synthesize text = _text, value = _value, index = _index, visibleIndex = _visibleIndex, position = _position, visiblePosition = _visiblePosition, exData = _exData, numberFormatter = _numberFormatter;

- (CGFloat (^)(NSNumber * _Nonnull))valuePositon {
    return self.provider.valuePositon;
}

- (CGFloat (^)(NSNumber * _Nonnull))valueHeight {
    return self.provider.valueHeight;
}

- (void)setValuePositonProvider:(id<HyChartValuePositonProviderProtocol>)provider {
    self.provider = provider;
}

@end
