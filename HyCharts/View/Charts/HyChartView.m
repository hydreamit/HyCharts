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
#import "HyChartKLineModelProtocol.h"
#import "HyChartKLineModelDataSourceProtocol.h"
#import "HyChartsTypedef.h"
#import "HyChartCursor.h"
#import "HyChartsMethods.h"
#import "HyChartKLineMainLayer.h"
#import "HyChartXAxisModel.h"
#import "HyChartBarLayer.h"
#import "HyChartLineModel.h"
#import "HyChartLineModelDataSource.h"

#define LockModels(...) \
dispatch_semaphore_wait(self.arraySemaphore, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(self.arraySemaphore);


@interface HyChartView ()<UIScrollViewDelegate>
/// 轴图层
@property (nonatomic, strong) HyChartAxisLayer *axisLayer;
/// 滚动偏移量
@property (nonatomic, strong) UIScrollView *scrollView;
/// 点击手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
/// 缩放手势
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
/// 长按手势
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
/// 默认游标
@property (nonatomic, strong) id<HyChartCursorProtocol> chartCursor;

@property (nonatomic, assign) CGFloat chartWidth;
@property (nonatomic, assign) CGFloat chartHeight;
@property (nonatomic, assign) CGFloat chartContentWidth;
@property (nonatomic, assign) CGFloat notEnoughWidth;
@property (nonatomic, strong) HyChartConfigure * configure;
@property (nonatomic, assign) HyChartKLineTechnicalType technicalType;
@property (nonatomic, assign) HyChartKLineAuxiliaryType auxiliaryType;
@property (nonatomic, strong) NSMutableArray<NSValue *> *reactChains;
@property (nonatomic, assign, getter=isTimeLine) BOOL timeLine;
@property (nonatomic, assign, getter=isPinching) BOOL pinching;
@property (nonatomic, assign, getter=isReverseScrolling) BOOL reverseScrolling;
@property (nonatomic, assign) NSInteger prepareStage;
@property (nonatomic, strong) NSNumberFormatter *yAxisNunmberFormatter;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) dispatch_semaphore_t arraySemaphore;
@property (nonatomic, assign) BOOL hasResetChartCursor;
@property (nonatomic, copy) NSMutableArray<void(^)(void)> *renderingCompletions;
@end


@implementation HyChartView
@synthesize contentEdgeInsets = _contentEdgeInsets, pinchGestureDisabled = _pinchGestureDisabled, tapGestureDisabled = _tapGestureDisabled, longPressGestureDisabled = _longPressGestureDisabled, longGestureAction = _longGestureAction, tapGestureAction = _tapGestureAction, pinchGestureAction = _pinchGestureAction, scrollAction = _scrollAction, bounces = _bounces, chartCursorState = _chartCursorState;

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
        self.hasResetChartCursor = YES;
        self.chartCursor = cursor;
    }
}

- (void(^)(CGPoint contentOffset, BOOL animated))scroll {
    return ^(CGPoint contentOffset, BOOL animated) {
        [self.scrollView setContentOffset:contentOffset animated:animated];
    };
}

