//
//  HyCyclePageView.m
//  HyCycleView
//  https://github.com/hydreamit/HyCycleView
//
//  Created by Hy on 2016/5/15.
//  Copyright © 2016年 Hy. All rights reserved.
//

#import "HyCyclePageView.h"

@interface HyCycleViewProvider ()
@property (nonatomic,weak) UIView *view;
@property (nonatomic,strong) id protocolObject;
@property (nonatomic,copy) UIView *(^hy_view)(id);
@property (nonatomic,copy) void (^hy_viewWillAppear)(id, id, BOOL);
@property (nonatomic,copy) void (^hy_viewDidDisAppear)(id, id);
@property (nonatomic,copy) void (^hy_viewClickAction)(id, id);
@end


@interface HyCyclePageViewConfigure ()
@property (nonatomic, assign) BOOL hy_isCycle;
@property (nonatomic, assign) BOOL hy_isAutoCycle;
@property (nonatomic, assign) NSTimeInterval hy_interval;
@property (nonatomic, assign) HyCycleViewDirection hy_direction;
@property (nonatomic, assign) HyCycleViewLoadStyle hy_loadStyle;
@property (nonatomic, copy) NSInteger (^hy_totalIndexs)(id);
@property (nonatomic, copy) NSInteger (^hy_startIndex)(id);
@property (nonatomic, copy) id (^hy_viewAtIndex)(id, NSInteger);
@property (nonatomic, copy) void(^hy_viewWillAppearAtIndex)(id, id, NSInteger, BOOL);
@property (nonatomic, copy) void(^hy_viewDidDisAppearAtIndex)(id, id, NSInteger);
@property (nonatomic, copy) void(^hy_clickActionAtIndex)(id, id, NSInteger);
@property (nonatomic, copy) void(^hy_currentIndexChange)(id, NSInteger, NSInteger);
@property (nonatomic, copy) void(^hy_roundingIndexChange)(id, NSInteger, NSInteger);
@property (nonatomic, copy) void(^hy_scrollProgress)(id, NSInteger, NSInteger, CGFloat);

@property (nonatomic,strong) UIView *hy_headerView;
@property (nonatomic,assign) CGFloat hy_headerViewHeight;

@property (nonatomic,strong) UIView *hy_hoverView;
@property (nonatomic,assign) CGFloat hy_hoverViewHeight;
@property (nonatomic,assign) CGFloat hy_hoverOffset;

@property (nonatomic,assign) HyCyclePageViewHeaderRefreshPosition hy_headerRefreshPosition;
@property (nonatomic,assign) HyCyclePageViewHeaderViewUpAnimation hy_headerViewUpAnimation;
@property (nonatomic,assign) HyCyclePageViewHeaderViewDownAnimation hy_headerViewDownAnimation;
@property (nonatomic,copy) void (^hy_headerRefreshAtIndex)(HyCyclePageView *,
                                                            UIScrollView * ,
                                                            UIView *,
                                                            NSInteger);
@property (nonatomic,copy) void (^hy_footerRefreshAtIndex)(HyCyclePageView *,
                                                            UIScrollView * ,
                                                            UIView *,
                                                            NSInteger);
@property (nonatomic,copy) void (^hy_verticalScrollProgress)(HyCyclePageView *,
                                                            UIView *,
                                                            NSInteger,
                                                            CGFloat
                                                            );
@property (nonatomic, weak) HyCyclePageView *cyclePageView;
@end


#define Hy_HeaderViewTag 66
#define Hy_HoverViewTag 88
@interface HyCyclePageView () <HyCycleViewProviderProtocol>
@property (nonatomic,strong) HyCycleView *cycleView;
@property (nonatomic,strong) UIView *headerContentView;
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) HyCyclePageViewConfigure *configure;
@property (nonatomic,strong) NSMutableDictionary<NSNumber *, UIScrollView *> *pageScrollViewsDict;
@property (nonatomic,strong) NSMutableDictionary<NSNumber *, HyCycleViewProvider<HyCyclePageView *> *> *viewProviderDict;
@property (nonatomic,strong) NSMutableDictionary<NSNumber *, NSArray<UIGestureRecognizer *> *> *panGesturesDict;
@property (nonatomic,assign) CGFloat insetTop;
@property (nonatomic,assign) CGFloat contentOffset;
@property (nonatomic,strong) dispatch_semaphore_t semaphore;
@property (nonatomic,assign) BOOL noNeedsLayout;
@property (nonatomic,strong) NSArray *observers;
@end

