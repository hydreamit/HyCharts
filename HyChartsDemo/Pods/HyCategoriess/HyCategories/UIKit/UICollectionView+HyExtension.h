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

@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configNumberOfSections)(NSInteger (^)(UICollectionView *collectionView));
@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configNumberOfItemsInSection)(NSInteger (^)(UICollectionView *collectionView, NSInteger section));
// cell
@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configCellForItemAtIndexPath)(UICollectionViewCell *(^)(UICollectionView *collectionView, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configHeightForRowAtIndexPath)(CGFloat (^)(UICollectionView *collectionView, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configDidSelectItemAtIndexPath)(void (^)(UITableView *tableView, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configWillDisplayCell)(void(^)(UICollectionView *collectionView,UICollectionViewCell *cell, NSIndexPath * indexPath));
// header footer
@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configSeactionHeaderFooterViewAtIndexPath)(UICollectionReusableView *(^)(UICollectionView *collectionView,NSString *kind, NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configWillDisPlayHeaderFooterViewAtIndexPath)(void (^)(UICollectionView *collectionView,UICollectionReusableView *view,NSString *kind, NSIndexPath * indexPath));
// layout

@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configLayoutSize)(CGSize (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configLayoutInsets)(UIEdgeInsets (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section));
@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configLayoutMinimumLineSpacing)(CGFloat (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section));
@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configLayoutMinimumInteritemSpacing)(CGFloat (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section));
@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configLayoutReferenceSizeForHeader)(CGSize (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section));
@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configLayoutReferenceSizeForFooter)(CGSize (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section));

@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configSectionAndCellDataKey)(NSArray<NSString *> *(^)(void));
@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configCellClassForRow)(Class (^)(id cellData, NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configCellWithData)(void (^)(UICollectionViewCell *cell, id cellData, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configSectionHeaderFooterViewClassAtSection)(Class (^)(id sectionData,HyCollectionSeactionViewKinds seactionViewKinds,NSUInteger section));
@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configSectionHeaderFooterViewWithSectionData)(void (^)(UIView *headerFooterView,id sectionData,HyCollectionSeactionViewKinds seactionViewKinds,NSUInteger section));
@property (nonatomic,copy,readonly) HyCollectionViewDelegateConfigure *(^configEmtyView)(void(^)(UICollectionView *tableView, UIView *emtyContainerView));
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
