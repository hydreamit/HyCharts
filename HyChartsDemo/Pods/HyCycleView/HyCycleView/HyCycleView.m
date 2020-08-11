//
//  HyCycleView.m
//  HyCycleView
//  https://github.com/hydreamit/HyCycleView
//
//  Created by Hy on 16/5/3.
//  Copyright © 2016年 Hy. All rights reserved.
//


#import "HyCycleView.h"


@interface HyCycleViewProvider ()
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) id protocolObject;
@property (nonatomic, copy) UIView *(^hy_view)(id);
@property (nonatomic, copy) void (^hy_viewWillAppear)(id, id, BOOL);
@property (nonatomic, copy) void (^hy_viewDidDisAppear)(id, id);
@property (nonatomic, copy) void (^hy_viewClickAction)(id, id);
@end
@implementation HyCycleViewProvider
- (instancetype)view:(UIView * _Nonnull (^)(id _Nonnull))block {
    self.hy_view = [block copy];
    return self;
}
- (instancetype)viewWillAppear:(void (^)(id _Nonnull, id _Nonnull, BOOL))block {
    self.hy_viewWillAppear = [block copy];
    return self;
}
- (instancetype)viewDidDisAppear:(void (^)(id _Nonnull, id _Nonnull))block {
    self.hy_viewDidDisAppear = [block copy];
    return self;
}
- (instancetype)viewClickAction:(void (^)(id _Nonnull, id _Nonnull))block {
    self.hy_viewClickAction = [block copy];
    return self;
}
@end


@interface HyCycleViewConfigure ()
@property (nonatomic, assign) BOOL hy_isCycle;
@property (nonatomic, assign) BOOL hy_isAutoCycle;
@property (nonatomic, assign) NSTimeInterval hy_interval;
@property (nonatomic, assign) HyCycleViewDirection hy_direction;
@property (nonatomic, assign) HyCycleViewLoadStyle hy_loadStyle;
@property (nonatomic, copy) NSInteger (^hy_totalIndexs)(id);
@property (nonatomic, copy) NSInteger (^hy_startIndex)(id);
@property (nonatomic,copy) id (^hy_viewAtIndex)(id, NSInteger);
@property (nonatomic,copy) void(^hy_viewWillAppearAtIndex)(id, id, NSInteger, BOOL);
@property (nonatomic,copy) void(^hy_viewDidDisAppearAtIndex)(id, id, NSInteger);
@property (nonatomic,copy) void(^hy_clickActionAtIndex)(id, id, NSInteger);
@property (nonatomic,copy) void(^hy_currentIndexChange)(id, NSInteger, NSInteger);
@property (nonatomic,copy) void(^hy_roundingIndexChange)(id, NSInteger, NSInteger);
@property (nonatomic,copy) void(^hy_scrollProgress)(id, NSInteger, NSInteger, CGFloat);
@property (nonatomic,weak) id<HyCycleViewScrollDelegate> hy_scrollDelegate;
@end

