//
//  HyChartXAxisInfo.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/20.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartXAxisInfo.h"


@interface HyChartXAxisInfo ()
@property (nonatomic, copy) id(^textAtIndexBlock)(NSInteger, id<HyChartModelProtocol>);
@end


@implementation HyChartXAxisInfo

- (instancetype)configTextAtIndex:(id(^)(NSInteger index, id<HyChartModelProtocol> model))block {
    self.textAtIndexBlock = [block copy];
    return self;
}

@end
