//
//  HyChartsKLineDemoDataHandler.m
//  HyChartsDemo
//
//  Created by Hy on 2018/4/21.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartsKLineDemoDataHandler.h"

@implementation HyChartsKLineDemoDataHandler

+ (void)handleWithArray:(NSArray *)array
              dataSorce:(id<HyChartKLineDataSourceProtocol>)dataSorce {
    
    if (!array) { return;}
    
    [[dataSorce.modelDataSource configNumberOfItems:^NSInteger{
        return array.count;
    }] configModelForItemAtIndex:^(id<HyChartKLineModelProtocol>  _Nonnull model, NSInteger index) {
        
        NSDictionary *dict = array[index];
        model.closePrice = [NSNumber numberWithDouble:[dict[@"Closed"] doubleValue]];
        model.openPrice = [NSNumber numberWithDouble:[dict[@"Opened"] doubleValue]];
        model.highPrice = [NSNumber numberWithDouble:[dict[@"Highest"] doubleValue]];
        model.lowPrice = [NSNumber numberWithDouble:[dict[@"Lowest"] doubleValue]];
        model.volume = [NSNumber numberWithDouble:[dict[@"DNum"] doubleValue]];
        
        model.trendPercent = [NSNumber numberWithFloat:[dict[@"Rose"] floatValue]];
        model.trendChanging = [NSNumber numberWithFloat:[dict[@"Rise"] floatValue]];

        time_t timeInterval = [dict[@"Timestamp"] doubleValue];
        struct tm *cTime = localtime(&timeInterval);
        NSString *string = [NSString stringWithFormat:@"%02d-%02d %02d:%02d", cTime->tm_mon + 1, cTime->tm_mday, cTime->tm_hour, cTime->tm_min];
        model.text = string;
        
        model.time = [NSString stringWithFormat:@"%02d-%@", cTime->tm_year + 1900, string];
    }];
}

@end
