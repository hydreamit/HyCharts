//
//  HyChartsKLineDemoDataHandler.m
//  HyChartsDemo
//
//  Created by Hy on 2018/4/21.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartsKLineDemoDataHandler.h"
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <HyCategoriess/HyCategories.h>
#import "HyChartsMethods.h"


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
        
//        if (index == 10 || index == 20) {
//            model.breakpoints = @[@YES];
//        }
        
        // 分时图线值 默认是@[model.closePrice]
//        model.values = @[model.closePrice, model.openPrice];
//        [model configTimeLineValues:^(id<HyChartKLineModelProtocol>  _Nonnull _model) {
//            _model.values = @[_model.closePrice, _model.openPrice];
//        }];
    }];
}

+ (CALayer *)technicalLayerWithDataSorce:(id<HyChartKLineDataSourceProtocol>)dataSorce {
    
    if (!dataSorce.modelDataSource.models.count) {
        return nil;
    }
    
    HyChartKLineTechnicalType type = dataSorce.modelDataSource.klineMianTechnicalType;
    if (type == HyChartKLineTechnicalTypeBOLL) {
        return nil;
    }
    
    CALayer *layer = CALayer.layer;
    id<HyChartKLineConfigureProtocol> configure = dataSorce.configreDataSource.configure;
    NSArray<NSNumber *> *allKes;
    switch (type) {
       case HyChartKLineTechnicalTypeSMA:{
           allKes = configure.smaDict.allKeys;
        }break;
        case HyChartKLineTechnicalTypeEMA:{
            allKes = configure.emaDict.allKeys;
        }break;
        default:
        break;
    }
    allKes =
    [allKes sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        if (obj1.integerValue < obj2.integerValue) {
            return NSOrderedAscending;
        } else if (obj1.integerValue > obj2.integerValue) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
   
    CGFloat left = 5;
    CGFloat height = 0;
    UIFont *font = [UIFont systemFontOfSize:12];
    for (NSNumber *number in allKes) {
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.masksToBounds = YES;
       
        textLayer.font = (__bridge CTFontRef)font;
        textLayer.fontSize = font.pointSize;
        textLayer.foregroundColor = configure.smaDict[number].CGColor;
        textLayer.contentsScale = UIScreen.mainScreen.scale;
        textLayer.alignmentMode = kCAAlignmentCenter;
        [layer addSublayer:textLayer];
        
        NSString *title;
        switch (type) {
            case HyChartKLineTechnicalTypeSMA:{
                title =
                [dataSorce.modelDataSource.priceNunmberFormatter stringFromNumber:dataSorce.modelDataSource.models.firstObject.priceSMA(number.integerValue)];
                title = [NSString stringWithFormat:@"MA%@: %@", number, title];
            }break;
            case HyChartKLineTechnicalTypeEMA:{
                title =
                [dataSorce.modelDataSource.priceNunmberFormatter stringFromNumber:dataSorce.modelDataSource.models.firstObject.priceEMA(number.integerValue)];
                title = [NSString stringWithFormat:@"EMA%@: %@", number, title];
            }break;
            default:
            break;
        }

        textLayer.string = title;
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName : font}];
        
        textLayer.frame = CGRectMake(left, 0, size.width, size.height);
        left = left + size.width + 10;
        
        height = size.height;
    }
    
    layer.frame = CGRectMake(0, 0, left, height);

    return layer;
}