@implementation HyCycleViewConfigure
- (instancetype)init {
    self = [super init];
    if (self) {
        self.hy_interval = 2;
//        self.hy_loadStyle  = 1;
//        self.hy_isAutoCycle = YES;
//        self.hy_isCycle = YES;
//        self.hy_direction = HyCycleViewDirectionTop;
    }
    return self;
}
- (instancetype)isCycle:(BOOL)isCycle {
    self.hy_isCycle = isCycle;
    return self;
}
- (instancetype)isAutoCycle:(BOOL)isAutoCycle {
    self.hy_isAutoCycle = isAutoCycle;
    return self;
}
- (instancetype)interval:(NSTimeInterval)interval {
    self.hy_interval = interval;
    return self;
}
- (instancetype)direction:(HyCycleViewDirection)direction {
    self.hy_direction = direction;
    return self;
}
- (instancetype)loadStyle:(HyCycleViewLoadStyle)loadStyle {
    self.hy_loadStyle = loadStyle;
    return self;
}
- (instancetype)startIndex:(NSInteger(^)(id))block {
    self.hy_startIndex = [block copy];
    return self;
}
- (instancetype)totalIndexs:(NSInteger(^)(id))block {
    self.hy_totalIndexs = [block copy];
    return self;
}
- (instancetype)viewProviderAtIndex:(id  _Nonnull (^)(id _Nonnull, NSInteger))block {
    self.hy_viewAtIndex = [block copy];
    return self;
}
- (instancetype)viewWillAppearAtIndex:(void (^)(id _Nonnull, id _Nonnull, NSInteger, BOOL))block {
    self.hy_viewWillAppearAtIndex = [block copy];
    return self;
}
- (instancetype)viewDidDisAppearAtIndex:(void (^)(id _Nonnull, id _Nonnull, NSInteger))block {
    self.hy_viewDidDisAppearAtIndex = [block copy];
    return self;
}
- (instancetype)clickActionAtIndex:(void (^)(id _Nonnull,id _Nonnull, NSInteger))block {
    self.hy_clickActionAtIndex = [block copy];
    return self;
}
- (instancetype)currentIndexChange:(void (^)(id _Nonnull, NSInteger, NSInteger))block {
    self.hy_currentIndexChange = [block copy];
    return self;
}
- (instancetype)roundingIndexChange:(void (^)(id _Nonnull, NSInteger, NSInteger))block {
    self.hy_roundingIndexChange = [block copy];
    return self;
}
- (instancetype)scrollProgress:(void (^)(id _Nonnull, NSInteger, NSInteger, CGFloat))block {
    self.hy_scrollProgress = [block copy];
    return self;
}
- (instancetype)scrollDelegate:(id<HyCycleViewScrollDelegate>)delegate {
    self.hy_scrollDelegate = delegate;
    return self;
}
@end


@interface HyGestureColletionView : UICollectionView <UIGestureRecognizerDelegate>
@end
@implementation HyGestureColletionView
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan &&
            self.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}
@end

@interface HyCycleViewCell : UICollectionViewCell
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) BOOL isTempAddView;
@end
@implementation HyCycleViewCell
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                             indexPath:(NSIndexPath *)indexPath {
    HyCycleViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class)
    forIndexPath:indexPath];
    cell.indexPath = indexPath;
    return cell;
}
@end



@interface HyCycleView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) HyCycleViewConfigure *configure;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) HyGestureColletionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, HyCycleViewProvider<HyCycleView *> *> *viewProviderDict;
@property (nonatomic, strong) NSMutableIndexSet *didLoadIndexSet;
@property (nonatomic, assign) NSInteger totalIndexs;
@property (nonatomic, assign) NSInteger repeatCount;
@property (nonatomic, assign) BOOL isCycle;
@property (nonatomic, assign) BOOL isAutoCycle;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, assign) HyCycleViewDirection direction;
@property (nonatomic, assign) HyCycleViewLoadStyle loadStyle;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger roundingIndex;
@property (nonatomic, assign) NSInteger currentCycleIndex;
@property (nonatomic, assign) NSInteger targetIndex;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) CGFloat lastScrollProgress;
@property (nonatomic, assign) NSInteger lastFromIndex;
@property (nonatomic, assign) NSInteger lastToIndex;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) BOOL isNoAnimation;
@property (nonatomic, assign) CGFloat lastP;
@property (nonatomic, strong) NSIndexPath *lastViewWillAppearIndexPath;
@end

@implementation HyCycleView
#pragma mark — life cycle methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
    }
    return  self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    self.layout.itemSize = self.collectionView.bounds.size;
}

