//
//  HyChartLineConfigureDataSourceProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/26.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartLineConfigureProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyChartLineConfigureDataSourceProtocol <NSObject>

- (id<HyChartLineConfigureDataSourceProtocol>)configConfigure:(void (^_Nullable)(id<HyChartLineConfigureProtocol> configure))block;

@property (nonatomic, strong, readonly) id<HyChartLineConfigureProtocol> configure;

@end

NS_ASSUME_NONNULL_END