@implementation HyCyclePageView

#pragma mark — life cycle methods
- (void)willMoveToSuperview:(UIView *)newSuperview {
        
    [super willMoveToSuperview:newSuperview];
    if (newSuperview && !self.contentScrollView.superview) {
        [self addSubview:self.contentScrollView];
        
        id (^observerBlock)(NSNotificationName, void(^usingBlock)(NSNotification *)) =
        ^(NSNotificationName name, void(^usingBlock)(NSNotification *)){
            return [[NSNotificationCenter defaultCenter]
                        addObserverForName:name
                                    object:nil
                                     queue:[NSOperationQueue mainQueue]
                                usingBlock:usingBlock];
        };
        
        __weak typeof(self) _self = self;
        self.observers =
        @[observerBlock(UIApplicationDidEnterBackgroundNotification, ^(NSNotification *note){
            __strong typeof(_self) self = _self;
            self.noNeedsLayout = YES;
        }), observerBlock(UIApplicationDidBecomeActiveNotification, ^(NSNotification *note){
            __strong typeof(_self) self = _self;
            self.noNeedsLayout = NO;
        })];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.noNeedsLayout) {
        return;
    }
    
    self.contentScrollView.frame = self.bounds;
    
    self.headerContentView.frame = CGRectMake(0, self.headerContentView.top, CGRectGetWidth(self.contentScrollView.bounds), CGRectGetHeight(self.configure.hy_headerView.bounds) + CGRectGetHeight(self.configure.hy_hoverView.bounds));
    if (self.configure.hy_headerView) {
        self.configure.hy_headerView.frame = CGRectMake(0, self.configure.hy_headerView.top, CGRectGetWidth(self.headerContentView.bounds), CGRectGetHeight(self.configure.hy_headerView.bounds));
    }
    if (self.configure.hy_hoverView) {
        self.configure.hy_hoverView.frame = CGRectMake(0, CGRectGetMaxY(self.configure.hy_headerView.frame), CGRectGetWidth(self.headerContentView.bounds), CGRectGetHeight(self.configure.hy_hoverView.bounds));
    }
    self.cycleView.frame = self.contentScrollView.bounds;
    [self updateCyclePageScrollViewContentInset];
}

#pragma mark — public methods
- (void)scrollToNextIndexWithAnimated:(BOOL)animated {
    [self.cycleView scrollToNextIndexWithAnimated:animated];
}

- (void)scrollToLastIndexWithAnimated:(BOOL)animated {
    [self.cycleView scrollToLastIndexWithAnimated:animated];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    [self.cycleView scrollToIndex:index animated:animated];
}

- (void)reloadData {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    [self.pageScrollViewsDict.allValues enumerateObjectsUsingBlock:^(UIScrollView *obj,
                                                                     NSUInteger idx,
                                                                     BOOL *stop) {
        [obj removeObserver:self forKeyPath:@"contentOffset"];
    }];
    [self.pageScrollViewsDict removeAllObjects];
    [self.viewProviderDict removeAllObjects];
    [self.panGesturesDict removeAllObjects];
    [self.cycleView reloadData];
    
    dispatch_semaphore_signal(self.semaphore);
}

- (void)updateContentInsetTop:(CGFloat)top {
    self.insetTop = top;
    [self.pageScrollViewsDict.allValues enumerateObjectsUsingBlock:^(UIScrollView *obj,
                                                                    NSUInteger idx,
                                                                    BOOL *stop) {
         if ([obj isKindOfClass:UIScrollView.class]) {
             obj.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.headerContentView.bounds) + self.insetTop, 0, 0, 0);
         }
    }];
}

- (void)updateContentOffSetY:(CGFloat)contentOffsetY
                   animation:(BOOL)flag {
    UIScrollView *scrollView = [self.pageScrollViewsDict objectForKey:@(self.cycleView.currentIndex)];
    if ([scrollView isKindOfClass:UIScrollView.class]) {
        [scrollView setContentOffset:CGPointMake(0, - CGRectGetHeight(self.headerContentView.bounds) + contentOffsetY) animated:flag];
    }
}