#pragma mark — public methods
- (void)reloadData {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    [self clearData];
    self.interval = self.configure.hy_interval;
    self.direction = self.configure.hy_direction;
    self.loadStyle = self.configure.hy_loadStyle;
    self.totalIndexs = self.configure.hy_totalIndexs ? self.configure.hy_totalIndexs(self) : 0;
    NSInteger startIndex = self.configure.hy_startIndex ? self.configure.hy_startIndex(self) : 0;
    if (startIndex > self.totalIndexs - 1) { startIndex = 0;}
    self.isCycle = self.totalIndexs > 1 && self.configure.hy_isCycle;
    self.isAutoCycle = self.configure.hy_isAutoCycle && self.totalIndexs > 1;
    self.repeatCount = self.isCycle ? 200 : 1;
    self.currentCycleIndex = (NSInteger)(self.repeatCount / 2) - (self.isReverse ? 1 : 0);
    self.targetIndex = startIndex;
    self.layout.scrollDirection =
    (self.direction == HyCycleViewDirectionLeft || self.direction == HyCycleViewDirectionRight) ?
    UICollectionViewScrollDirectionHorizontal :
    UICollectionViewScrollDirectionVertical;
    [self.collectionView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _scrollToIndex:self.totalIndexs * self.currentCycleIndex + self.indexWithIndex(startIndex)  animated:NO];
        if (self.isAutoCycle) {
            [self startTimer];
        }
    });
    
    dispatch_semaphore_signal(self.semaphore);
}

- (void)scrollToNextIndexWithAnimated:(BOOL)animated {
    NSInteger index = self.currentIndex + 1;
    if (index > self.totalIndexs - 1) {
        index = 0;
    }
    [self scrollToIndex:index animated:animated];
}

- (void)scrollToLastIndexWithAnimated:(BOOL)animated {
    NSInteger index = self.currentIndex - 1;
    if (index < 0) {
        index = self.totalIndexs - 1;
    }
    [self scrollToIndex:index animated:animated];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    
    if (index == self.currentIndex || index > self.totalIndexs - 1) {return;}

    [self closeAndOpenTimer];
    
    if (self.isCycle) {
        
        NSInteger cyclePage = [self getCurrentCycleIndex];
        if (index < self.currentIndex) {
            if (self.isReverse) {
                if (cyclePage - 1 < 0) {
                    [self _scrollToIndex:self.totalIndexs * (NSInteger)(self.repeatCount / 2) + self.indexWithIndex(self.currentIndex) animated:NO];
                }
                cyclePage = [self getCurrentCycleIndex];
                cyclePage -= 1;
            } else {
                if (cyclePage + 1 >= self.repeatCount) {
                    [self _scrollToIndex:self.totalIndexs * (NSInteger)(self.repeatCount / 2 - 1) + self.currentIndex animated:NO];
                }
                cyclePage = [self getCurrentCycleIndex];
                cyclePage += 1;
            }
        }
        
        int absInt = abs((int)(index - self.currentIndex));
        if (animated && ((absInt >= 2 || index < self.currentIndex) && !(self.currentIndex == self.totalIndexs - 1 && index == 0))) {
            UIView *view = self.viewAtIndex(self.currentIndex);
            NSInteger tempIndex = cyclePage * self.totalIndexs + self.indexWithIndex(index) + ((self.isReverse) ? 1 : - 1);
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:tempIndex inSection:0];
            self.isNoAnimation = YES;
            [self.collectionView performBatchUpdates:^{
                [self.collectionView scrollToItemAtIndexPath:indexPath
                                            atScrollPosition:self.scrollPosition
                                                    animated:NO];
            } completion:^(BOOL finished) {
                self.isNoAnimation = NO;
                HyCycleViewCell *cell = (id)[self.collectionView cellForItemAtIndexPath:indexPath];
                if (cell) {
                    [cell.contentView addSubview:view];
                    view.frame = cell.contentView.bounds;
                    cell.isTempAddView = YES;
                }
                [self _scrollToIndex:cyclePage * self.totalIndexs + self.indexWithIndex(index) animated:animated];
            }];
        } else {
            [self _scrollToIndex:cyclePage * self.totalIndexs + self.indexWithIndex(index) animated:animated];
        }
        
    } else {
        
        int absInt = abs((int)(index - self.currentIndex));
        if (animated && absInt >= 2) {
            UIView *view = self.viewAtIndex(self.currentIndex);
            NSInteger tempValue = self.isReverse ? -1 : 1;
            NSInteger tempIndex = index > self.currentIndex ? index - tempValue : index + tempValue;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:tempIndex inSection:0];
            [self.collectionView performBatchUpdates:^{
                self.isNoAnimation = YES;
                [self.collectionView scrollToItemAtIndexPath:indexPath
                                            atScrollPosition:self.scrollPosition
                                                    animated:NO];
            } completion:^(BOOL finished) {
                self.isNoAnimation = NO;
                HyCycleViewCell *cell = (id)[self.collectionView cellForItemAtIndexPath:indexPath];
                if (cell) {
                    [cell.contentView addSubview:view];
                    view.frame = cell.contentView.bounds;
                    cell.isTempAddView = YES;
                }
                [self _scrollToIndex:self.indexWithIndex(index) animated:animated];
            }];
        } else {
            [self _scrollToIndex:self.indexWithIndex(index) animated:animated];
        }
    }
}