- (void(^)(NSInteger, CGFloat, CGFloat))pinch {
    return ^(NSInteger index, CGFloat margin, CGFloat sca) {
        
        HyChartConfigure *configure = self.configure;
        
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
        
        self._dataSource.configreDataSource.configure.scale = scale;
                    
        [self handleContentSize];
        
        CGFloat changeOffset = 0;
        CGFloat contentOffset = self.chartContentWidth - self.chartWidth;
        if (contentOffset > 0) {
            CGFloat totalOffset = (configure.edgeInsetStart  + (configure.width + configure.margin) * index + configure.width / 2) * configure.scale;
            changeOffset = totalOffset - margin;
            if (changeOffset < 0) { changeOffset = 0;}
            if (changeOffset > contentOffset) {changeOffset = contentOffset;}
            
            configure.trans = changeOffset;
            if (self.configure.renderingDirection == HyChartRenderingDirectionForward) {
                [self.scrollView setContentOffset:CGPointMake(changeOffset, 0) animated:NO];
            } else {
                [self.scrollView setContentOffset:CGPointMake(contentOffset - changeOffset, 0)
                                         animated:NO];
            }
        }
                
        [self handleVisibleModels];
        [self.layer setNeedsDisplay];
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
    [self setNeedsRenderingWithCompletion:nil];
}

- (void)setNeedsRenderingWithCompletion:(void(^ _Nullable)(void))completion {
    
    if (!self._dataSource) { return; }
    
    if (!self.chartWidth) {
        self.prepareStage = 1;
        if (completion) {
            [self.renderingCompletions addObject:completion];
        }
        return;
    }
    
    if (self.chartCursor.isShowing) {
        [self.chartCursor dismiss];
    }
    
    NSInteger itemsCount =
    self._dataSource.modelDataSource.numberOfItemsBlock ?
    self._dataSource.modelDataSource.numberOfItemsBlock() : 0;
    if (itemsCount <= 0 || !self._dataSource.modelDataSource.modelForItemAtIndexBlock) {
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
        
    HyChartConfigure *configure = self._dataSource.configreDataSource.configure;
    if (configure.autoMargin) {
        CGFloat xMargin = self.chartWidth / self._dataSource.axisDataSource.xAxisModel.indexs;
        configure.margin =  xMargin - configure.width;
        configure.edgeInsetStart = xMargin - configure.width / 2;
    }
    
    self.reverseScrolling = YES;
    [self handleContentSize];
    if (self.configure.trans > self.chartContentWidth - self.chartWidth) {
        self.configure.trans = self.chartContentWidth - self.chartWidth;
    }
    CGFloat currentTrans = self.configure.renderingDirection == HyChartRenderingDirectionForward ? self.configure.trans : (self.chartContentWidth - self.chartWidth - self.configure.trans);
    [self.scrollView setContentOffset:CGPointMake(currentTrans, 0)
                             animated:NO];
    self.reverseScrolling = NO;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self handleModels];
        [self handleVisibleModels];
        long signalValue = dispatch_semaphore_signal(self.semaphore);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger lastPrepareStage = self.prepareStage;
            if (signalValue == 0) {
                self.prepareStage = 2;
                if ([self.chartLayer isKindOfClass:NSClassFromString(@"HyChartBarLayer")] ||
                    [self.chartLayer isKindOfClass:NSClassFromString(@"HyChartLineLayer")]) {
                    [((HyChartBarLayer *)self.chartLayer) resetLayers];
                }
                [self.layer setNeedsDisplay];
            }
            if (lastPrepareStage == 1) {
                for (void(^block)(void) in self.renderingCompletions) {
                    block();
                }
                [self.renderingCompletions removeAllObjects];
            } else {
               !completion ?: completion();
            }
        });
    });
}