#pragma mark — private methods
- (void)updateHeaderViewWithNewView:(UIView *)newView
                            oldView:(UIView *)oldView {
    
    [oldView removeFromSuperview];
    CGRect tempRect;
    if (newView) {
        newView.tag = Hy_HeaderViewTag;
        newView.frame = CGRectMake(0, 0, CGRectGetWidth(self.headerContentView.bounds), CGRectGetHeight(newView.bounds));
        [self.headerContentView addSubview:newView];
        if (self.configure.hy_hoverView) {
            tempRect = self.configure.hy_hoverView.frame;
            tempRect.origin.y = CGRectGetMaxY(newView.frame);
            self.configure.hy_hoverView.frame = tempRect;
        }
    }
    tempRect = self.headerContentView.frame;
    tempRect.size.height = CGRectGetHeight(newView.bounds) + CGRectGetHeight(self.configure.hy_hoverView.bounds);
    self.headerContentView.frame = tempRect;
    [self updateCyclePageScrollViewContentInset];
}

- (void)updateHeaderViewHeight {
    
    if (!self.configure.hy_headerView) {
        return;
    }
    
    CGRect tempRect = self.configure.hy_headerView.frame;
    tempRect.size.height = self.configure.hy_headerViewHeight;
    self.configure.hy_headerView.frame = tempRect;
    if (self.configure.hy_hoverView) {
        tempRect = self.configure.hy_hoverView.frame;
        tempRect.origin.y = self.configure.hy_headerViewHeight;
        self.configure.hy_hoverView.frame = tempRect;
    }
    tempRect = self.headerContentView.frame;
    tempRect.size.height = CGRectGetHeight(self.configure.hy_headerView.bounds) + CGRectGetHeight(self.configure.hy_hoverView.bounds);
    self.headerContentView.frame = tempRect;
    [self updateCyclePageScrollViewContentInset];
}

- (void)updateHoverViewWithNewView:(UIView *)newView
                           oldView:(UIView *)oldView {
    
    [oldView removeFromSuperview];
    if (newView) {
        newView.tag = Hy_HoverViewTag;
        newView.frame = CGRectMake(0, CGRectGetMaxY(self.configure.hy_headerView.frame), CGRectGetWidth(self.headerContentView.bounds), CGRectGetHeight(newView.frame));
        [self.headerContentView addSubview:newView];
    }
    CGRect tempRect = self.headerContentView.frame;
    tempRect.size.height = CGRectGetHeight(newView.bounds) + CGRectGetHeight(self.configure.hy_hoverView.bounds);
    self.headerContentView.frame = tempRect;
    [self updateCyclePageScrollViewContentInset];
}

- (void)updateHoverViewHeight {
    
    if (!self.configure.hy_hoverView) {
        return;
    }
    
    CGRect tempRect = self.configure.hy_hoverView.frame;
    tempRect.size.height = self.configure.hy_hoverViewHeight;
    self.configure.hy_hoverView.frame = tempRect;
    
    tempRect = self.headerContentView.frame;
    tempRect.size.height = CGRectGetHeight(self.configure.hy_headerView.bounds) + CGRectGetHeight(self.configure.hy_hoverView.bounds);
    self.headerContentView.frame = tempRect;
    [self updateCyclePageScrollViewContentInset];
}

- (void)updateCyclePageScrollViewContentInset {
    [self.pageScrollViewsDict.allValues enumerateObjectsUsingBlock:^(UIScrollView *obj,
                                                                     NSUInteger idx,
                                                                     BOOL *stop) {
        if ([obj isKindOfClass:UIScrollView.class]) {
            obj.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.headerContentView.bounds) + self.insetTop, 0, 0, 0);
            obj.contentOffset = [self getCurrentContentOffset];
        }
    }];
}

- (CGPoint)getCurrentContentOffset {
    
    CGFloat contentOffsetY = - (self.headerContentView.frame.origin.y + CGRectGetHeight(self.headerContentView.bounds));
    CGFloat hoverContentOffsetY = -(CGRectGetHeight(self.configure.hy_hoverView.bounds) + self.configure.hy_hoverOffset);
    
//    CGFloat maxContentOffset = self.pageScrollViewsDict[@(self.currentIndex)].contentSize.height - CGRectGetHeight(self.headerContentView.bounds);
//    if (maxContentOffset < hoverContentOffsetY) {
//        hoverContentOffsetY = maxContentOffset;
//    }

    return CGPointMake(0, contentOffsetY >= hoverContentOffsetY ? hoverContentOffsetY : contentOffsetY);
}