#pragma mark — private methods
- (void)_scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    if (index > [self.collectionView numberOfItemsInSection:0] - 1) {
        return;
    }
    NSInteger targetIndex = self.indexWithIndex(index % self.totalIndexs);
    self.targetIndex = targetIndex;
    self.isNoAnimation = !animated;
    [self.collectionView performBatchUpdates:^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                    atScrollPosition:self.scrollPosition
                                            animated:animated];
    } completion:^(BOOL finished) {
        self.isNoAnimation = NO;
        if (!animated) {
            if (self.loadStyle == HyCycleViewLoadStyleDidAppear &&
                ![self.didLoadIndexSet containsIndex:index]) {
                self.targetIndex = targetIndex;
                [self addViewWithDidApper];
            }
            NSInteger lastIndex = self.currentIndex;
            [self handleRecycleWithIndex:index];
            [self updateCurrentIndex];
            [self updateCurrentCycleIndex];
            self.roundingIndex = self.currentIndex;
            if (lastIndex < 0) {
              lastIndex = self.currentIndex;
            }
            !self.configure.hy_scrollProgress ?:
            self.configure.hy_scrollProgress(self, lastIndex, self.currentIndex, 1.0);
        }
    }];
}

- (void)addViewForCell:(HyCycleViewCell *)cell
     isWillDisplayCell:(BOOL)flag {
    
    NSIndexPath *indexPath = cell.indexPath;
    NSInteger index = self.indexWithIndexPath(indexPath);
    if (index != self.targetIndex) {
        return;
    }
    
    UIView *view = self.viewAtIndex(index);
    BOOL hasLoad = [self.didLoadIndexSet containsIndex:index];
    if (flag &&
        !hasLoad &&
        self.loadStyle == HyCycleViewLoadStyleDidAppear) {
        return;
    }
        
    if (!hasLoad &&
        self.configure.hy_viewAtIndex) {
        [self.didLoadIndexSet addIndex:index];
        if (self.configure.hy_viewAtIndex) {
            id<HyCycleViewProviderProtocol> protocolObject = self.configure.hy_viewAtIndex(self, index);
            if (protocolObject && [protocolObject respondsToSelector:@selector(configCycleView:index:)]) {
                HyCycleViewProvider *provider = [[HyCycleViewProvider alloc] init];
                provider.index = index;
                [protocolObject configCycleView:provider index:index];
                if (provider.retainProvider) {
                    provider.protocolObject = protocolObject;
                }
                [self.viewProviderDict setObject:provider forKey:@(index)];
                if (provider.hy_view) {
                    view = provider.hy_view(self);
                    if ([view isKindOfClass:UIView.class]) {
                        provider.view = view;
                    }
                }
            }
        }
    }
    
    if ([view isKindOfClass:UIView.class]) {
        [cell.contentView addSubview:view];
        view.frame = cell.contentView.bounds;
        if (!(self.lastViewWillAppearIndexPath &&
             self.lastViewWillAppearIndexPath.row != indexPath.row &&
             self.indexWithIndexPath(self.lastViewWillAppearIndexPath) == index)) {
            [self viewProviderWithIndex:index handler:^(HyCycleViewProvider *provider) {
                !provider.hy_viewWillAppear ?:
                provider.hy_viewWillAppear(self, view, !hasLoad);
            }];
            !self.configure.hy_viewWillAppearAtIndex ?:
            self.configure.hy_viewWillAppearAtIndex(self, view, index, !
                                                    hasLoad);
        }
        self.lastViewWillAppearIndexPath = indexPath;
    }
}

