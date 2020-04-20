//
//  HySegmentView.m
//  HyCycleView
//  https://github.com/hydreamit/HyCycleView
//
//  Created by Hy on 2016/5/22.
//  Copyright © 2016年 Hy. All rights reserved.
//

#import "HySegmentView.h"
#import "UIView+HyFrame.h"

@interface HySegmentViewConfigure ()

@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) UIEdgeInsets hy_inset;
@property (nonatomic,assign) CGFloat hy_itemMargin;
@property (nonatomic,assign) CGFloat hy_insetAndMarginRatio;
@property (nonatomic,assign) BOOL hy_keepingMarginAndInset;
@property (nonatomic,assign) NSInteger hy_items;
@property (nonatomic,assign) NSInteger hy_startIndex;
@property (nonatomic,copy) BOOL(^hy_clickItemAtIndex)(NSInteger, BOOL);
@property (nonatomic,copy) UIView *(^hy_viewForItemAtIndex)(UIView *,
                                                            NSInteger,
                                                            CGFloat,
                                                            HySegmentViewItemPosition,
                                                            NSArray<UIView *> *);
@property (nonatomic,copy) NSArray<UIView *> *(^hy_animationViews)(NSArray<UIView *> *views,
                                                                    UICollectionViewCell *,
                                                                    UICollectionViewCell *,
                                                                    NSInteger,
                                                                    NSInteger,
                                                                    CGFloat);
+ (instancetype)defaultConfigure;
- (void)clearConfigure;
- (void)deallocBlock;
@end


@interface HySegmentView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) HySegmentViewConfigure *configure;
@property (nonatomic,assign) NSInteger currentSelectedIndex;
@property (nonatomic,strong) NSMutableArray<UIView *> *itemViews;
@property (nonatomic,strong) NSMutableArray<UIView *> *animationViews;
@property (nonatomic,strong) dispatch_semaphore_t semaphore;
@property (nonatomic,copy) void(^configureBlock)(HySegmentViewConfigure *configure);
@end


@implementation HySegmentView

+ (instancetype)segmentViewWithFrame:(CGRect)frame
                      configureBlock:(void (^)(HySegmentViewConfigure *configure))configureBlock {
    
    HySegmentView *segmentView = [[self alloc] initWithFrame:frame];
    segmentView.backgroundColor = UIColor.whiteColor;
    segmentView.configureBlock = [configureBlock copy];
    !configureBlock ?: configureBlock(segmentView.configure);
    if (segmentView.configure.hy_startIndex < segmentView.configure.hy_items) {
        segmentView.currentSelectedIndex = segmentView.configure.hy_startIndex;
    }
    [segmentView addSubview:segmentView.collectionView];
    segmentView.collectionView.hidden = YES;
    return segmentView;
}

- (void)clickItemAtIndex:(NSInteger)index {
    
    if (index < self.configure.hy_items && index != self.currentSelectedIndex) {
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        [self handleAnimationViewWithFromIndex:self.currentSelectedIndex
                                       toIndex:index
                                      progress:1];
        dispatch_semaphore_signal(self.semaphore);
    }
}

- (void)clickItemFromIndex:(NSInteger)fromIndex
                   toIndex:(NSInteger)toIndex
                  progress:(CGFloat)progress {
    
    if (fromIndex < self.configure.hy_items && toIndex < self.configure.hy_items) {
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        [self handleAnimationViewWithFromIndex:fromIndex
                                       toIndex:toIndex
                                      progress:progress];
        dispatch_semaphore_signal(self.semaphore);
    }
}

- (void)reloadConfigureBlock {
    
    if (self.configureBlock) {
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        [self.configure clearConfigure];
        self.configureBlock(self.configure);
        [self reloadData];
        dispatch_semaphore_signal(self.semaphore);
    }
}

- (void)reloadConfigureChange {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    [self reloadData];
    dispatch_semaphore_signal(self.semaphore);
}

- (void)reloadData {
    
    [self.itemViews removeAllObjects];
    [self.animationViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.animationViews removeAllObjects];
    if (self.configure.hy_startIndex < self.configure.hy_items) {
        self.currentSelectedIndex = self.configure.hy_startIndex;
    }
    [self handleLayout];
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(.05 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [self handleAnimationViewWithFromIndex:self.currentSelectedIndex
                                                      toIndex:self.currentSelectedIndex
                                                     progress:1];
                   });
}