- (void)refreshChartsView {
    
    NSInteger itemsCount =
    self._dataSource.modelDataSource.numberOfItemsBlock ?
    self._dataSource.modelDataSource.numberOfItemsBlock() : 0;
    NSInteger modelsCount = self._dataSource.modelDataSource.models.count;
    if (modelsCount == 0 && itemsCount == 0) {
        return;
    }
    if (modelsCount == 0 && itemsCount > 0) {
        [self setNeedsRendering];
        return;
    }
    
    BOOL isKline = [self.model conformsToProtocol:@protocol(HyChartKLineModelProtocol)];
    HyChartModel *firstModel = self._dataSource.modelDataSource.models.firstObject;
    BOOL contain = [self._dataSource.modelDataSource.visibleModels containsObject:firstModel];
    
    if (itemsCount == modelsCount) {
        
        [self asyncHandler:^{
            
            if (isKline) {
                self._dataSource.modelDataSource.modelForItemAtIndexBlock(firstModel, 0);
                [firstModel handleModel];
                [self handleTechnicalDataWithRangeIndex:1];
                [self handleMaxMinValueWithRangeIndex:1];
            }
            if (self.needsHandleModelLineValues) {
                if ([firstModel isKindOfClass:HyChartKLineModel.class]) {
                    if (((HyChartKLineModel *)firstModel).timeLineValuesBlock) {
                        ((HyChartKLineModel *)firstModel).timeLineValuesBlock((id)firstModel);
                    }
                }
               NSArray<NSMutableArray *> *array = ((HyChartLineModelDataSource *)self._dataSource.modelDataSource).valuesArray;
               if (array.count == ((HyChartKLineModel *)firstModel).values.count) {
                   [((HyChartKLineModel *)firstModel).values enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                       [array[idx] replaceObjectAtIndex:0 withObject:obj];
                   }];
               }
            }
            if (contain) {
               [self handleVisibleModels];
            }
            
        } completion:^{
            if (contain) {
                [self.layer setNeedsDisplay];
            } else {
                if (isKline &&
                    ((HyChartKLineConfigure *)self._dataSource.configreDataSource.configure).disPlayNewprice) {
                    [((HyChartKLineMainLayer *)self.chartLayer) renderingNewprice];
                }
            }
        }];
        
    } else if (itemsCount > modelsCount) {
        
        BOOL needsHandle = self.chartContentWidth <= self.chartWidth;
        NSInteger indexCount = itemsCount - modelsCount;
        [self handleContentSize];

        [self asyncHandler:^{
            
            NSMutableArray *array = @[].mutableCopy;
            
            for (NSInteger i = 0; i < indexCount; i++) {
                HyChartModel *model = self.model;
                if ([model conformsToProtocol:@protocol(HyChartKLineModelProtocol)]) {
                    HyChartKLineModel *klineModel = (id)model;
                    HyChartKLineConfigure *klineConfigure = (id)self.configure;
                    klineModel.priceNunmberFormatter = klineConfigure.priceNunmberFormatter;
                    klineModel.volumeNunmberFormatter = klineConfigure.volumeNunmberFormatter;
                } else {
                    model.numberFormatter = self.configure.numberFormatter;
                }
                [model setValuePositonProvider:(id)self.chartLayer];
                 self._dataSource.modelDataSource.modelForItemAtIndexBlock(model, i);
                [model handleModel];
                [array addObject:model];
            }
            
            LockModels([self._dataSource.modelDataSource.models insertObjects:array
                                                                    atIndexes:[NSIndexSet indexSetWithIndex:0]])
            if (isKline) {
                [self handleTechnicalDataWithRangeIndex:indexCount];
                [self handleMaxMinValueWithRangeIndex:indexCount];
            }
            
            if (self.needsHandleModelLineValues) {
                NSMutableArray<NSMutableArray *> *valuesArray = @[].mutableCopy;
                NSArray<NSMutableArray *> *array = ((HyChartLineModelDataSource *)self._dataSource.modelDataSource).valuesArray;
                if (array.count == ((HyChartKLineModel *)firstModel).values.count) {
                    for (HyChartKLineModel *model in array) {
                        if ([model isKindOfClass:HyChartKLineModel.class]) {
                           !model.timeLineValuesBlock ?: model.timeLineValuesBlock(model);
                        }
                        [model.values enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (valuesArray.count != model.values.count) {
                               [valuesArray addObject:@[obj].mutableCopy];
                            } else {
                               [valuesArray[idx] addObject:obj];
                           }
                        }];
                    }
                }
                
                LockModels([array enumerateObjectsUsingBlock:^(NSMutableArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [obj addObjectsFromArray:valuesArray[idx]];
                          }];)
            }
            
            if (needsHandle) {
               [self handleVisibleModels];
            }
            
        } completion:^{
            if (needsHandle) {
                [self.layer setNeedsDisplay];
            } else {
                if (isKline &&
                    ((HyChartKLineConfigure *)self._dataSource.configreDataSource.configure).disPlayNewprice) {
                    [((HyChartKLineMainLayer *)self.chartLayer) renderingNewprice];
                }
            }
        }];
        
    } else {
        
        NSInteger indexs = modelsCount - itemsCount;
        NSInteger startIndex = [self._dataSource.modelDataSource.models indexOfObject:self._dataSource.modelDataSource.visibleModels.firstObject];
        BOOL needsHandle = indexs >= startIndex;
        if (indexs > self._dataSource.modelDataSource.models.count) {
            return;
        }
        
        [self handleContentSize];        
        [self asyncHandler:^{
            LockModels(
                       [self._dataSource.modelDataSource.models removeObjectsAtIndexes:[NSIndexSet  indexSetWithIndexesInRange:NSMakeRange(0, indexs)]];
                       if (self.needsHandleModelLineValues) {
                           NSArray<NSMutableArray *> *array = ((HyChartLineModelDataSource *)self._dataSource.modelDataSource).valuesArray;
                           if (array.count == ((HyChartKLineModel *)firstModel).values.count) {
                               [array enumerateObjectsUsingBlock:^(NSMutableArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                   [obj removeObjectsAtIndexes:[NSIndexSet  indexSetWithIndexesInRange:NSMakeRange(0, indexs)]];
                               }];
                           }
                       }
                       )
            if (needsHandle) {
               [self handleVisibleModels];
            }
        } completion:^{
            if (needsHandle) {
                [self.layer setNeedsDisplay];
            }
        }];
    }
}