- (void)handleViewWithContainScrollView:(UIScrollView *)containScrollView
                                  index:(NSInteger)index {
    
    containScrollView.showsHorizontalScrollIndicator = NO;
    containScrollView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        containScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    UIView *view = nil;
    if (self.configure.hy_viewAtIndex) {
        id<HyCyclePageViewProviderProtocol> protocolObject = self.configure.hy_viewAtIndex(self, index);
        if ([protocolObject respondsToSelector:@selector(configCyclePageView:index:)]) {
            HyCycleViewProvider<HyCyclePageView *> *viewProvider = [[HyCycleViewProvider alloc] init];
            [protocolObject configCyclePageView:viewProvider index:index];
            if (viewProvider.retainProvider) {
                viewProvider.protocolObject = protocolObject;
            }
            UIView *tempView = viewProvider.hy_view(self);
            if ([tempView isKindOfClass:UIView.class]) {
                view = tempView;
                viewProvider.view = tempView;
                [self.viewProviderDict setObject:viewProvider forKey:@(index)];
            }
        }
    }
    
    if (!view) {return;}
    
    UIScrollView *observeScrollView = nil;
    if ([view isKindOfClass:UIScrollView.class]) {
        
        containScrollView.bounces = NO;
        containScrollView.scrollEnabled = NO;
        NSMutableArray *list = [NSMutableArray arrayWithArray:containScrollView.gestureRecognizers];
        [list enumerateObjectsUsingBlock:^(UIGestureRecognizer *obj,
                                           NSUInteger idx,
                                           BOOL * stop) {
            [containScrollView removeGestureRecognizer:obj];
        }];
        
        UIScrollView *scrollView = (UIScrollView *)view;
        scrollView.alwaysBounceVertical = YES;
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        scrollView.frame = self.contentScrollView.bounds;
        [containScrollView addSubview:scrollView];
        observeScrollView = scrollView;
        
    } else {
        
        containScrollView.bounces = YES;
        containScrollView.alwaysBounceVertical = YES;
        
        CGFloat minHeight = CGRectGetHeight(containScrollView.bounds) - self.configure.hy_hoverOffset - CGRectGetHeight(self.configure.hy_hoverView.bounds);
      
        if (CGRectGetHeight(view.bounds) >= minHeight) {
            
            containScrollView.contentSize = CGSizeMake(0, CGRectGetHeight(view.bounds));
            view.frame = CGRectMake(0, 0, CGRectGetWidth(containScrollView.bounds), CGRectGetHeight(view.bounds));
            [containScrollView addSubview:view];
            
        } else {
            
            UIView *containView = UIView.new;
            containView.frame = CGRectMake(0, 0, CGRectGetWidth(containScrollView.bounds), minHeight);
            [containScrollView addSubview:containView];
            containScrollView.contentSize = CGSizeMake(0, CGRectGetHeight(containView.bounds));
            
            view.frame = CGRectMake(0, 0, CGRectGetWidth(containScrollView.bounds), CGRectGetHeight(view.bounds));
            [containView addSubview:view];
            containView.backgroundColor = view.backgroundColor;

        }
        observeScrollView = containScrollView;
    }
   
    if (observeScrollView) {
        
        [self.panGesturesDict setObject:observeScrollView.gestureRecognizers forKey:@(index)];
        [self.pageScrollViewsDict setObject:observeScrollView forKey:@(index)];
        [self handleRefreshWithScrollView:observeScrollView index:index];
        
        observeScrollView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.headerContentView.bounds) + self.insetTop, 0, 0, 0);
        observeScrollView.contentOffset = [self getCurrentContentOffset];
        [observeScrollView addObserver:self
                            forKeyPath:@"contentOffset"
                               options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                               context:(__bridge void * _Nullable)(@(index))];
    }
}

- (void)handleRefreshWithScrollView:(UIScrollView *)scrollView index:(NSInteger)index {
    !self.configure.hy_headerRefreshAtIndex ?:
    self.configure.hy_headerRefreshAtIndex(self, scrollView, self.viewAtIndex(index), index);
    !self.configure.hy_footerRefreshAtIndex ?:
    self.configure.hy_footerRefreshAtIndex(self, scrollView, self.viewAtIndex(index), index);
}

