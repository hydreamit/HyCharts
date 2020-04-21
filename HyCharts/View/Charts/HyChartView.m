//
//  HyChartView.m
//  HyChartsDemo
//
//  Created by Hy on 2018/3/18.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartView.h"
#import "HyChartDataSource.h"
#import "HyChartAxisLayer.h"
#import "HyChartModel.h"
#import "HyChartLineLayer.h"
#import "HyChartKLineModelProtocol.h"
#import "HyChartAlgorithmContext.h"
#import "HyChartKLineConfigureProtocol.h"
#import "HyChartKLineModelDataSourceProtocol.h"
#import "HyChartsTypedef.h"
#import "HyChartCursor.h"
#import "HyChartsMethods.h"


@interface HyChartView ()<UIScrollViewDelegate>
/// 轴图层
@property (nonatomic,strong) HyChartAxisLayer *axisLayer;
/// 滚动偏移量
@property (nonatomic, strong) UIScrollView *scrollView;
/// 点击手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
/// 缩放手势
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
/// 长按手势
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) id<HyChartCursorProtocol> chartCursor;

@property (nonatomic, assign) CGFloat chartWidth;
@property (nonatomic, assign) CGFloat chartHeight;
@property (nonatomic, assign) CGFloat chartContentWidth;
@property (nonatomic, strong) id<HyChartConfigureProtocol> configure;
@property (nonatomic, assign) HyChartKLineTechnicalType technicalType;
@property (nonatomic, assign) HyChartKLineAuxiliaryType auxiliaryType;
@property (nonatomic, strong) NSMutableArray<NSValue *> *reactChains;
@property (nonatomic, assign, getter=isTimeLine) BOOL timeLine;
@property (nonatomic, assign, getter=isPinching) BOOL pinching;
@property (nonatomic, assign, getter=isReverseScrolling) BOOL reverseScrolling;
@property (nonatomic, assign) NSInteger prepareStage;
@property (nonatomic, strong) NSNumberFormatter *yAxisNunmberFormatter;
@property (nonatomic,strong) dispatch_semaphore_t semaphore;
@end


@implementation HyChartView
@synthesize contentEdgeInsets = _contentEdgeInsets, pinchGestureDisabled = _pinchGestureDisabled, tapGestureDisabled = _tapGestureDisabled, longPressGestureDisabled = _longPressGestureDisabled;