#pragma mark — private methods
- (void)handleModels {
  
    if ([self._dataSource.modelDataSource conformsToProtocol:@protocol(HyChartKLineModelDataSourceProtocol)]) {
        HyChartKLineModelDataSource *klineModelDataSource = (id)self._dataSource.modelDataSource;
        HyChartKLineConfigure *klineConfigure = (id)self.configure;
        klineModelDataSource.priceNunmberFormatter = klineConfigure.priceNunmberFormatter;
        klineModelDataSource.volumeNunmberFormatter = klineConfigure.volumeNunmberFormatter;
    } else {
        self._dataSource.modelDataSource.numberFormatter = self.configure.numberFormatter;
    }

    BOOL needsHandleModelValues = self.needsHandleModelLineValues;
    
    NSMutableArray *array = @[].mutableCopy;
    NSInteger itemsCount = self._dataSource.modelDataSource.numberOfItemsBlock();
    NSMutableArray<NSMutableArray*> *valuesArray = @[].mutableCopy;
    for (NSInteger i = 0; i < itemsCount; i++) {
        HyChartModel *model = self.model;
        if ([model conformsToProtocol:@protocol(HyChartKLineModelProtocol)]) {
            HyChartKLineModel *klineModel = (id)model;
            HyChartKLineConfigure *klineConfigure = (id)self.configure;
            klineModel.priceNunmberFormatter = klineConfigure.priceNunmberFormatter;
            klineModel.volumeNunmberFormatter = klineConfigure.volumeNunmberFormatter;
        } else {
            model.numberFormatter = self.configure.numberFormatter;
        }
        [model setValuePositonProvider:(id)self.chartLayer];
        self._dataSource.modelDataSource.modelForItemAtIndexBlock(model, i);
        [model handleModel];
        [array addObject:model];
        if (needsHandleModelValues) {
            [((HyChartLineModel *)model).values enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (valuesArray.count != ((HyChartLineModel *)model).values.count) {
                    [valuesArray addObject:@[obj].mutableCopy];
                } else {
                    [valuesArray[idx] addObject:obj];
                }
            }];
        }
    }
    
    LockModels([self._dataSource.modelDataSource.models removeAllObjects];
               [self._dataSource.modelDataSource.models addObjectsFromArray:array];
               if (needsHandleModelValues) {
        ((HyChartLineModelDataSource *)self._dataSource.modelDataSource).valuesArray = valuesArray.copy;
    })
    [self handleTechnicalDataWithRangeIndex:0];
    [self handleMaxMinValueWithRangeIndex:0];
    [self handleLineValues];
    [self handleOther];
}

- (BOOL)needsHandleModelLineValues {
    return
    ([self isKindOfClass:NSClassFromString(@"HyChartLineView")] ||
     (self.isTimeLine &&
      ([self isKindOfClass:NSClassFromString(@"HyChartKLineMainView")] ||
       [self isKindOfClass:NSClassFromString(@"HyChartKLineView")])
      )
    );
}

- (void)handleLineValues {
    
    BOOL handleModelValues = self.needsHandleModelLineValues;
    
    if (!handleModelValues ||
        ((HyChartKLineModelDataSource *)self._dataSource.modelDataSource).valuesArray.count) { return;}
    
    if (handleModelValues) {
        NSMutableArray<NSMutableArray*> *valuesArray = @[].mutableCopy;
        for (HyChartKLineModel *obj in self._dataSource.modelDataSource.models) {
            if (obj.timeLineValuesBlock) {
                obj.timeLineValuesBlock(obj);
                [obj.values enumerateObjectsUsingBlock:^(NSNumber * _Nonnull numberObj, NSUInteger numberIndex, BOOL * _Nonnull stop) {
                    if (valuesArray.count != obj.values.count) {
                        [valuesArray addObject:@[numberObj].mutableCopy];
                    } else {
                        [valuesArray[numberIndex] addObject:numberObj];
                    }
                }];
            }
        }
        LockModels(((HyChartKLineModelDataSource *)self._dataSource.modelDataSource).valuesArray = valuesArray.copy);
    }
}