- (void)viewProviderWithIndex:(NSInteger)index
                      handler:(void(^)(HyCycleViewProvider *provider))handler {
    HyCycleViewProvider *provider = [self.viewProviderDict objectForKey:@(index)];
    if (provider) {
        !handler ?: handler(provider);
    }
}

- (void)DidEndScroll {
    if (self.loadStyle == HyCycleViewLoadStyleDidAppear) {
        [self addViewWithDidApper];
    }
    [self updateCurrentIndex];
    [self updateCurrentCycleIndex];
}

- (void)clearData {
    self.currentIndex = -1;
    self.roundingIndex = -1;
    self.lastViewWillAppearIndexPath = nil;
    [self stopTimer];
    [self.viewProviderDict removeAllObjects];
    [self.didLoadIndexSet removeAllIndexes];
}

- (void)updateCurrentIndex {
    if (self.layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        NSInteger index = (int)(self.collectionView.contentOffset.x / self.collectionView.bounds.size.width) % self.totalIndexs;
        self.currentIndex = self.indexWithIndex(index);
    } else {
        NSInteger index = (int)(self.collectionView.contentOffset.y / self.collectionView.bounds.size.height) % self.totalIndexs;
        self.currentIndex = self.indexWithIndex(index);
    }
}

- (void)updateCurrentCycleIndex {
    self.currentCycleIndex = [self getCurrentCycleIndex];
}

- (void)addViewWithDidApper {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof HyCycleViewCell * _Nonnull obj,
                                                                       NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger index = self.indexWithIndexPath(obj.indexPath);
            if (![self.didLoadIndexSet containsIndex:index]) {
                [self addViewForCell:obj isWillDisplayCell:NO];
            }
        }];
    });
}

- (void)handleRecycleWithIndex:(NSInteger)index {
    if (self.isCycle) {
        if (self.isBoundary(index)) {
            NSInteger offsetIndex = - 1;
            if (index == 0) {
                offsetIndex = 0;
            }
            [self _scrollToIndex:(self.totalIndexs * ((NSInteger)self.repeatCount / 2)  + offsetIndex) animated:NO];
        }
    }
}

- (NSInteger)getCurrentCycleIndex {
    NSInteger index = 0;
    if (self.layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (self.collectionView.contentOffset.x / (self.collectionView.bounds.size.width * self.totalIndexs));
    } else {
        index = (self.collectionView.contentOffset.y / (self.collectionView.bounds.size.height * self.totalIndexs));
    }
    return MAX(0, index);
}

- (UIView *(^)(NSInteger))viewAtIndex {
    return ^UIView *(NSInteger index){
        HyCycleViewProvider *provider = [self.viewProviderDict objectForKey:@(index)];
        if (provider) {
            return provider.view;
        }
        return nil;
    };
}

- (NSInteger(^)(NSIndexPath *))indexWithIndexPath {
    return ^(NSIndexPath *indexPath){
        NSInteger index = indexPath.row % self.totalIndexs;
        if (self.isReverse) {
            index = self.totalIndexs - index - 1;
        }
        return index;
    };
}