- (UIView *(^)(NSInteger))viewAtIndex {
    return ^UIView *(NSInteger index){
        HyCycleViewProvider<HyCyclePageView *> *provider = [self.viewProviderDict objectForKey:@(index)];
        if (provider) {
            return provider.view;
        }
        return nil;
    };
}

- (void)configCycleView:(HyCycleViewProvider<HyCycleView *> *)provider index:(NSInteger)index {
    __weak typeof(self) _self = self;
    [provider view:^UIView * _Nonnull(HyCycleView * _Nonnull cycleView) {
        __strong typeof(_self) self = _self;
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = self.bounds;
        return scrollView;
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(UIScrollView *)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    CGPoint newContentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
    CGPoint oldContentOffset = [change[NSKeyValueChangeOldKey] CGPointValue];
    NSInteger currentIndex =  [((NSNumber *)(__bridge typeof(NSNumber *))context) integerValue];
    
    if (newContentOffset.y == oldContentOffset.y) {return;}
    if (CGRectGetHeight(self.configure.hy_headerView.bounds)) {
        
        CGFloat contentTop = CGRectGetHeight(self.headerContentView.bounds);
        
        if (contentTop) {
            
            CGFloat hoverOffset = (CGRectGetHeight(self.configure.hy_hoverView.bounds) + self.configure.hy_hoverOffset);
            if (newContentOffset.y >= - hoverOffset) {
                
                CGRect rect = self.headerContentView.frame;
                rect.origin.y = - (contentTop - hoverOffset);
                self.headerContentView.frame = rect;
                
            } else if (newContentOffset.y <= - contentTop) {
                
                if (self.configure.hy_headerRefreshPosition == HyCyclePageViewHeaderRefreshPositionCenter) {
                    self.headerContentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentScrollView.bounds), CGRectGetHeight(self.configure.hy_headerView.bounds) + CGRectGetHeight(self.configure.hy_hoverView.bounds));
                    self.configure.hy_headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.headerContentView.bounds), CGRectGetHeight(self.configure.hy_headerView.bounds));
                    self.configure.hy_hoverView.frame = CGRectMake(0, CGRectGetMaxY(self.configure.hy_headerView.frame), CGRectGetWidth(self.headerContentView.bounds), CGRectGetHeight(self.configure.hy_hoverView.bounds));
                    
                  } else {
                      
                      CGRect tempRect = self.headerContentView.frame;
                      tempRect.origin.y = - contentTop - newContentOffset.y;;
                      self.headerContentView.frame = tempRect;
                      if (self.configure.hy_headerViewDownAnimation == HyCyclePageViewHeaderViewDownAnimationScale) {
                          self.headerContentView.clipsToBounds = NO;
                          if (self.configure.hy_headerView) {
                              CGFloat heigth = CGRectGetHeight(self.headerContentView.bounds) - CGRectGetHeight(self.configure.hy_hoverView.bounds);
                              CGFloat top = CGRectGetMinY(self.headerContentView.frame);
                              CGFloat width = CGRectGetWidth(self.headerContentView.frame);
                              self.configure.hy_headerView.frame = CGRectMake(- top / 2, - top, width + top, heigth + top);
                          }
                          if (self.configure.hy_hoverView) {
                              tempRect = self.configure.hy_hoverView.frame;
                              tempRect.origin.y = CGRectGetMaxY(self.configure.hy_headerView.frame);
                              self.configure.hy_hoverView.frame = tempRect;
                          }
                      }
                  }
            } else {
                
                CGRect tempRect = self.headerContentView.frame;
                tempRect.origin.y = - contentTop - newContentOffset.y;;
                self.headerContentView.frame = tempRect;
                CGFloat topValue = CGRectGetMinY(self.configure.hy_headerView.frame);
                if (self.configure.hy_headerViewUpAnimation == HyCyclePageViewHeaderViewUpAnimationCover &&
                    self.configure.hy_headerView) {
                    self.headerContentView.clipsToBounds = YES;
                    topValue = - CGRectGetMinY(self.headerContentView.frame) * 2 / 3;
                }
                tempRect = self.configure.hy_headerView.frame;
                tempRect.size.height = CGRectGetHeight(self.headerContentView.frame) - CGRectGetHeight(self.configure.hy_hoverView.frame);
                tempRect.origin.y = topValue;
                self.configure.hy_headerView.frame = tempRect;
            }
            
            if (currentIndex == self.cycleView.currentIndex) {
                if (newContentOffset.y <= - hoverOffset) {
                    if (newContentOffset.y >= - CGRectGetHeight(self.headerContentView.frame)) {
                        [self.pageScrollViewsDict.allValues enumerateObjectsUsingBlock:^(UIScrollView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (object != obj) {
                                if (obj.contentOffset.y >= - CGRectGetHeight(self.headerContentView.frame)) {
                                    obj.contentOffset = newContentOffset;
                                }
                            }
                        }];
                    }
                    
                } else {
                    [self.pageScrollViewsDict.allValues enumerateObjectsUsingBlock:^(UIScrollView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (object != obj) {
                            if (obj.contentOffset.y < - hoverOffset) {
                                obj.contentOffset = CGPointMake(0, -hoverOffset);
                            };
                        }
                    }];
                }
            }
        }
    }
        
    if (currentIndex == self.cycleView.currentIndex) {
        
        !self.configure.hy_verticalScrollProgress ?:
        self.configure.hy_verticalScrollProgress(self, self.viewAtIndex(currentIndex), currentIndex, newContentOffset.y + object.contentInset.top);
        
        if ([self.headerView conformsToProtocol:@protocol(HyCyclePageViewScrollProgressProtocol)] &&
           [self.headerView respondsToSelector:@selector(hy_verticalScrollProgress)]) {
            !((id<HyCyclePageViewScrollProgressProtocol>)self.headerView).hy_verticalScrollProgress ?:
           ((id<HyCyclePageViewScrollProgressProtocol>)self.headerView).hy_verticalScrollProgress(self, self.viewAtIndex(currentIndex), currentIndex, newContentOffset.y + object.contentInset.top);
        }
        
        if ([self.hoverView conformsToProtocol:@protocol(HyCyclePageViewScrollProgressProtocol)] &&
           [self.hoverView respondsToSelector:@selector(hy_verticalScrollProgress)]) {
           !((id<HyCyclePageViewScrollProgressProtocol>)self.hoverView).hy_verticalScrollProgress ?:
           ((id<HyCyclePageViewScrollProgressProtocol>)self.hoverView).hy_verticalScrollProgress(self, self.viewAtIndex(currentIndex), currentIndex, newContentOffset.y + object.contentInset.top);
        }
    }
}