- (void)handleOther {}
- (void)handleTechnicalDataWithRangeIndex:(NSInteger)rangeIndex {}
- (void)handleMaxMinValueWithRangeIndex:(NSInteger)rangeIndex {}
- (void)handleContentSize {
    
    CGFloat contentWidth = self.contentWidth;
    if (contentWidth < self.chartWidth) {
        
        if (self._dataSource.configreDataSource.configure.renderingDirection == HyChartRenderingDirectionForward &&
            self._dataSource.configreDataSource.configure.notEnoughSide == HyChartNotEnoughSideRight) {
            self.notEnoughWidth =  self.chartWidth - contentWidth;
        } else if (self._dataSource.configreDataSource.configure.renderingDirection == HyChartRenderingDirectionReverse &&
            self._dataSource.configreDataSource.configure.notEnoughSide == HyChartNotEnoughSideLeft) {
            self.notEnoughWidth =  contentWidth - self.chartWidth;
        } else {
            self.notEnoughWidth = 0;
        }
        self._dataSource.configreDataSource.configure.notEnough = YES;
        contentWidth = self.chartWidth;
    } else {
        self._dataSource.configreDataSource.configure.notEnough = NO;
        self.notEnoughWidth = 0;
    }
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
    
//    CGFloat contentWidth = self.chartWidth;
    CGFloat contentWidth = 0.0;
    NSInteger itemsCount =
    self._dataSource.modelDataSource.numberOfItemsBlock ?
    self._dataSource.modelDataSource.numberOfItemsBlock() : 0;
    if (itemsCount > 0) {
        HyChartConfigure *configure = self._dataSource.configreDataSource.configure;
        CGFloat width = configure.edgeInsetStart + configure.edgeInsetEnd + itemsCount * (configure.width + configure.margin) - configure.margin;
        if (configure.minDisplayWidth > 0 &&
            configure.minDisplayWidth <= width) {
            configure.minScale = configure.minDisplayWidth / width;
        }
        if (configure.maxDisplayWidth > 0 &&
            configure.maxDisplayWidth >= width) {
            CGFloat maxScale = configure.maxDisplayWidth / width;
            if (maxScale >= configure.minScale) {
                configure.maxScale = maxScale;
            }
        }
        if (configure.displayWidth > 0) {
            configure.scale = configure.displayWidth / width;
            configure.displayWidth = 0;
        }
        width = width * configure.scale;
        contentWidth = width;
    }
    return contentWidth;
}

- (void)handleVisibleModels {

    NSInteger itemsCount = self._dataSource.modelDataSource.numberOfItemsBlock();
    if (!self._dataSource.modelDataSource.models.count ||
        itemsCount <= 0 ||
        !self._dataSource.modelDataSource.modelForItemAtIndexBlock) {
        return;
    }

    HyChartConfigure *configure = self.configure;
    
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
    if (startOffset > configure.scaleWidth) { startIndex += 1; }
    
    CGFloat totalTrans = trans + self.chartWidth;
    NSInteger endIndex  = (totalTrans - configure.scaleEdgeInsetStart)  / configure.scaleItemWidth;
    endIndex = endIndex > (itemsCount - 1) ? (itemsCount - 1) : endIndex;
    
    LockModels(if ((startIndex >= 0 && startIndex < self._dataSource.modelDataSource.models.count) &&
                   endIndex >= 0 && endIndex < self._dataSource.modelDataSource.models.count) {
        self._dataSource.modelDataSource.visibleFromIndex = startIndex;
        self._dataSource.modelDataSource.visibleToIndex = endIndex;
        [self handleVisibleModelsWithStartIndex:startIndex endIndex:endIndex];
        [self handleXAxis];
        [self handleYAxis];
    })
}