- (NSInteger(^)(NSInteger))indexWithIndex {
    return ^(NSInteger index){
        if (self.isReverse) {
            index = self.totalIndexs - 1 - index;
        }
        if (index > self.totalIndexs - 1) {
            index = self.totalIndexs - 1 - index;
        }
        if (index < 0) {
            index = self.totalIndexs - 1 + index;
        }
        return index;
    };
}

- (UICollectionViewScrollPosition)scrollPosition {
    return 
    self.layout.scrollDirection == UICollectionViewScrollDirectionVertical ?
    UICollectionViewScrollPositionCenteredVertically :
    UICollectionViewScrollPositionCenteredHorizontally;
}

- (BOOL)isReverse {
    return self.direction == HyCycleViewDirectionRight || self.direction == HyCycleViewDirectionBottom;
}

- (BOOL (^)(CGFloat))isBoundary {
    return ^BOOL (CGFloat index){
        return index == 0 || index == [self.collectionView numberOfItemsInSection:0] - 1;
    };
}

#pragma mark — UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.totalIndexs * self.repeatCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [HyCycleViewCell cellWithCollectionView:collectionView
                                         indexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(HyCycleViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.isDragging || self.viewAtIndex(self.indexWithIndexPath(indexPath))) {
        self.targetIndex = self.indexWithIndexPath(indexPath);
    }
    [self addViewForCell:cell isWillDisplayCell:YES];
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(HyCycleViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!(self.isCycle && self.isBoundary(indexPath.row)) && !cell.isTempAddView) {
        if (cell.contentView.subviews.count) {
            NSInteger index = self.indexWithIndexPath(indexPath);
            [self viewProviderWithIndex:index handler:^(HyCycleViewProvider *provider) {
                !provider.hy_viewDidDisAppear ?: provider.hy_viewDidDisAppear(self, provider.view);
            }];
            UIView *view = self.viewAtIndex(index);
            if (view) {
                !self.configure.hy_viewDidDisAppearAtIndex ?:
                self.configure.hy_viewDidDisAppearAtIndex(self, view, index);
            }
        }
    }
    cell.isTempAddView = NO;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = self.indexWithIndexPath(indexPath);
    [self viewProviderWithIndex:index handler:^(HyCycleViewProvider *provider) {
        !provider.hy_viewClickAction ?:
        provider.hy_viewClickAction(self, self.viewAtIndex(index));
    }];
    !self.configure.hy_clickActionAtIndex ?:
    self.configure.hy_clickActionAtIndex(self, self.viewAtIndex(index), index);
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.isNoAnimation) {
        return;
    }
    
    CGFloat offset = scrollView.contentOffset.x / scrollView.bounds.size.width;
    if (self.layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        offset = scrollView.contentOffset.y / scrollView.bounds.size.height;
    }
    
    if (self.isCycle) {
       if (self.isBoundary(offset)) {
           NSInteger offsetIndex = - 1;
           if (offset == 0) {
               offsetIndex = 0;
           }
           [self _scrollToIndex:(self.totalIndexs * ((NSInteger)self.repeatCount / 2)  + offsetIndex) animated:NO];
       }
    }
            
    self.roundingIndex = self.indexWithIndex((int)(offset + 0.5) % self.totalIndexs);;
    
    if (scrollView.isDragging) {
        if (ceilf(offset) != ceilf(self.lastP) &&
            floorf(offset) != offset &&
            floorf(self.lastP) != self.lastP) {
            BOOL isStepScroll = NO;
            NSInteger tempIndex = 0;
            NSInteger fromIndex = 0;
            NSInteger toIndex = 0;
            if (offset > self.lastP) {
                tempIndex = self.indexWithIndex((int)offset % self.totalIndexs);
                isStepScroll = tempIndex != self.currentIndex;
                fromIndex = self.currentIndex;
                toIndex = tempIndex;
                
            } else {
                tempIndex = self.indexWithIndex((int)offset % self.totalIndexs + 1);
                isStepScroll = tempIndex != self.currentIndex;
                fromIndex = self.currentIndex;
                toIndex = tempIndex;
            }
            if (isStepScroll) {
                self.currentIndex = tempIndex;
                [self updateCurrentCycleIndex];
                !self.configure.hy_scrollProgress ?:
                self.configure.hy_scrollProgress(self, fromIndex, toIndex, 1.0);
            }
            self.lastScrollProgress = 0.0;
        }
    }
    self.lastP = offset;
    
    if (self.configure.hy_scrollProgress) {
        
        NSInteger fromIndex = 0;
        NSInteger toIndex = 0;
        CGFloat progress = 0.0;
        CGFloat scrollProgress = offset - self.currentCycleIndex  * self.totalIndexs - self.indexWithIndex(self.currentIndex);
        int intProgress = (int)scrollProgress;
        scrollProgress = scrollProgress - intProgress;

        if (scrollProgress < 0) {
            NSInteger tempIndex = self.isReverse ?  1 :  - 1;
            NSInteger tempIntProgress = self.isReverse ? - intProgress : intProgress;
            NSInteger lastIndex = self.currentIndex + tempIndex + tempIntProgress;
            if (lastIndex < 0) {
                lastIndex = self.indexWithIndex(self.totalIndexs + lastIndex);
            }
            lastIndex = lastIndex % self.totalIndexs;
            
            if (scrollProgress <= self.lastScrollProgress) {
                fromIndex = self.currentIndex;
                toIndex = lastIndex;
                progress = - scrollProgress;
            } else {
                fromIndex = lastIndex;
                toIndex = self.currentIndex;
                progress = 1 + scrollProgress;
            }
            
        } else if (scrollProgress > 0) {
            
            NSInteger tempIndex = self.isReverse ?  - 1 :  1;
            NSInteger tempIntProgress = self.isReverse ?  - intProgress :  intProgress;
            NSInteger nexIndex = self.currentIndex + tempIndex + tempIntProgress;
            if (nexIndex < 0) {
                nexIndex = self.totalIndexs + nexIndex;
            }
            nexIndex = nexIndex % self.totalIndexs;
            if (scrollProgress >= self.lastScrollProgress) {
                fromIndex = self.currentIndex;
                toIndex = nexIndex;
                progress = scrollProgress;
            } else {
                fromIndex = nexIndex;
                toIndex = self.currentIndex;
                progress = 1 - scrollProgress;
            }

        } else {
            progress = 1;
            fromIndex = self.lastFromIndex;
            toIndex = self.lastToIndex;
            [self updateCurrentIndex];
            [self updateCurrentCycleIndex];
        }

        if (fromIndex != toIndex) {
            self.configure.hy_scrollProgress(self, fromIndex, toIndex, progress);
        }
        self.lastScrollProgress = scrollProgress;
        self.lastFromIndex = fromIndex;
        self.lastToIndex = toIndex;
    }
    
    if ([self.configure.hy_scrollDelegate respondsToSelector:@selector(scrollViewDidScroll:cycleView:)]) {
        [self.configure.hy_scrollDelegate scrollViewDidScroll:scrollView cycleView:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isAutoCycle) {
        [self stopTimer];
    }
    if ([self.configure.hy_scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:cycleView:)]) {
        [self.configure.hy_scrollDelegate scrollViewWillBeginDragging:scrollView cycleView:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isAutoCycle) {
        [self startTimer];
    }
    if (decelerate == 0) {
        [self DidEndScroll];
    }
    if ([self.configure.hy_scrollDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:cycleView:)]) {
        [self.configure.hy_scrollDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate cycleView:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self DidEndScroll];
    if ([self.configure.hy_scrollDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:cycleView:)]) {
        [self.configure.hy_scrollDelegate scrollViewDidEndDecelerating:scrollView cycleView:self];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self DidEndScroll];
    if ([self.configure.hy_scrollDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:cycleView:)]) {
        [self.configure.hy_scrollDelegate scrollViewDidEndScrollingAnimation:scrollView cycleView:self];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.configure.hy_scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:cycleView:)]) {
        [self.configure.hy_scrollDelegate scrollViewWillBeginDecelerating:scrollView cycleView:self];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self.configure.hy_scrollDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:cycleView:)]) {
        [self.configure.hy_scrollDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset cycleView:self];
    }
}