#pragma mark - getters and setters
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView){
        _contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.bounces = NO;
        if (@available(iOS 11.0, *)) {
            _contentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_contentScrollView addSubview:self.cycleView];
        [_contentScrollView addSubview:self.headerContentView];
    }
    return _contentScrollView;
}

- (HyCycleView *)cycleView {
    if (!_cycleView) {
        
        __weak typeof(self) _self = self;
        _cycleView = [[HyCycleView alloc] initWithFrame:CGRectZero];
        [_cycleView.configure loadStyle:HyCycleViewLoadStyleDidAppear];
        [[[[[[[[[[[[[_cycleView.configure isCycle:self.configure.hy_isCycle] isAutoCycle:self.configure.hy_isAutoCycle] interval:self.configure.hy_interval] loadStyle:self.configure.hy_loadStyle] startIndex:self.configure.hy_startIndex] totalIndexs:self.configure.hy_totalIndexs] viewProviderAtIndex:^id<HyCycleViewProviderProtocol> _Nonnull(HyCycleView * _Nonnull cycleView, NSInteger index) {
            __strong typeof(_self) self = _self;
            return self;
        }] viewWillAppearAtIndex:^(HyCycleView * _Nonnull cycleView, id  _Nonnull view, NSInteger index, BOOL isFirstLoad) {
            __strong typeof(_self) self = _self;
            if (isFirstLoad) {
                [self handleViewWithContainScrollView:view
                                                index:index];
            }
            !self.configure.hy_viewWillAppearAtIndex ?:
            self.configure.hy_viewWillAppearAtIndex(self, self.viewAtIndex(index), index, isFirstLoad);
        }] viewDidDisAppearAtIndex:^(HyCycleView * _Nonnull cycleView, id  _Nonnull view, NSInteger index) {
            __strong typeof(_self) self = _self;
            !self.configure.hy_viewDidDisAppearAtIndex ?:
            self.configure.hy_viewDidDisAppearAtIndex(self, view, index);
        }] clickActionAtIndex:^(HyCycleView * _Nonnull cycleView, id  _Nonnull view, NSInteger index) {
            __strong typeof(_self) self = _self;
            !self.configure.hy_clickActionAtIndex ?:
            self.configure.hy_clickActionAtIndex(self, view, index);
        }] currentIndexChange:^(HyCycleView * _Nonnull cycleView, NSInteger indexs, NSInteger index) {
            __strong typeof(_self) self = _self;
            if (CGRectGetHeight(self.configure.hy_headerView.bounds)) {
                void (^handleGesture)(void) = ^{
                    NSArray *panGes = [self.panGesturesDict objectForKey:@(index)];
                    if (panGes) {
                        NSMutableArray *list = [NSMutableArray arrayWithArray:self.contentScrollView.gestureRecognizers];
                        for (UIGestureRecognizer *gestureRecognizer in list) {
                            [self.contentScrollView removeGestureRecognizer:gestureRecognizer];
                        }
                        [self.pageScrollViewsDict.allValues enumerateObjectsUsingBlock:^(UIScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            for (UIGestureRecognizer *gestureRecognizer in panGes) {
                                [obj addGestureRecognizer:gestureRecognizer];
                            };
                        }];
                        for (UIGestureRecognizer *gestureRecognizer in panGes) {
                            [self.contentScrollView addGestureRecognizer:gestureRecognizer];
                        };
                    }
                };
                NSTimeInterval time = self.configure.hy_loadStyle == HyCycleViewLoadStyleDidAppear ? 0.05 : 0.05;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                             (int64_t)(time * NSEC_PER_SEC)),
                               dispatch_get_main_queue(), handleGesture);
            }
            !self.configure.hy_currentIndexChange ?:
            self.configure.hy_currentIndexChange(self, indexs, index);
        }] roundingIndexChange:^(HyCycleView * _Nonnull cycleView, NSInteger indexs, NSInteger roundingIndex) {
            __strong typeof(_self) self = _self;
            !self.configure.hy_roundingIndexChange ?:
            self.configure.hy_roundingIndexChange(self, indexs, roundingIndex);
        }] scrollProgress:^(HyCycleView * _Nonnull cycleView, NSInteger fromIndex, NSInteger toIndex, CGFloat progress) {
            __strong typeof(_self) self = _self;
            !self.configure.hy_scrollProgress ?:
            self.configure.hy_scrollProgress(self, fromIndex, toIndex, progress);
            if ([self.headerView conformsToProtocol:@protocol(HyCyclePageViewScrollProgressProtocol)] &&
                [self.headerView respondsToSelector:@selector(hy_horizontalScrollProgress)]) {
                !((id<HyCyclePageViewScrollProgressProtocol>)self.headerView).hy_horizontalScrollProgress ?:
                ((id<HyCyclePageViewScrollProgressProtocol>)self.headerView).hy_horizontalScrollProgress(self, fromIndex, toIndex, progress);
            }
            if ([self.hoverView conformsToProtocol:@protocol(HyCyclePageViewScrollProgressProtocol)] &&
                [self.hoverView respondsToSelector:@selector(hy_horizontalScrollProgress)]) {
                !((id<HyCyclePageViewScrollProgressProtocol>)self.hoverView).hy_horizontalScrollProgress ?:
                ((id<HyCyclePageViewScrollProgressProtocol>)self.hoverView).hy_horizontalScrollProgress(self, fromIndex, toIndex, progress);
            }
        }];
    }
    return _cycleView;
}

