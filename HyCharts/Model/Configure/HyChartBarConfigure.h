//
//  HyChartBarConfigure.h
//  DemoCode
//
//  Created by Hy on 2018/4/7.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartConfigure.h"
#import "HyChartBarConfigureProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyChartBarOneConfigure : NSObject<HyChartBarOneConfigureProtocol>
+ (instancetype)defaultConfigure;
@end

@interface HyChartBarConfigure : HyChartConfigure<HyChartBarConfigureProtocol>
@property (nonatomic, copy, readonly) void(^barConfigureAtIndexBlock)(NSInteger, id<HyChartBarOneConfigureProtocol>);
@end

NS_ASSUME_NONNULL_END
