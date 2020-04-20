//
//  HyChartBarConfigureDataSourceProtocol.h
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartBarConfigureProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyChartBarConfigureDataSourceProtocol <NSObject>

- (id<HyChartBarConfigureDataSourceProtocol>)configConfigure:(void (^_Nullable)(id<HyChartBarConfigureProtocol> configure))block;

@property (nonatomic, strong, readonly) id<HyChartBarConfigureProtocol> configure;

@end

NS_ASSUME_NONNULL_END