- (UIView *)headerContentView {
    if (!_headerContentView){
        _headerContentView = [[UIView alloc] init];
        if (self.configure.hy_headerView) {
            [_headerContentView addSubview:self.configure.hy_headerView];
            self.configure.hy_headerView.tag = Hy_HeaderViewTag;
        }
        if (self.configure.hy_hoverView) {
            [_headerContentView addSubview:self.configure.hy_hoverView];
            self.configure.hy_hoverView.tag = Hy_HoverViewTag;
        }
    }
    return _headerContentView;
}

- (NSMutableDictionary<NSNumber *,UIScrollView *> *)pageScrollViewsDict {
    if (!_pageScrollViewsDict) {
        _pageScrollViewsDict = @{}.mutableCopy;
    }
    return _pageScrollViewsDict;
}

- (NSMutableDictionary<NSNumber *,HyCycleViewProvider<HyCyclePageView *> *> *)viewProviderDict {
    if (!_viewProviderDict) {
        _viewProviderDict = @{}.mutableCopy;
    }
    return _viewProviderDict;
}

- (NSMutableDictionary<NSNumber *,NSArray<UIGestureRecognizer *> *> *)panGesturesDict {
    if (!_panGesturesDict) {
        _panGesturesDict = @{}.mutableCopy;
    }
    return _panGesturesDict;
}