- (void)handleLayout {
    
    if (self.configure.hy_viewForItemAtIndex &&
        self.configure.hy_items) {
        
        [self.itemViews removeAllObjects];
        
        CGFloat totalWith = 0.0;
        for (NSInteger i = 0; i < self.configure.hy_items; i++) {
            
            CGFloat progress = 0;
            if (self.configure.hy_keepingMarginAndInset) {
                progress = self.currentSelectedIndex == i ? 1 : 0;
            }
            UIView *view = self.configure.hy_viewForItemAtIndex(nil, i, progress, HySegmentViewItemPositionCenter, nil);
            if (i == 0) { view.width += 0.0001; }
            if (view) {
                totalWith += view.width;
                [self.itemViews addObject:view];
            }
        }
        
        if (self.configure.hy_itemMargin == MAXFLOAT) {
            
            if (UIEdgeInsetsEqualToEdgeInsets(self.configure.hy_inset, UIEdgeInsetsZero)) {
                
                CGFloat overWith = self.width - totalWith;
                if (overWith >= 0) {
                    self.configure.hy_itemMargin = overWith / (self.configure.hy_items - 1 + self.configure.hy_insetAndMarginRatio * 2);
                } else {
                    self.configure.hy_itemMargin = 30;
                }
                
                self.configure.hy_inset = UIEdgeInsetsMake(0, self.configure.hy_itemMargin * self.configure.hy_insetAndMarginRatio, 0, self.configure.hy_itemMargin * self.configure.hy_insetAndMarginRatio);
                
            } else {
                
                CGFloat insetLR = self.configure.hy_inset.left + self.configure.hy_inset.right;
                CGFloat overWith = self.width - totalWith - insetLR;
                if (overWith >= 0) {
                    self.configure.hy_itemMargin = overWith / (self.configure.hy_items - 1);
                } else {
                    self.configure.hy_itemMargin = 30;
                }
            }
            
        } else  {
            
            if (UIEdgeInsetsEqualToEdgeInsets(self.configure.hy_inset, UIEdgeInsetsZero)) {
                self.configure.hy_inset = UIEdgeInsetsMake(0, self.configure.hy_itemMargin * self.configure.hy_insetAndMarginRatio, 0, self.configure.hy_itemMargin * self.configure.hy_insetAndMarginRatio);
            }
        }
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.superview) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(.05 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [self handleAnimationViewWithFromIndex:self.currentSelectedIndex
                                                          toIndex:self.currentSelectedIndex
                                                         progress:1];
                           self.collectionView.hidden = NO;
                       });
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.containTo(self);
    [self handleLayout];
}

- (void)handleAnimationViewWithFromIndex:(NSInteger)fromIndex
                                 toIndex:(NSInteger)toIndex
                                progress:(CGFloat)progress {
    
    if (!self.configure.hy_items) {return;}
    
    if (progress == 1) {
        self.currentSelectedIndex = toIndex;
    }
    
    if (self.configure.hy_animationViews) {
        
        NSArray<UIView *> *animationViews =
        self.configure.hy_animationViews(self.animationViews,
                                         [self getCellWithIndex:fromIndex],
                                         [self getCellWithIndex:toIndex],
                                         fromIndex,
                                         toIndex,
                                         progress);
        
        if (![self checkAnimationViews:animationViews]) {
            
            [self.collectionView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![obj isKindOfClass:UICollectionViewCell.class]) {
                    [obj removeFromSuperview];
                }
            }];
            
            for (UIView *view in animationViews) {
                [self.collectionView insertSubview:view atIndex:0];
            }
            self.animationViews = animationViews.mutableCopy;
        }
    }
    
    NSTimeInterval delayTime = self.configure.hy_keepingMarginAndInset ? 0.05 : 0.0;
    
    if (self.configure.hy_viewForItemAtIndex && toIndex != fromIndex) {
        
        HySegmentViewItemPosition position = HySegmentViewItemPositionCenter;
        if (progress != 0 && progress != 1 && fromIndex != toIndex) {
            if (fromIndex == self.currentSelectedIndex) {
                if (fromIndex < toIndex) {
                    position = HySegmentViewItemPositionRight;
                } else {
                    position = HySegmentViewItemPositionLeft;
                }
            } else {
                if (fromIndex < toIndex) {
                    position = HySegmentViewItemPositionLeft;
                } else {
                    position = HySegmentViewItemPositionRight;
                }
            }
        }

        UIView *fromItemView =
        self.configure.hy_viewForItemAtIndex([self getItemViewWithIndex:fromIndex],
                                             fromIndex,
                                             1 - progress,
                                             position,
                                             self.animationViews);
        
        UIView *toItemView =
        self.configure.hy_viewForItemAtIndex([self getItemViewWithIndex:toIndex],
                                             toIndex,
                                             progress,
                                             position,
                                             self.animationViews);
        
        if (self.configure.hy_keepingMarginAndInset) {
            [self.layout invalidateLayout];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(delayTime * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           
                           [self handleItemViewWithCell:nil
                                                  index:fromIndex
                                               itemView:fromItemView];
                           
                           [self handleItemViewWithCell:nil
                                                  index:toIndex
                                               itemView:toItemView];
                       });
       
    }
    
    if (progress == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(delayTime * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [self scrollToCenterWithIndex:toIndex];
                       });
    }
}