#pragma mark — lief cycle
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.superview && !self.scrollView.superview) {
        [self.layer addSublayer:self.axisLayer];
        [self.layer addSublayer:self.chartLayer];
        [self addSubview:self.scrollView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.axisLayer.frame = self.bounds;
    self.axisLayer.contentEdgeInsets = self.contentEdgeInsets;
    
    self.scrollView.frame =
    self.chartLayer.frame  = self.contentRect;
    if ([self.chartCursor isKindOfClass:HyChartCursor.class]) {
        ((HyChartCursor *)self.chartCursor).frame = self.contentRect;
    }
    self.chartWidth = self.contentRect.size.width;
    self.chartHeight = self.contentRect.size.height;
}

#pragma mark — public methods
- (void)configChartCursor:(void(^)(id<HyChartCursorConfigureProtocol> configure))block {
    if ([self.chartCursor isKindOfClass:HyChartCursor.class] && block) {
        block(((HyChartCursor *)self.chartCursor).configure);
    }
}

- (void)resetChartCursor:(id<HyChartCursorProtocol>)cursor {
    if (!cursor || [cursor conformsToProtocol:@protocol(HyChartCursorProtocol)]) {
        self.chartCursor = cursor;
    }
}

- (void(^)(CGPoint contentOffset, BOOL animated))scrollAction {
    return ^(CGPoint contentOffset, BOOL animated) {
        [self.scrollView setContentOffset:contentOffset animated:animated];
    };
}

- (void(^)(NSInteger, CGFloat, CGFloat))pinchAction {
    return ^(NSInteger index, CGFloat margin, CGFloat sca) {
        
        id<HyChartConfigureProtocol> configure = self.configure;
        
        CGFloat scale = configure.scale;
        CGFloat changeScale = sca - 1;
        if  (changeScale == 0 ||
            (changeScale > 0 && scale == configure.maxScale) ||
            (changeScale < 0 && scale == configure.minScale)) {
            return;
        }
                
        scale += changeScale;
        if (scale > configure.maxScale) {
            scale = configure.maxScale;
        } else if (scale < configure.minScale) {
            scale = configure.minScale;
        }
        self.dataSource.configreDataSource.configure.scale = scale;
                    
        [self handleContentSize];
        
        CGFloat changeOffset = 0;
        CGFloat contentOffset = self.chartContentWidth - self.chartWidth;
        if (contentOffset > 0) {
            CGFloat totalOffset = (configure.edgeInsetStart  + (configure.width + configure.margin) * index + configure.width / 2) * configure.scale;
            changeOffset = totalOffset - margin;
            if (changeOffset < 0) { changeOffset = 0;}
            if (changeOffset > contentOffset) {changeOffset = contentOffset;}
            
            configure.trans = changeOffset;
            if (self.configure.dataDirection == HyChartDataDirectionForward) {
                [self.scrollView setContentOffset:CGPointMake(changeOffset, 0) animated:NO];
            } else {
                [self.scrollView setContentOffset:CGPointMake(contentOffset - changeOffset, 0) animated:NO];
            }
        }
                
        [self asyncHandler:^{
            [self handleVisibleModels];
        } completion:^{
            [self.layer setNeedsDisplay];
        }];
    };
}

+ (void(^)(NSArray<HyChartView *> *chartViews))addReactChains {
    return ^(NSArray<HyChartView *> *chartViews) {
        [chartViews enumerateObjectsUsingBlock:^(HyChartView * _Nonnull chartView, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *mArray = @[].mutableCopy;
            for (HyChartView *chartV in chartViews) {
                if (chartV != chartView) {
                    [mArray addObject:chartV];
                }
            }
            chartView._addReactChains(mArray.copy);
        }];
    };
}

+ (void(^)(NSArray<HyChartView *> *chartViews))removeReactChains {
    return ^(NSArray<HyChartView *> *chartViews) {
        [chartViews enumerateObjectsUsingBlock:^(HyChartView * _Nonnull chartView, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *mArray = @[].mutableCopy;
            for (HyChartView *chartV in chartViews) {
                if (chartV != chartView) {
                    [mArray addObject:chartV];
                }
            }
            chartView._removeReactChains(mArray.copy);
        }];
    };
}

- (void(^)(NSArray<HyChartView *> *chartViews))_addReactChains {
    return ^(NSArray<HyChartView *> *chartViews){
        [chartViews enumerateObjectsUsingBlock:^(HyChartView * _Nonnull chartView, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([chartView isKindOfClass:HyChartView.class] ) {
                NSValue *weakObject = [NSValue valueWithNonretainedObject:chartView];
                if (![self.reactChains containsObject:weakObject]) {
                    [self.reactChains addObject:weakObject];
                }
            }
        }];
    };
}

- (void(^)(NSArray<HyChartView *> *chartViews))_removeReactChains {
    return ^(NSArray<HyChartView *> *chartViews){
        [chartViews enumerateObjectsUsingBlock:^(HyChartView * _Nonnull chartView, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([chartView isKindOfClass:HyChartView.class]) {
                NSValue *weakObject = [NSValue valueWithNonretainedObject:chartView];
                if ([self.reactChains containsObject:weakObject]) {
                    [self.reactChains removeObject:weakObject];
                }
            }
        }];
    };
}

- (void)setNeedsRendering {
    
    if (!self.dataSource) { return; }

    if (!self.chartWidth) {
        self.prepareStage = 1;
        return;
    }
    
    if (self.chartCursor.isShowing) {
        [self.chartCursor dismiss];
    }

    NSInteger itemsCount =
    self.dataSource.modelDataSource.numberOfItemsBlock ?
    self.dataSource.modelDataSource.numberOfItemsBlock() : 0;
    if (itemsCount <= 0 || !self.dataSource.modelDataSource.modelForItemAtIndexBlock) {
      return;
    }
 
    if (!self.pinchGestureDisabled && !self.pinchGesture.view) {
        [self.scrollView addGestureRecognizer:self.pinchGesture];
    }
    
    if (!self.tapGestureDisabled && !self.tapGesture.view) {
        [self.scrollView addGestureRecognizer:self.tapGesture];
    }
    
    if (!self.longPressGestureDisabled && !self.longPressGesture.view) {
        [self.scrollView addGestureRecognizer:self.longPressGesture];
    }
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    id<HyChartConfigureProtocol> configure = self.dataSource.configreDataSource.configure;
    if (configure.autoMargin) {
        CGFloat xMargin = self.chartWidth / self.dataSource.axisDataSource.xAxisModel.indexs;
        configure.margin =  xMargin - configure.width;
        configure.edgeInsetStart = xMargin - configure.width / 2;
    }
    
    self.reverseScrolling = YES;
    [self handleContentSize];
    if (self.configure.trans > self.chartContentWidth - self.chartWidth) {
        self.configure.trans = self.chartContentWidth - self.chartWidth;
    }
    CGFloat currentTrans = self.configure.dataDirection == HyChartDataDirectionForward ? self.configure.trans : (self.chartContentWidth - self.chartWidth - self.configure.trans);
    [self.scrollView setContentOffset:CGPointMake(currentTrans, 0)
                             animated:NO];
    self.reverseScrolling = NO;
        
    [self asyncHandler:^{
        [self handleModels];
        [self handleVisibleModels];
    } completion:^{
        self.prepareStage = 2;
        [self.layer setNeedsDisplay];
        dispatch_semaphore_signal(self.semaphore);
    }];
}

#pragma mark — private methods
- (void)handleModels {
  
    if ([self.dataSource.modelDataSource conformsToProtocol:@protocol(HyChartKLineModelDataSourceProtocol)]) {
        id<HyChartKLineModelDataSourceProtocol> klineModelDataSource = (id)self.dataSource.modelDataSource;
        id<HyChartKLineConfigureProtocol> klineConfigure = (id)self.configure;
        klineModelDataSource.priceNunmberFormatter = klineConfigure.priceNunmberFormatter;
        klineModelDataSource.volumeNunmberFormatter = klineConfigure.volumeNunmberFormatter;
    } else {
        self.dataSource.modelDataSource.numberFormatter = self.configure.numberFormatter;
    }
 
    [self.dataSource.modelDataSource.models removeAllObjects];
    NSInteger itemsCount = self.dataSource.modelDataSource.numberOfItemsBlock();
    for (NSInteger i = 0; i < itemsCount; i++) {
        id<HyChartModelProtocol> model = self.model; model.index = i;
        if ([model conformsToProtocol:@protocol(HyChartKLineModelProtocol)]) {
            id<HyChartKLineModelProtocol> klineModel = (id)model;
            id<HyChartKLineConfigureProtocol> klineConfigure = (id)self.configure;
            klineModel.priceNunmberFormatter = klineConfigure.priceNunmberFormatter;
            klineModel.volumeNunmberFormatter = klineConfigure.volumeNunmberFormatter;
        } else {
            model.numberFormatter = self.configure.numberFormatter;
        }
        self.dataSource.modelDataSource.modelForItemAtIndexBlock(model, i);
        [self.dataSource.modelDataSource.models addObject:model];
    }

    [self handleTechnicalData];
    [self handleMaxMinValue];
    [self handleOther];
}

- (void)handleOther {};
- (void)handleTechnicalData {}
- (void)handleMaxMinValue {}
- (void)handleContentSize {
    CGFloat contentWidth = self.contentWidth;
    self.scrollView.contentSize = CGSizeMake(contentWidth, 0);
    self.chartContentWidth = contentWidth;
}

- (void)asyncHandler:(void(^)(void))hander
          completion:(void(^)(void))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        !hander ?: hander();
        dispatch_async(dispatch_get_main_queue(), completion);
    });
}

