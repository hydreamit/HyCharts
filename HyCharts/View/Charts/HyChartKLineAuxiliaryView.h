//
//  HyChartKLineAuxiliaryView.h
//  DemoCode
//
//  Created by Hy on 2018/4/1.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartView.h"
#import "HyChartsTypedef.h"
#import "HyChartKLineDataSourceProtocol.h"


NS_ASSUME_NONNULL_BEGIN

/// K线辅助图
@interface HyChartKLineAuxiliaryView : HyChartView<id<HyChartKLineDataSourceProtocol>>


- (void)switchKLineAuxiliaryType:(HyChartKLineAuxiliaryType)type;


@end

NS_ASSUME_NONNULL_END