- (void)handleVisibleModelsWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {}
- (void)handlePositionWithModel:(HyChartModel *)model idx:(NSInteger)idx {
    
    HyChartConfigure *configure = self._dataSource.configreDataSource.configure;
    NSInteger index = [self._dataSource.modelDataSource.models indexOfObject:model];
    if (configure.renderingDirection == HyChartRenderingDirectionForward) {
       model.position = configure.scaleEdgeInsetStart + index * configure.scaleItemWidth;
       model.visiblePosition = model.position - configure.trans;
    } else {
       model.position = configure.scaleEdgeInsetStart + index * configure.scaleItemWidth + configure.scaleWidth;
       model.visiblePosition = self.chartWidth - (model.position - configure.trans);
    }
    model.visiblePosition += self.notEnoughWidth;
}

- (void)handleXAxis {
    
    HyChartXAxisModel *xAxisModel = self._dataSource.axisDataSource.xAxisModel;
    if (xAxisModel.indexs) {

        NSArray *models = self._dataSource.modelDataSource.models;
        CGFloat xAxisWidth = self.chartWidth / xAxisModel.indexs;
        NSMutableArray<HyChartModel *> *xAxisModels = @[].mutableCopy;
        for (NSInteger ind = 0; ind < xAxisModel.indexs + 1; ind++) {
            
            CGFloat absolutePosition = self.configure.trans + xAxisWidth * ind;
            
            if (self.notEnoughWidth != 0) {
                if (self._dataSource.configreDataSource.configure.renderingDirection == HyChartRenderingDirectionForward &&
                    self._dataSource.configreDataSource.configure.notEnoughSide == HyChartNotEnoughSideRight) {
                    absolutePosition = self.chartWidth - self.notEnoughWidth - absolutePosition;
                } else if (self._dataSource.configreDataSource.configure.renderingDirection == HyChartRenderingDirectionReverse &&
                    self._dataSource.configreDataSource.configure.notEnoughSide == HyChartNotEnoughSideLeft) {
                    absolutePosition = self.chartWidth + self.notEnoughWidth - absolutePosition;
                }
            }
     
            if (absolutePosition >= - self.configure.margin) {
                NSInteger absoluteIndex = [self absoluteIndexWithPosition:absolutePosition];
                if (absoluteIndex < models.count) {
                    [xAxisModels addObject:models[absoluteIndex]];
                }
            }
        }
  
        self._dataSource.modelDataSource.visibleXAxisModels = xAxisModels.copy;
        typeof(id(^)(NSInteger, HyChartModel *))(^textBlock)(BOOL) =
        ^(BOOL displayAxisZeroText){
            return ^id(NSInteger index, HyChartModel * model){
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
    
    double maxValue = self._dataSource.modelDataSource.maxValue.doubleValue;
    double minValue = self._dataSource.modelDataSource.minValue.doubleValue;
    double subValue  = (maxValue - minValue);
    
    HyChartYAxisModel *yAxisModel = self._dataSource.axisDataSource.yAxisModel;
    
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
        __weak typeof(self) _self = self;
        CGFloat averageMargin = (maxValue - minValue) / yAxisModel.indexs;
        typeof(id(^)(NSInteger, NSNumber *, NSNumber *))(^textBlock)(BOOL) =
        ^(BOOL displayAxisZeroText){
            return ^id(NSInteger index, NSNumber * _Nonnull maxV, NSNumber * _Nonnull minV){
                if (!displayAxisZeroText && !index) {
                    return @"";
                }
                __strong typeof(_self) self = _self;
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

#pragma mark — Gesture
- (void)pinchGestureAction:(UIPinchGestureRecognizer *)gesture {
    
    if (self.pinchGestureDisabled) { return; }
    
    HyChartConfigure *configure = self.configure;
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
            
//            if (self.configure.renderingDirection == HyChartRenderingDirectionReverse &&
//                (self.configure.notEnoughSide != HyChartNotEnoughSideLeft && self.notEnoughWidth != 0)) {
//                positionX = self.chartContentWidth - positionX;
//            }
            
            if (self.configure.renderingDirection == HyChartRenderingDirectionReverse) {
                 positionX = self.chartContentWidth - positionX;
                 positionX += self.notEnoughWidth;
            } else {
                positionX -= self.notEnoughWidth;
            }
            
            if (positionX < 0 && positionX >= - self.configure.margin / 2) {
                positionX = 0;
            }

            if (positionX >= 0) {
                index = [self absoluteIndexWithPosition:positionX];
                CGFloat totalOffset = configure.edgeInsetStart + configure.scaleItemWidth * index + configure.scaleWidth / 2;
                 margin = totalOffset - configure.trans;
            }
            
        }break;
            
        case UIGestureRecognizerStateChanged: {
            if (index < self._dataSource.modelDataSource.models.count) {
                self.pinch(index, margin, gesture.scale);
                if (gesture == self.pinchGesture) {
                    [self.reactChains enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        HyChartView *chartView = (HyChartView *)obj.nonretainedObjectValue;
                        if (chartView != self) {
                            chartView.pinch(index, margin, gesture.scale);
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
    
    if (index > -1 && index < self._dataSource.modelDataSource.models.count) {
        !self.pinchGestureAction ?:
        self.pinchGestureAction(self, self._dataSource.modelDataSource.models[index], index, self._dataSource.configreDataSource.configure.scale, gesture.state);
    }

    if (self.pinchGesture == gesture) {
       gesture.scale = 1;
    }
}

- (void)startPinch {
    if (self.chartCursor.isShowing) {
        [self.chartCursor dismiss];
    }
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
        !self.chartCursorState ?: self.chartCursorState(HyChartCursorStateDidEndShowing);
    } else {
        if (self.chartCursor || self.tapGestureAction) {
            [self handleGestureWithPoint:[gesture locationInView:self.scrollView]
                              completion:^(HyChartModel * model, NSInteger index,
                                           CGPoint centerPoint, NSString *xText, NSString *yText) {
                !self.chartCursorState ?: self.chartCursorState(HyChartCursorStateWillShowing);
                !self.chartCursor.show ?: self.chartCursor.show(self, model, xText, yText, centerPoint);
                !self.tapGestureAction ?: self.tapGestureAction(self, model, index, centerPoint);
            }];
        }
    }
}

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)gesture {
    if (self.longPressGestureDisabled) {
        return;
    }
    if (self.chartCursor || self.longGestureAction) {
        [self handleGestureWithPoint:[gesture locationInView:self.scrollView]
                          completion:^(HyChartModel * model, NSInteger index,
                                       CGPoint centerPoint, NSString *xText, NSString *yText) {
            
            if (gesture.state == UIGestureRecognizerStateBegan &&
                !self.chartCursor.isShowing) {
                !self.chartCursorState ?: self.chartCursorState(HyChartCursorStateWillShowing);
            } else {
                !self.chartCursorState ?: self.chartCursorState(HyChartCursorStateScrollShowing);
            }
            !self.chartCursor.show ?: self.chartCursor.show(self, model, xText, yText, centerPoint);
            !self.longGestureAction ?: self.longGestureAction(self, model, index, centerPoint, gesture.state);
        }];
    }
}

- (void)handleGestureWithPoint:(CGPoint)point
                    completion:(void(^)(HyChartModel * model,
                                        NSInteger index, CGPoint centerPoint,
                                        NSString *xText,NSString *yText))completion {
 
    CGFloat positionX = point.x;
    if (self.configure.renderingDirection == HyChartRenderingDirectionReverse) {
        positionX = self.chartContentWidth - positionX;
        positionX += self.notEnoughWidth;
    } else {
        positionX -= self.notEnoughWidth;
    }
    
    if (positionX < 0 && positionX >= - self.configure.margin / 2) {
        positionX = 0;
    }
    
//    if (positionX < self.configure.scaleEdgeInsetStart) { return;}
    
    NSInteger index = [self absoluteIndexWithPosition:positionX];
    if (index < self._dataSource.modelDataSource.models.count) {
        
        HyChartModel * model = self._dataSource.modelDataSource.models[index];
        NSString *xText = model.text;
        CGPoint centerP = CGPointMake(model.visiblePosition + self.configure.scaleWidth / 2, point.y);
        
        CGFloat chartH = self.chartHeight;
        HyChartYAxisModel *yAxisModel = self._dataSource.axisDataSource.yAxisModel;
        if ([self isKindOfClass:NSClassFromString(@"HyChartKLineView")]) {
            chartH = ((HyChartKLineConfigure *)self._dataSource.configreDataSource.configure).klineViewDict[@(HyChartKLineViewTypeMain)].floatValue * (self.chartHeight + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom) - self.contentEdgeInsets.top;
            yAxisModel = self._dataSource.axisDataSource.yAxisModelWityViewType(HyChartKLineViewTypeMain);
        }
        
        NSNumber *maxValue = yAxisModel.yAxisMaxValue;
        NSNumber *minValue = yAxisModel.yAxisMinValue;
        NSNumber *valueRate = DividingNumber(SubtractingNumber(maxValue, minValue), @(chartH));
        NSString *yText = [self.yAxisNunmberFormatter stringFromNumber: AddingNumber(MultiplyingNumber(@(chartH - point.y), valueRate), minValue)];
        
        !completion ?: completion(model,index, centerP, xText, yText);
    }
}

- (NSInteger)avisibleIndexWithPosition:(CGFloat)position {

    __block NSInteger relativeIndex = -1;
    CGFloat absolutePosition = self.configure.trans + position;
    NSInteger absoluteIndex = [self absoluteIndexWithPosition:absolutePosition];
    [self._dataSource.modelDataSource.visibleModels enumerateObjectsUsingBlock:^(HyChartModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = [self._dataSource.modelDataSource.models indexOfObject:obj];
        if (index== absoluteIndex) {
            relativeIndex = idx;
            *stop = YES;
        }
    }];
    return relativeIndex;
}

- (NSInteger)absoluteIndexWithPosition:(CGFloat)position {
    
    HyChartConfigure *configure = self.configure;
                       
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
                chartView.scroll(scrollView.contentOffset, NO);
            }
        }];
    }
    
    if (self.configure.renderingDirection == HyChartRenderingDirectionReverse) {
        self.configure.trans = (self.chartContentWidth - self.chartWidth) - scrollView.contentOffset.x;
        if (self.configure.trans < 0) { self.configure.trans = 0; }
    } else {
       self.configure.trans = scrollView.contentOffset.x;
    }

    [self handleVisibleModels];
    [self.layer setNeedsDisplay];
    
    !self.scrollAction ?:
    self.scrollAction(scrollView.contentOffset.x, self.chartWidth, self.chartContentWidth);
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
        _axisLayer = [HyChartAxisLayer layerWithDataSource:self._dataSource];
    }
    return _axisLayer;
}

- (CALayer<HyChartLayerProtocol> *)chartLayer {
    return nil;
}

- (HyChartDataSource *)_dataSource {
    return self.dataSource;
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

- (void)setBounces:(BOOL)bounces {
    _bounces = bounces;
    self.scrollView.bounces = bounces;
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
    if (!_chartCursor && !self.hasResetChartCursor){
        _chartCursor = [HyChartCursor chartCursorWithLayer:self.layer];
    }
    return _chartCursor;
}

- (HyChartModel *)model {
    return nil;
}

- (HyChartConfigure *)configure {
    if (!_configure){
        _configure = self._dataSource.configreDataSource.configure;
    }
    return _configure;
}

- (NSMutableArray<void (^)(void)> *)renderingCompletions {
    if (!_renderingCompletions) {
        _renderingCompletions = @[].mutableCopy;
    }
    return _renderingCompletions;
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

- (dispatch_semaphore_t)arraySemaphore{
    if (!_arraySemaphore) {
        _arraySemaphore = dispatch_semaphore_create(1);
    }
    return _arraySemaphore;
}

- (void)setTechnicalType:(HyChartKLineTechnicalType)technicalType {

    HyChartKLineTechnicalType lastType = _technicalType;
    _technicalType = technicalType;
    if (lastType != _technicalType &&
        self._dataSource.modelDataSource.models.count &&
        !self.timeLine) {
        [self asyncHandler:^{
            [self handleMaxMinValueWithRangeIndex:0];
            [self handleVisibleModels];
        } completion:^{
            if (self.chartCursor.isShowing) {
                [self.chartCursor dismiss];
            }
            [self.layer setNeedsDisplay];
        }];
    }
}

- (void)setAuxiliaryType:(HyChartKLineAuxiliaryType)auxiliaryType {
    HyChartKLineAuxiliaryType lastType = _auxiliaryType;
    _auxiliaryType = auxiliaryType;
    if (lastType != _auxiliaryType &&
        self._dataSource.modelDataSource.models.count) {
        [self asyncHandler:^{
            [self handleMaxMinValueWithRangeIndex:0];
            [self handleVisibleModels];
        } completion:^{
            if (self.chartCursor.isShowing) {
                [self.chartCursor dismiss];
            }
            [self.layer setNeedsDisplay];
        }];
    }
}

@end