- (CGFloat)contentWidth {
    
    CGFloat contentWidth = self.chartWidth;
    NSInteger itemsCount =
    self.dataSource.modelDataSource.numberOfItemsBlock ?
    self.dataSource.modelDataSource.numberOfItemsBlock() : 0;
    if (itemsCount > 0) {
        id<HyChartConfigureProtocol> configure = self.dataSource.configreDataSource.configure;
        CGFloat width = configure.edgeInsetStart + configure.edgeInsetEnd + itemsCount * (configure.width + configure.margin) - configure.margin;
        width = width * configure.scale;
        if (width > contentWidth) {
            contentWidth = width;
        }
    }
    return contentWidth;
}

- (void)handleVisibleModels {

    NSInteger itemsCount = self.dataSource.modelDataSource.numberOfItemsBlock();
    if (!self.dataSource.modelDataSource.models.count ||
        itemsCount <= 0 ||
        !self.dataSource.modelDataSource.modelForItemAtIndexBlock) {
        return;
    }

    id<HyChartConfigureProtocol> configure = self.configure;
    
    CGFloat trans = configure.trans;
    CGFloat scale = configure.scale;
    
    configure.scaleWidth = configure.width * scale;
    configure.scaleMargin = configure.margin * scale;
    configure.scaleItemWidth = configure.scaleWidth + configure.scaleMargin;
    configure.scaleEdgeInsetStart = configure.edgeInsetStart * scale;
    configure.scaleEdgeInsetEnd = configure.edgeInsetEnd * scale;

    CGFloat statrTrans = trans - configure.scaleEdgeInsetStart;
    if (statrTrans < 0) { statrTrans = 0; }

    NSInteger startIndex = (NSInteger)(statrTrans  / configure.scaleItemWidth);
    CGFloat startOffset = statrTrans -  (startIndex * configure.scaleItemWidth);
    if (startOffset > configure.scaleWidth) {
        startIndex += 1;
    }
    
    CGFloat totalTrans = trans + self.chartWidth;
    NSInteger endIndex  = (totalTrans - configure.scaleEdgeInsetStart)  / configure.scaleItemWidth;
    endIndex = endIndex > (itemsCount - 1) ? (itemsCount - 1) : endIndex;

    [self handleVisibleModelsWithStartIndex:startIndex endIndex:endIndex];
    [self handleXAxis];
    [self handleYAxis];
}

