//
//   UICollectionView+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 17/6/9.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+HyExtension.h"
#import "UICollectionViewCell+HyExtension.h"
#import "UICollectionReusableView+HyExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyCollectionViewDelegateConfigure : HyScrollViewDelegateConfigure
- (instancetype)configNumberOfSections:(NSInteger (^_Nullable)(UICollectionView *collectionView))block;
- (instancetype)configNumberOfItemsInSection:(NSInteger (^_Nullable)(UICollectionView *collectionView, NSInteger section))block;
// cell
- (instancetype)configCellForItemAtIndexPath:(UICollectionViewCell *(^_Nullable)(UICollectionView *collectionView, NSIndexPath *indexPath))block;
- (instancetype)configHeightForRowAtIndexPath:(CGFloat (^_Nullable)(UICollectionView *collectionView, NSIndexPath *indexPath))block;
- (instancetype)configDidSelectItemAtIndexPath:(void (^_Nullable)(UITableView *tableView, NSIndexPath *indexPath))block;
- (instancetype)configWillDisplayCell:(void(^_Nullable)(UICollectionView *collectionView,UICollectionViewCell *cell, NSIndexPath * indexPath))block;
// header footer
- (instancetype)configSeactionHeaderFooterViewAtIndexPath:(UICollectionReusableView *(^_Nullable)(UICollectionView *collectionView,NSString *kind, NSIndexPath * indexPath))block;
- (instancetype)configWillDisPlayHeaderFooterViewAtIndexPath:(void (^_Nullable)(UICollectionView *collectionView,UICollectionReusableView *view,NSString *kind, NSIndexPath * indexPath))block;

// layout
- (instancetype)configLayoutSize:(CGSize (^_Nullable)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSIndexPath *indexPath))block;
- (instancetype)configLayoutInsets:(UIEdgeInsets (^_Nullable)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section))block;
- (instancetype)configLayoutMinimumLineSpacing:(CGFloat (^_Nullable)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section))block;
- (instancetype)configLayoutMinimumInteritemSpacing:(CGFloat (^_Nullable)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section))block;
- (instancetype)configLayoutReferenceSizeForHeader:(CGSize (^_Nullable)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section))block;
- (instancetype)configLayoutReferenceSizeForFooter:(CGSize (^_Nullable)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section))block;

// 
- (instancetype)configSectionAndCellDataKey:(NSArray<NSString *> *(^_Nullable)(void))block;
- (instancetype)configCellClassForRow:(Class (^_Nullable)(id cellData, NSIndexPath * indexPath))block;
- (instancetype)configCellWithData:(void (^_Nullable)(UICollectionViewCell *cell, id cellData, NSIndexPath *indexPath))block;
- (instancetype)configSectionHeaderFooterViewClassAtSection:(Class (^_Nullable)(id sectionData,
                                                                       HyCollectionSeactionViewKinds seactionViewKinds,
                                                                       NSUInteger section))block;
- (instancetype)configSectionHeaderFooterViewWithSectionData:(void (^_Nullable)(UIView *headerFooterView,
                                                                       id sectionData,
                                                                       HyCollectionSeactionViewKinds seactionViewKinds,
                                                                       NSUInteger section))block;

- (instancetype)configEmtyView:(void(^)(UICollectionView *tableView, UIView *emtyContainerView))block;

@end



@interface UICollectionView (HyExtension)

@property (nonatomic,strong,nullable) id hy_collectionViewData;
@property (nonatomic,strong,readonly) HyCollectionViewDelegateConfigure *hy_delegateConfigure;

@property (nonatomic,copy,nullable) void (^hy_willReloadDataAsynHandler)(UICollectionView *collectionView);
@property (nonatomic,copy,nullable) void (^hy_willReloadDataHandler)(UICollectionView *collectionView);
@property (nonatomic,copy,nullable) void (^hy_didReloadDataHandler)(UICollectionView *collectionView);

+ (instancetype)hy_collectionViewWithFrame:(CGRect)frame
                                    layout:(UICollectionViewLayout *)layout
                               cellClasses:(NSArray<Class> * _Nullable)cellClasses
                         headerViewClasses:(NSArray<Class> * _Nullable)headerViewClasses
                         footerViewClasses:(NSArray<Class> * _Nullable)footerViewClasses
                                dataSource:(id<UICollectionViewDataSource> _Nullable)dataSource
                                  delegate:(id<UICollectionViewDelegate> _Nullable)delegate;

+ (instancetype)hy_collectionViewWithFrame:(CGRect)frame
                                    layout:(UICollectionViewLayout *)layout
                        collectionViewData:(id _Nullable)collectionViewData
                               cellClasses:(NSArray<Class> *_Nullable)cellClasses
                         headerViewClasses:(NSArray<Class> *_Nullable)headerViewClasses
                         footerViewClasses:(NSArray<Class> *_Nullable)footerViewClasses
                        delegateConfigure:(void (^_Nullable)(HyCollectionViewDelegateConfigure *configure))delegateConfigure;

- (void)hy_colletionViewLoad;
- (id)hy_sectionDataAtSection:(NSInteger)section;
- (id)hy_cellDataAtIndexPath:(NSIndexPath *)indexPath;
- (void)hy_reloadDataWithSectionDataKey:(NSString *_Nullable)sectionDataKey
                            cellDataKey:(NSString *_Nullable)cellDataKey;

- (void)hy_registerCellWithCellClass:(Class)cellClass;
- (void)hy_registerCellWithCellClasses:(NSArray<Class> *)cellClasses;

- (void)hy_registerHeaderWithViewClass:(Class)viewClass;
- (void)hy_registerHeaderWithViewClasses:(NSArray<Class> *)viewClasses;

- (void)hy_registerFooterWithViewClass:(Class)viewClass;
- (void)hy_registerFooterWithViewClasses:(NSArray<Class> *)viewClasses;

- (void)hy_clearSelectedItemsAnimated:(BOOL)animated;
- (BOOL)hy_cellIsVisibleAtIndexPath:(NSIndexPath *)indexPath;

@end


NS_ASSUME_NONNULL_END