#pragma mark — timer
- (void)next {
    [self scrollToNextIndexWithAnimated:YES];
}

- (void)closeAndOpenTimer {
    if (self.isAutoCycle) {
        [self stopTimer];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                   (int64_t)(.25 * NSEC_PER_SEC)),
                     dispatch_get_main_queue(), ^{
                         [self startTimer];
                     });
    }
}

- (void)startTimer {
    [self stopTimer];
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer,
                              dispatch_time(DISPATCH_TIME_NOW, self.interval * NSEC_PER_SEC),
                              self.interval * NSEC_PER_SEC,
                              0 * NSEC_PER_SEC);
    __weak typeof(self) _self = self;
    dispatch_source_set_event_handler(self.timer,
                                      ^{
                                          @autoreleasepool{
                                              __strong typeof(_self) self = _self;
                                              [self next];
                                          }
                                      });
    dispatch_resume(self.timer);
}

- (void)stopTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = NULL;
    }
}

#pragma mark — getters and setters
- (HyCycleViewConfigure *)configure {
    if (!_configure){
        _configure = [[HyCycleViewConfigure alloc] init];
    }
    return _configure;
}

- (HyGestureColletionView *)collectionView {
    if (!_collectionView){
        _collectionView = [[HyGestureColletionView alloc] initWithFrame:self.bounds
                                                   collectionViewLayout:self.layout];
        [_collectionView registerClass:[HyCycleViewCell class] forCellWithReuseIdentifier:NSStringFromClass(HyCycleViewCell.class)];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces = NO;
        if (@available(iOS 10.0, *)) {
            _collectionView.prefetchingEnabled = NO;
        }
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout){
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.sectionInset = UIEdgeInsetsZero;
        _layout.itemSize = self.bounds.size;
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
    }
    return _layout;
}