- (void)handleVisibleModelsWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {}
- (void)handleXAxis {
    
    id<HyChartXAxisModelProtocol> xAxisModel = self.dataSource.axisDataSource.xAxisModel;
    if (xAxisModel.indexs) {

        NSArray *models = self.dataSource.modelDataSource.models;
        CGFloat xAxisWidth = self.chartWidth / xAxisModel.indexs;
        NSMutableArray<id<HyChartModelProtocol>> *xAxisModels = @[].mutableCopy;
        for (NSInteger ind = 0; ind < xAxisModel.indexs + 1; ind ++) {
            CGFloat absolutePosition = self.configure.trans + xAxisWidth * ind;
            NSInteger absoluteIndex = [self absoluteIndexWithPosition:absolutePosition];
            if (absoluteIndex < models.count) {
                [xAxisModels addObject:models[absoluteIndex]];
            }
        }
        
        self.dataSource.modelDataSource.visibleXAxisModels = xAxisModels.copy;
        typedef id(^TextAtIndexBlock)(NSInteger, id<HyChartModelProtocol>);
        TextAtIndexBlock (^textBlock)(BOOL) = ^TextAtIndexBlock(BOOL displayAxisZeroText){
            return ^id(NSInteger index, id<HyChartModelProtocol> model){
                if (!displayAxisZeroText && !index) {
                    return @"";
                }
                if (index < xAxisModels.count) {
                    return xAxisModels[index].text;
                }
                return @"";
            };
        };

        if (!xAxisModel.topXaxisDisabled && xAxisModel.topXAxisInfo.autoSetText) {
           [xAxisModel.topXAxisInfo configTextAtIndex:textBlock(xAxisModel.topXAxisInfo.displayAxisZeroText)];
        }
        if (!xAxisModel.bottomXaxisDisabled && xAxisModel.bottomXAxisInfo.autoSetText) {
            [xAxisModel.bottomXAxisInfo configTextAtIndex:textBlock(xAxisModel.bottomXAxisInfo.displayAxisZeroText)];
        }
    }
}