+ (CALayer *)volumTechnicalLayerWithDataSorce:(id<HyChartKLineDataSourceProtocol>)dataSorce {
    
    if (!dataSorce.modelDataSource.models.count) {
        return nil;
    }
    
    HyChartKLineTechnicalType type = dataSorce.modelDataSource.klineVolumeTechnicalType;
    if (type == HyChartKLineTechnicalTypeBOLL) {
        return nil;
    }
    
    CALayer *layer = CALayer.layer;
    
    id<HyChartKLineConfigureProtocol> configure = dataSorce.configreDataSource.configure;
    NSArray<NSNumber *> *allKes;
    switch (type) {
       case HyChartKLineTechnicalTypeSMA:{
           allKes = configure.smaDict.allKeys;
        }break;
        case HyChartKLineTechnicalTypeEMA:{
            allKes = configure.emaDict.allKeys;
        }break;
        default:
        break;
    }
    allKes =
    [allKes sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        if (obj1.integerValue < obj2.integerValue) {
            return NSOrderedAscending;
        } else if (obj1.integerValue > obj2.integerValue) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
   
    CGFloat left = 5;
    CGFloat height = 0;
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.masksToBounds = YES;
    textLayer.font = (__bridge CTFontRef)configure.newpriceFont;
    textLayer.fontSize = configure.newpriceFont.pointSize;
    textLayer.foregroundColor = [UIColor grayColor].CGColor;
    textLayer.contentsScale = UIScreen.mainScreen.scale;
    textLayer.alignmentMode = kCAAlignmentCenter;
    [layer addSublayer:textLayer];
    
    textLayer.string = [NSString stringWithFormat:@"VOL: %@", SafetyString([dataSorce.modelDataSource.volumeNunmberFormatter stringFromNumber:dataSorce.modelDataSource.models.firstObject.volume])];
    CGSize size = [textLayer.string  sizeWithAttributes:@{NSFontAttributeName : configure.newpriceFont}];
    textLayer.frame = CGRectMake(left, 0, size.width, size.height);
    left = left + size.width + 10;
    
    for (NSNumber *number in allKes) {
        if (layer.sublayers.count > 2) {
            break;
        }
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.masksToBounds = YES;
        textLayer.font = (__bridge CTFontRef)configure.newpriceFont;
        textLayer.fontSize = configure.newpriceFont.pointSize;
        textLayer.foregroundColor = configure.smaDict[number].CGColor;
        textLayer.contentsScale = UIScreen.mainScreen.scale;
        textLayer.alignmentMode = kCAAlignmentCenter;
        [layer addSublayer:textLayer];
        
        NSString *title;
        switch (type) {
            case HyChartKLineTechnicalTypeSMA:{
                title =
                [dataSorce.modelDataSource.priceNunmberFormatter stringFromNumber:dataSorce.modelDataSource.models.firstObject.priceSMA(number.integerValue)];
                title = [NSString stringWithFormat:@"MA%@: %@", number, title];
            }break;
            case HyChartKLineTechnicalTypeEMA:{
                title =
                [dataSorce.modelDataSource.priceNunmberFormatter stringFromNumber:dataSorce.modelDataSource.models.firstObject.priceEMA(number.integerValue)];
                title = [NSString stringWithFormat:@"EMA%@: %@", number, title];
            }break;
            default:
            break;
        }

        textLayer.string = title;
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName : configure.newpriceFont}];
        
        textLayer.frame = CGRectMake(left, 0, size.width, size.height);
        left = left + size.width + 10;
        
        height = size.height;
    }
    
    layer.frame = CGRectMake(0, 0, left, height);

    return layer;
}