- (NSMutableDictionary<NSNumber *,HyCycleViewProvider<HyCycleView *> *> *)viewProviderDict {
    if (!_viewProviderDict) {
        _viewProviderDict = @{}.mutableCopy;
    }
    return _viewProviderDict;
}

- (NSMutableIndexSet *)didLoadIndexSet {
    if (!_didLoadIndexSet) {
        _didLoadIndexSet = [[NSMutableIndexSet alloc] init];
    }
    return _didLoadIndexSet;
}

- (dispatch_semaphore_t)semaphore{
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(1);
    }
    return _semaphore;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (currentIndex == _currentIndex) {
        return;
    }
    _currentIndex = currentIndex;

    if (currentIndex >= 0) {
        !self.configure.hy_currentIndexChange ?:
        self.configure.hy_currentIndexChange(self, self.totalIndexs, currentIndex);
    }
}

- (void)setRoundingIndex:(NSInteger)roundingIndex {
    if (_roundingIndex == roundingIndex) {
        return;
    }
    _roundingIndex = roundingIndex;
    if (roundingIndex >= 0) {
        !self.configure.hy_roundingIndexChange ?:
        self.configure.hy_roundingIndexChange(self, self.totalIndexs, roundingIndex);
    }
}

- (NSArray<NSNumber *> *)visibleIndexs {
    NSMutableArray *array = @[].mutableCopy;
    for (HyCycleViewCell *cell in self.collectionView.visibleCells) {
        [array addObject:@(self.indexWithIndexPath(cell.indexPath))];
    }
    return array.copy;
}

- (NSArray<UIView *> *)visibleViews {
    NSMutableArray *array = @[].mutableCopy;
    for (NSNumber *index in self.visibleIndexs) {
        [array addObject:self.viewAtIndex(index.integerValue) ?: UIView.new];
    }
    return array.copy;
}

- (NSIndexSet *)didLoadIndexs {
    return self.didLoadIndexSet.copy;
}

@end