- (void)handleYAxis {
    
    double maxValue = self.dataSource.modelDataSource.maxValue.doubleValue;
    double minValue = self.dataSource.modelDataSource.minValue.doubleValue;
    double subValue  = (maxValue - minValue);
    
    id<HyChartYAxisModelProtocol> yAxisModel = self.dataSource.axisDataSource.yAxisModel;
    
    if (yAxisModel.yAxisMinValueBlock) {
        yAxisModel.yAxisMinValue = yAxisModel.yAxisMinValueBlock();
        minValue = yAxisModel.yAxisMinValue.floatValue;
    } else {
        NSNumber *yAxisMinValueExtraPrecent = yAxisModel.yAxisMinValueExtraPrecent;
        if (yAxisMinValueExtraPrecent) {
            minValue = minValue - subValue * yAxisMinValueExtraPrecent.doubleValue;
        }
        yAxisModel.yAxisMinValue = [NSNumber numberWithDouble:minValue];
    }
    
    if (yAxisModel.yAxisMaxValueBlock) {
        yAxisModel.yAxisMaxValue = yAxisModel.yAxisMaxValueBlock();
        maxValue = yAxisModel.yAxisMaxValue.doubleValue;
    } else {
        NSNumber *yAxisMaxValueExtraPrecent = yAxisModel.yAxisMaxValueExtraPrecent;
        if (yAxisMaxValueExtraPrecent) {
            maxValue = maxValue + subValue * yAxisMaxValueExtraPrecent.doubleValue;
        }
        yAxisModel.yAxisMaxValue = [NSNumber numberWithDouble:maxValue];
    }
    
    if (yAxisModel.indexs) {
        CGFloat averageMargin = (maxValue - minValue) / yAxisModel.indexs;
        typedef id(^TextAtIndexBlock)(NSInteger, NSNumber *, NSNumber *);
        TextAtIndexBlock (^textBlock)(BOOL) = ^TextAtIndexBlock(BOOL displayAxisZeroText){
            return ^id(NSInteger index, NSNumber * _Nonnull maxV, NSNumber * _Nonnull minV){
                if (!displayAxisZeroText && !index) {
                    return @"";
                }
                double current = minValue + averageMargin * index;
                return [self.yAxisNunmberFormatter stringFromNumber:@(current)];
            };
        };

        if (!yAxisModel.leftYAxisDisabled && yAxisModel.leftYAxisInfo.autoSetText) {
            [yAxisModel.leftYAxisInfo configTextAtIndex:textBlock(yAxisModel.leftYAxisInfo.displayAxisZeroText)];
        }
        if (!yAxisModel.rightYAaxisDisabled && yAxisModel.rightYAxisInfo.autoSetText) {
            [yAxisModel.rightYAxisInfo configTextAtIndex:textBlock(yAxisModel.rightYAxisInfo.displayAxisZeroText)];
        }
    }
}

#pragma mark — 手势处理
- (void)pinchGestureAction:(UIPinchGestureRecognizer *)gesture {
    
    if (self.pinchGestureDisabled) { return; }
    
    if (self.chartCursor.isShowing) {
        [self.chartCursor dismiss];
    }
    
    id<HyChartConfigureProtocol> configure = self.configure;
    static NSInteger index = -1;
    static CGFloat margin = 0;
    switch (gesture.state) {
            
        case UIGestureRecognizerStateBegan: {
            [self startPinch];
            [self.reactChains enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HyChartView *chartView = (HyChartView *)obj.nonretainedObjectValue;
                if (chartView != self) {
                    [chartView startPinch];
                }
            }];
            CGFloat positionX = [gesture locationInView:gesture.view].x;
            if (self.configure.dataDirection == HyChartDataDirectionReverse) {
                positionX = self.chartContentWidth - positionX;
            }
            
            index = [self absoluteIndexWithPosition:positionX];
            CGFloat totalOffset = configure.edgeInsetStart + configure.scaleItemWidth * index + configure.scaleWidth / 2;
             margin = totalOffset - configure.trans;
            
        }break;
            
        case UIGestureRecognizerStateChanged: {
            if (index < self.dataSource.modelDataSource.models.count) {
                self.pinchAction(index, margin, gesture.scale);
                if (gesture == self.pinchGesture) {
                    [self.reactChains enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        HyChartView *chartView = (HyChartView *)obj.nonretainedObjectValue;
                        if (chartView != self) {
                            chartView.pinchAction(index, margin, gesture.scale);
                        }
                    }];
                }
            }
        }break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            index = -1;
            margin = 0;
            [self endPinch];
            if (gesture == self.pinchGesture) {
                [self.reactChains enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    HyChartView *chartView = (HyChartView *)obj.nonretainedObjectValue;
                    if (chartView != self) {
                        [chartView endPinch];
                    }
                }];
            }
        }break;
        default:
        break;
    }
    
    if (self.pinchGesture == gesture) {
       gesture.scale = 1;
    }
}

- (void)startPinch {
    self.pinching = YES;
    self.scrollView.scrollEnabled = NO;
}

