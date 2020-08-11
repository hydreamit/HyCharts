//
//  HyChartAxisModel.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/20.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartAxisModelProtocol.h"
#import "HyChartAxisGridLineInfo.h"


NS_ASSUME_NONNULL_BEGIN

@interface HyChartAxisModel : NSObject<HyChartAxisModelProtocol>

@property (nonatomic, assign, readonly) NSInteger indexs;

@property (nonatomic, strong, readonly) HyChartAxisGridLineInfo *axisGridLineInfo;

@end

NS_ASSUME_NONNULL_END