- (HyCyclePageViewConfigure *)configure {
    if (!_configure) {
        _configure = [[HyCyclePageViewConfigure alloc] init];
        _configure.cyclePageView = self;
    }
    return _configure;
}

- (dispatch_semaphore_t)semaphore{
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(1);
    }
    return _semaphore;
}

- (NSInteger)currentIndex {
    return self.cycleView.currentIndex;
}

- (UIView *)headerView {
    return self.configure.hy_headerView;
}

- (UIView *)hoverView {
    return self.configure.hy_hoverView;
}

- (NSArray<UIView *> *)visibleViews {
    NSMutableArray *array = @[].mutableCopy;
    for (NSNumber *index in self.visibleIndexs) {
        [array addObject:self.viewAtIndex(index.integerValue) ?: UIView.new];
    }
    return array.copy;
}

- (NSArray<NSNumber *> *)visibleIndexs {
    return self.cycleView.visibleIndexs;
}

- (NSIndexSet *)didLoadIndexs {
    return self.cycleView.didLoadIndexs;
}

- (void)dealloc {
    [self.observers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[NSNotificationCenter defaultCenter] removeObserver:obj];
    }];
    [self.pageScrollViewsDict.allValues enumerateObjectsUsingBlock:^(UIScrollView *obj,
                                                                     NSUInteger idx,
                                                                     BOOL *stop) {
        [obj removeObserver:self forKeyPath:@"contentOffset"];
    }];
}

@end


@implementation HyCyclePageViewConfigure
- (instancetype)headerRefreshPositon:(HyCyclePageViewHeaderRefreshPosition)position {
    self.hy_headerRefreshPosition = position;
    return self;
}
- (instancetype)headerViewUpAnimation:(HyCyclePageViewHeaderViewUpAnimation)animation {
    self.hy_headerViewUpAnimation = animation;
    return self;
}
- (instancetype)headerViewDownAnimation:(HyCyclePageViewHeaderViewDownAnimation)animation {
    self.hy_headerViewDownAnimation = animation;
    return self;
}
- (instancetype)headerRefreshAtIndex:(void(^)(HyCyclePageView *cyclePageView, UIScrollView *scrollView, id view, NSInteger index))block {
    self.hy_headerRefreshAtIndex = [block copy];
    return self;
}
- (instancetype)footerRefreshAtIndex:(void(^)(HyCyclePageView *cyclePageView, UIScrollView *scrollView,id view, NSInteger index))block {
    self.hy_footerRefreshAtIndex = [block copy];
    return self;
}
- (instancetype)headerView:(UIView *)view {
    UIView *oldView = self.hy_headerView;
    self.hy_headerView = view;
    [self.cyclePageView updateHeaderViewWithNewView:self.hy_headerView oldView:oldView];
    return self;
}
- (instancetype)headerViewHeight:(CGFloat)height {
    self.hy_headerViewHeight = height;
    [self.cyclePageView updateHeaderViewHeight];
    return self;
}
- (instancetype)hoverView:(UIView *)view {
    UIView *oldView = self.hy_hoverView;
    self.hy_hoverView = view;
    [self.cyclePageView updateHeaderViewWithNewView:self.hy_hoverView oldView:oldView];
    return self;
}
- (instancetype)hoverViewHeight:(CGFloat)height {
    self.hy_hoverViewHeight = height;
    [self.cyclePageView updateHoverViewHeight];
   return self;
}
- (instancetype)hoverViewOffset:(CGFloat)offset {
    self.hy_hoverOffset = offset;
    return self;
}
- (instancetype)verticalScrollProgress:(void(^)(HyCyclePageView *cyclePageView, UIView *view, NSInteger index, CGFloat offset))block {
    self.hy_verticalScrollProgress = [block copy];
    return self;
}
@end
