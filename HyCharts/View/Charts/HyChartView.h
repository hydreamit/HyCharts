//
//  HyChartView.h
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyChartViewProtocol.h"
#import "HyChartDataSourceProtocol.h"


NS_ASSUME_NONNULL_BEGIN


/// 抽象类 请使用子类视图
@interface HyChartView<__covariant DataSourceType : id<HyChartDataSourceProtocol>> : UIView<HyChartViewProtocol>

/*
 数据源:
 1. 配置坐标轴
 2. 配置图表信息
 3. 配置图表数据
 */
- (DataSourceType)dataSource;



@end


NS_ASSUME_NONNULL_END