- (void)endPinch {
    self.pinching = NO;
    self.scrollView.scrollEnabled = YES;
}

- (void)tapGestureAction:(UITapGestureRecognizer *)gesture {
    if (self.tapGestureDisabled) {
        return;
    }
    if (self.chartCursor.isShowing) {
        [self.chartCursor dismiss];
    } else {
        [self showCursorWithPoint:[gesture locationInView:self.scrollView]];
    }
}

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)gesture {
    if (self.longPressGestureDisabled) {
        return;
    }
    [self showCursorWithPoint:[gesture locationInView:self.scrollView]];
}

- (void)showCursorWithPoint:(CGPoint)point {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        CGFloat positionX = point.x;
        
        if (self.configure.dataDirection == HyChartDataDirectionReverse) {
            positionX = self.chartContentWidth - positionX;
        }
        
        NSInteger index = [self absoluteIndexWithPosition:positionX];
        if (index < self.dataSource.modelDataSource.models.count) {
            id<HyChartModelProtocol> model = self.dataSource.modelDataSource.models[index];
            
            NSString *xText = model.text;
            CGPoint centerP = CGPointMake(model.visiblePosition + self.configure.scaleWidth / 2, point.y);
            
            CGFloat chartH = self.chartHeight;
            id<HyChartYAxisModelProtocol> yAxisModel = self.dataSource.axisDataSource.yAxisModel;
            if ([self isKindOfClass:NSClassFromString(@"HyChartKLineView")]) {
                chartH = ((id<HyChartKLineConfigureProtocol>)self.dataSource.configreDataSource.configure).klineViewDict[@(HyChartKLineViewTypeMain)].floatValue * (self.chartHeight + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom) - self.contentEdgeInsets.top;
                yAxisModel = self.dataSource.axisDataSource.yAxisModelWityViewType(HyChartKLineViewTypeMain);
            }
            
            NSNumber *maxValue = yAxisModel.yAxisMaxValue;
            NSNumber *minValue = yAxisModel.yAxisMinValue;
            NSNumber *valueRate = DividingNumber(SubtractingNumber(maxValue, minValue), @(chartH));
            NSString * yText = [self.yAxisNunmberFormatter stringFromNumber: AddingNumber(MultiplyingNumber(@(chartH - point.y), valueRate), minValue)];;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.chartCursor.show(centerP, xText, yText, model, self);
            });
        }
    });
}

- (NSInteger)avisibleIndexWithPosition:(CGFloat)position {

    __block NSInteger relativeIndex = -1;
    CGFloat absolutePosition = self.configure.trans + position;
    NSInteger absoluteIndex = [self absoluteIndexWithPosition:absolutePosition];
    [self.dataSource.modelDataSource.visibleModels enumerateObjectsUsingBlock:^(id<HyChartModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.index == absoluteIndex) {
            relativeIndex = idx;
            *stop = YES;
        }
    }];
    return relativeIndex;
}

- (NSInteger)absoluteIndexWithPosition:(CGFloat)position {
    
    id<HyChartConfigureProtocol> configure = self.configure;
                       
    CGFloat transPositionX = position - configure.scaleEdgeInsetStart;
    if (transPositionX < 0) { transPositionX = 0; }

    NSInteger index = transPositionX  / configure.scaleItemWidth;
    CGFloat startOffset = transPositionX -  (index * configure.scaleItemWidth);
    if (startOffset > configure.scaleWidth + (configure.scaleMargin / 2) + 0.001) {
       index += 1;
    }
    
    return index;
}

#pragma mark — UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
        
    if (self.isReverseScrolling ||
        self.isPinching ||
        scrollView.contentOffset.x == self.configure.trans) {
        return;
    }

    if (self.chartCursor.isShowing) {
        [self.chartCursor dismiss];
    }
    
    if (scrollView == self.scrollView &&
        (self.scrollView.isDragging || self.scrollView.isDecelerating || self.scrollView.isTracking)) {
        [self.reactChains enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HyChartView *chartView = (HyChartView *)obj.nonretainedObjectValue;
            if (chartView != self) {
                chartView.scrollAction(scrollView.contentOffset, NO);
            }
        }];
    }
    
    if (self.configure.dataDirection == HyChartDataDirectionReverse) {
        self.configure.trans = (self.chartContentWidth - self.chartWidth) - scrollView.contentOffset.x;
        if (self.configure.trans < 0) { self.configure.trans = 0; }
    } else {
       self.configure.trans = scrollView.contentOffset.x;
    }

    [self asyncHandler:^{
       [self handleVisibleModels];
    } completion:^{
       [self.layer setNeedsDisplay];
    }];
}