- (void)handleItemViewWithCell:(UICollectionViewCell *)cell
                         index:(NSInteger)index
                      itemView:(UIView *)itemView {
    
    UIView *currentItemView = itemView;
    UIView *lastItemView = [self getItemViewWithIndex:index];
    UICollectionViewCell *currentCell = cell;
    if (!currentCell) {
        currentCell = [self getCellWithIndex:index];
    }
    
    if (currentItemView) {
        if (lastItemView != currentItemView) {
            if (index < self.itemViews.count) {
                [self.itemViews replaceObjectAtIndex:index withObject:currentItemView];
            }
            [currentCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [currentCell.contentView addSubview:currentItemView];
        } else {
            if (currentCell.contentView.subviews.firstObject != currentItemView) {
                [currentCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [currentCell.contentView addSubview:currentItemView];
            }
        }
        currentCell.contentView.frame = currentCell.bounds;
        currentItemView.centerYValue(currentCell.contentView.height / 2);
        currentItemView.centerXValue(currentCell.contentView.width / 2);
    } else {
        [currentCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

- (void)scrollToCenterWithIndex:(NSInteger)index {
    
    if (self.collectionView.contentSize.width <= self.collectionView.width ||
        !self.configure.hy_items ||
        self.collectionView.isDragging) {
        return;
    }
    
    UICollectionViewLayoutAttributes *layoutAttr =
    [self.layout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    CGFloat centerX = layoutAttr.frame.origin.x + layoutAttr.frame.size.width / 2;
    CGFloat offsetX = centerX - self.collectionView.width / 2;
    if (offsetX < 0) { offsetX = 0;}
    
    if (offsetX > self.collectionView.contentSize.width - self.collectionView.width) {
        offsetX = self.collectionView.contentSize.width - self.collectionView.width;
    }
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (UIView *)getItemViewWithIndex:(NSInteger)index {
    
    if (index < self.itemViews.count) {
        return self.itemViews[index];
    }
    return nil;
}

- (UICollectionViewCell *)getCellWithIndex:(NSInteger)index {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (!cell) {
        CGRect rect = [self.layout layoutAttributesForItemAtIndexPath:indexPath].frame;
        if (CGRectEqualToRect(rect, CGRectZero) && index < self.itemViews.count) {
            CGFloat totalWith = 0.0;
            for (NSInteger i = 0; i < index; i++) {
                totalWith += self.itemViews[i].width + self.configure.hy_itemMargin;
            }
            rect = CGRectMake(self.configure.hy_inset.left + totalWith, self.configure.hy_inset.top, self.itemViews[index].width, self.height - self.configure.hy_inset.top - self.configure.hy_inset.bottom);
        }
        cell = [[UICollectionViewCell alloc] initWithFrame:rect];
    }
    return cell;
}

- (BOOL)checkAnimationViews:(NSArray<UIView *> *)animationViews {
    
    if (animationViews.count != self.animationViews.count) {
        return NO;
    }
    
    __block BOOL isSame = YES;
    [self.animationViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if (animationViews[idx] != obj) {
            isSame = NO;
            *stop = YES;
        }
    }];
    return isSame;
}

#pragma mark — UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.configure.hy_items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return
    [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)
                                              forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor = UIColor.clearColor;
    if (self.configure.hy_viewForItemAtIndex) {
        UIView *itemView =
        self.configure.hy_viewForItemAtIndex([self getItemViewWithIndex:indexPath.row],
                                             indexPath.row,
                                             self.currentSelectedIndex == indexPath.row,
                                             HySegmentViewItemPositionCenter,
                                             self.animationViews);
        [self handleItemViewWithCell:cell
                               index:indexPath.row
                            itemView:itemView];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger fromIndex = self.currentSelectedIndex;
    
    BOOL needHandle =
    !self.configure.hy_clickItemAtIndex ? YES :
    self.configure.hy_clickItemAtIndex(indexPath.row, indexPath.row == self.currentSelectedIndex);
    
    if (needHandle) {
        [self handleAnimationViewWithFromIndex:fromIndex
                                       toIndex:indexPath.row
                                      progress:1];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.itemViews[indexPath.row].width, collectionView.height - self.configure.hy_inset.top - self.configure.hy_inset.bottom);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return self.configure.hy_itemMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    return self.configure.hy_inset;
}

#pragma mark — getters and setters
- (HySegmentViewConfigure *)configure {
    if (!_configure){
        _configure = [HySegmentViewConfigure defaultConfigure];
    }
    return _configure;
}

- (UICollectionView *)collectionView {
    if (!_collectionView){
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                             collectionViewLayout:self.layout];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
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
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (NSMutableArray<UIView *> *)itemViews {
    if (!_itemViews){
        _itemViews = @[].mutableCopy;
    }
    return _itemViews;
}

- (NSMutableArray<UIView *> *)animationViews {
    if (!_animationViews){
        _animationViews = @[].mutableCopy;
    }
    return _animationViews;
}

- (dispatch_semaphore_t)semaphore{
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(1);
    }
    return _semaphore;
}

- (void)setCurrentSelectedIndex:(NSInteger)currentSelectedIndex {
    _currentSelectedIndex = currentSelectedIndex;
    self.configure.hy_startIndex = currentSelectedIndex;
}

- (void)dealloc {
    [self.configure deallocBlock];
}

@end

@implementation HySegmentViewConfigure

+ (instancetype)defaultConfigure {
    HySegmentViewConfigure *configure = [[self alloc] init];
    configure.insetAndMarginRatio(1.0).itemMargin(MAXFLOAT);
    return configure;
}

- (void)clearConfigure {
    
    [self
     .insetAndMarginRatio(1.0)
     .itemMargin(0)
     .numberOfItems(0)
     .inset(UIEdgeInsetsZero)
     .keepingMarginAndInset(NO)
     deallocBlock];
}

- (HySegmentViewConfigure *(^)(UIEdgeInsets))inset {
    return ^(UIEdgeInsets value){
        self.hy_inset = value;
        return self;
    };
}

- (HySegmentViewConfigure *(^)(CGFloat))insetAndMarginRatio {
    return ^(CGFloat value){
        self.hy_insetAndMarginRatio = value;
        return self;
    };
}

- (HySegmentViewConfigure *(^)(NSInteger))startIndex {
    return ^(NSInteger index){
        self.hy_startIndex = index;
        return self;
    };
}

- (HySegmentViewConfigure *(^)(BOOL))keepingMarginAndInset {
    return ^(BOOL value){
        self.hy_keepingMarginAndInset = value;
        return self;
    };
}

- (HySegmentViewConfigure *(^)(NSInteger))numberOfItems {
    return ^(NSInteger items){
        self.hy_items = items;
        return self;
    };
}

- (HySegmentViewConfigure *(^)(CGFloat))itemMargin {
    return ^(CGFloat margin){
        self.hy_itemMargin = margin;
        return self;
    };
}

- (HySegmentViewConfigure *(^)(BOOL (^)(NSInteger,
                                        BOOL)))clickItemAtIndex {
    
    return ^(BOOL (^block)(NSInteger,
                           BOOL)){
        self.hy_clickItemAtIndex = [block copy];
        return self;
    };
}

- (HySegmentViewConfigure *(^)(UIView *(^)(UIView *,
                                           NSInteger,
                                           CGFloat,
                                           HySegmentViewItemPosition,
                                           NSArray<UIView *> *)))viewForItemAtIndex {
    
    return ^(UIView *(^block)(UIView *,
                              NSInteger,
                              CGFloat,
                              HySegmentViewItemPosition,
                              NSArray<UIView *> *)){
        self.hy_viewForItemAtIndex = [block copy];
        return self;
    };
}

- (HySegmentViewConfigure *(^)(NSArray<UIView *> *(^)(NSArray<UIView *> *,
                                                      UICollectionViewCell *,
                                                      UICollectionViewCell *,
                                                      NSInteger,
                                                      NSInteger,
                                                      CGFloat)))animationViews {
    
    return ^(NSArray<UIView *> *(^block)(NSArray<UIView *> *,
                                         UICollectionViewCell *,
                                         UICollectionViewCell *,
                                         NSInteger,
                                         NSInteger,
                                         CGFloat)){
        self.hy_animationViews = [block copy];
        return self;
    };
}

- (NSInteger)getCurrentIndex {
    return self.hy_startIndex;
}

- (UIEdgeInsets)getInset {
    return self.hy_inset;
}

- (CGFloat)getItemMargin {
    return self.hy_itemMargin;
}

- (void)deallocBlock {
    self.hy_animationViews = nil;
    self.hy_clickItemAtIndex = nil;
    self.hy_viewForItemAtIndex = nil;
}

@end