+ (CALayer *)auxiliaryLayerWithDataSorce:(id<HyChartKLineDataSourceProtocol>)dataSorce {
    
    if (!dataSorce.modelDataSource.models.count) {
        return nil;
    }

    CALayer *layer = CALayer.layer;

    id<HyChartKLineConfigureProtocol> configure = dataSorce.configreDataSource.configure;
    HyChartKLineAuxiliaryType type = dataSorce.modelDataSource.auxiliaryType;
    __block NSString *string = @"";
    switch (type) {
       case HyChartKLineAuxiliaryTypeMACD:{
           NSArray<NSNumber *> *numbers = configure.macdDict.allKeys.firstObject;
           string = [NSString stringWithFormat:@"MACD(%@,%@,%@)", numbers.firstObject, numbers[1], numbers.lastObject];
        }break;
        case HyChartKLineAuxiliaryTypeKDJ:{
           NSArray<NSNumber *> *numbers = configure.kdjDict.allKeys.firstObject;
            string = [NSString stringWithFormat:@"KJD(%@,%@,%@)", numbers.firstObject, numbers[1], numbers.lastObject];
        }break;
        case HyChartKLineAuxiliaryTypeRSI:{
            
            [configure.rsiDict.allKeys enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *str = [NSString stringWithFormat:@"RSI(%@): %@", obj, [dataSorce.modelDataSource.priceNunmberFormatter stringFromNumber:dataSorce.modelDataSource.models.firstObject.priceRSI([obj integerValue])]];
               string = [NSString stringWithFormat:@"%@   %@",string , str];
            }];
        }break;
        default:
        break;
    }

      
    CGFloat left = 5;
    CGFloat height = 0;
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.masksToBounds = YES;
    textLayer.font = (__bridge CTFontRef)configure.newpriceFont;
    textLayer.fontSize = configure.newpriceFont.pointSize;
    textLayer.foregroundColor = UIColor.grayColor.CGColor;
    textLayer.contentsScale = UIScreen.mainScreen.scale;
    textLayer.alignmentMode = kCAAlignmentCenter;
    [layer addSublayer:textLayer];
    
    textLayer.string = string;
    CGSize size = [textLayer.string  sizeWithAttributes:@{NSFontAttributeName : configure.newpriceFont}];
    textLayer.frame = CGRectMake(left, 0, size.width, size.height);
    left = left + size.width + 10;
    height = size.height;
    
    if (type != HyChartKLineAuxiliaryTypeRSI) {
        
        NSArray<NSString *> *titleArray = @[@"MACD: ", @"DIF: ", @"DEA: "];
        NSArray *numberArray = configure.macdDict.allKeys.firstObject;
        NSArray<UIColor *> *colorArray = configure.macdDict.allValues.firstObject;
        if (type == HyChartKLineAuxiliaryTypeKDJ) {
            titleArray = @[@"K: ", @"D: ", @"J: "];
            numberArray = configure.kdjDict.allKeys.firstObject;
            colorArray = configure.kdjDict.allValues.firstObject;
        }
        
        id<HyChartKLineModelProtocol> model = dataSorce.modelDataSource.models.firstObject;
        for (NSInteger i = 0; i < 3; i++) {
            
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.masksToBounds = YES;
            textLayer.font = (__bridge CTFontRef)configure.newpriceFont;
            textLayer.fontSize = configure.newpriceFont.pointSize;
            textLayer.foregroundColor = colorArray[i].CGColor;
            textLayer.contentsScale = UIScreen.mainScreen.scale;
            textLayer.alignmentMode = kCAAlignmentCenter;
            [layer addSublayer:textLayer];
            
            NSNumber *number;
            if (type == HyChartKLineAuxiliaryTypeMACD) {
                if (i == 0) {
                    number =  model.priceMACD([numberArray.firstObject integerValue], [numberArray[1] integerValue], [numberArray.lastObject integerValue]);
                } else if (i == 1) {
                    number =  model.priceDIF([numberArray.firstObject integerValue], [numberArray[1] integerValue]);
                } else {
                    number =  model.priceDEM([numberArray.firstObject integerValue], [numberArray[1] integerValue], [numberArray.lastObject integerValue]);
                }
            } else {
                if (i == 0) {
                    number =  model.priceK([numberArray.firstObject integerValue], [numberArray[1] integerValue]);
                } else if (i == 1) {
                    number =  model.priceD([numberArray.firstObject integerValue], [numberArray[1] integerValue], [numberArray.lastObject integerValue]);
                } else {
                    number =  model.priceJ([numberArray.firstObject integerValue], [numberArray[1] integerValue], [numberArray.lastObject integerValue]);
                }
            }

            NSString *title = [NSString stringWithFormat:@"%@%@", titleArray[i], [dataSorce.modelDataSource.priceNunmberFormatter stringFromNumber:number]];
            
            textLayer.string = title;
            CGSize size = [title sizeWithAttributes:@{NSFontAttributeName : configure.newpriceFont}];
            textLayer.frame = CGRectMake(left, 0, size.width, size.height);
            left = left + size.width + 10;
        }
    }
   layer.frame = CGRectMake(0, 0, left, height);
   return layer;
}

@end