#pragma mark - CALayerDelegate
- (void)drawRect:(CGRect)rect {}
- (void)displayLayer:(CALayer *)layer {
    layer.backgroundColor = self.backgroundColor.CGColor;
    if (self.prepareStage == 2) {
        [self.axisLayer setNeedsRendering];
        [self.chartLayer setNeedsRendering];
    } else if (self.prepareStage == 1) {
        [self setNeedsRendering];
    }
}

#pragma mark — getters and setters
- (HyChartAxisLayer *)axisLayer {
    if (!_axisLayer){
        _axisLayer = [HyChartAxisLayer layerWithDataSource:self.dataSource];
    }
    return _axisLayer;
}

- (CALayer<HyChartLayerProtocol> *)chartLayer {
    return nil;
}

- (id<HyChartDataSourceProtocol>)dataSource {
    return nil;
}

- (UIScrollView *)scrollView {
    if (!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate  = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (UIPinchGestureRecognizer *)pinchGesture {
    if (!_pinchGesture) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];
        _pinchGesture.scale = 1.0;
    }
    return _pinchGesture;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture){
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    }
    return _tapGesture;
}

- (UILongPressGestureRecognizer *)longPressGesture {
    if (!_longPressGesture){
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureAction:)];
    }
    return _longPressGesture;
}

- (CGRect)contentRect {
    return CGRectMake(self.contentEdgeInsets.left, self.contentEdgeInsets.top, self.bounds.size.width - (self.contentEdgeInsets.left + self.contentEdgeInsets.right), self.bounds.size.height - (self.contentEdgeInsets.top + self.contentEdgeInsets.bottom));
}

- (id<HyChartCursorProtocol>)chartCursor {
    if (!_chartCursor){
        _chartCursor = [HyChartCursor chartCursorWithLayer:self.layer];
    }
    return _chartCursor;
}

- (id<HyChartModelProtocol>)model {
    return nil;
}

- (id<HyChartConfigureProtocol>)configure {
    if (!_configure){
        _configure = self.dataSource.configreDataSource.configure;
    }
    return _configure;
}

- (NSMutableArray<NSValue *> *)reactChains {
    if (!_reactChains){
        _reactChains = [NSMutableArray array];
    }
    return _reactChains;
}

- (dispatch_semaphore_t)semaphore{
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(1);
    }
    return _semaphore;
}

- (void)setTechnicalType:(HyChartKLineTechnicalType)technicalType {

    if (technicalType != _technicalType &&
        self.dataSource.modelDataSource.models.count &&
        !self.timeLine) {
        [self asyncHandler:^{
            [self handleMaxMinValue];
            [self handleVisibleModels];
        } completion:^{
            if (self.chartCursor.isShowing) {
                [self.chartCursor dismiss];
            }
            [self.axisLayer setNeedsRendering];
            [self.chartLayer setNeedsRendering];
        }];
    }
    _technicalType = technicalType;
}

- (void)setAuxiliaryType:(HyChartKLineAuxiliaryType)auxiliaryType {
    
    if (auxiliaryType != _auxiliaryType &&
        self.dataSource.modelDataSource.models.count) {
        [self asyncHandler:^{
            [self handleMaxMinValue];
            [self handleVisibleModels];
        } completion:^{
            if (self.chartCursor.isShowing) {
                [self.chartCursor dismiss];
            }
            [self.axisLayer setNeedsRendering];
            [self.chartLayer setNeedsRendering];
        }];
    }
    _auxiliaryType = auxiliaryType;
}

// 调用 CALayerDelegate - [self setNeedsDisplay]; 方法
// 1. 调用[self.layer setNeedsDisplay];
// 2.实现 - (void)drawRect:(CGRect)rect [self layoutSubviews] 后 会自动调一次
// 3.实现 - (void)drawRect:(CGRect)rect  调用 [self setNeedsDisplay]会调一次
//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//
//    NSLog(@"drawRect");
//}

@end
