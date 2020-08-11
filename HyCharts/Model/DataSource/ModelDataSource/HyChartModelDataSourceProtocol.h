//
//  HyChartModelDataSourceProtocol.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyChartModelProtocol.h"
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol HyChartModelDataSourceProtocol <NSObject>

- (instancetype)configNumberOfItems:(NSInteger(^)(void))block;

@end

NS_ASSUME_NONNULL_END
