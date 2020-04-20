//
//  UITableView+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 17/6/9.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+HyExtension.h"
#import "UITableViewCell+HyExtension.h"
#import "UITableViewHeaderFooterView+HyExtension.h"


@interface HyTableViewDelegateConfigure : HyScrollViewDelegateConfigure
- (instancetype)configNumberOfSections:(NSInteger (^)(UITableView *tableView))block;
- (instancetype)configNumberOfRowsInSection:(NSInteger (^)(UITableView *tableView, NSInteger section))block;
// cell
- (instancetype)configCellForRowAtIndexPath:(UITableViewCell *(^)(UITableView *tableView, NSIndexPath *indexPath))block;
- (instancetype)configHeightForRowAtIndexPath:(CGFloat (^)(UITableView *tableView, NSIndexPath *indexPath))block;
- (instancetype)configDidSelectRowAtIndexPath:(void (^)(UITableView *tableView, NSIndexPath *indexPath))block;
- (instancetype)configDidDeselectRowAtIndexPath:(void (^)(UITableView *tableView, NSIndexPath *indexPath))block;
- (instancetype)configWillDisplayCell:(void(^)(UITableView *tableView,UITableViewCell *cell, NSIndexPath * indexPath))block;
// sectionHeader
- (instancetype)configHeightForHeaderInSection:(CGFloat (^)(UITableView *tableView,NSInteger section))block;
- (instancetype)configViewForHeaderInSection:(UIView *(^)(UITableView *tableView,NSInteger section))block;
- (instancetype)configWillDisplayHeaderView:(void (^)(UITableView *tableView,UIView *view,NSInteger section))block;
// sectionFooter
- (instancetype)configHeightForFooterInSection:(CGFloat (^)(UITableView *tableView,NSInteger section))block;
- (instancetype)configViewForFooterInSection:(UIView *(^)(UITableView *tableView,NSInteger section))block;
- (instancetype)configWillDisplayFooterView:(void (^)(UITableView *tableView,UIView *view,NSInteger section))block;
//Edit
- (instancetype)configCanEditRowAtIndexPath:(BOOL (^)(UITableView *tableView, NSIndexPath * indexPath))block;
- (instancetype)configEditingStyleForRowAtIndexPath:(UITableViewCellEditingStyle (^)(UITableView *tableView, NSIndexPath * indexPath))block;
- (instancetype)configCommitEditingStyle:(UITableViewCellEditingStyle (^)(UITableView *tableView,UITableViewCellEditingStyle editingStyle ,NSIndexPath * indexPath))block;
- (instancetype)configEditActionsForRowAtIndexPath:(NSArray<UITableViewRowAction *> * (^)(UITableView *tableView ,NSIndexPath * indexPath))block;
- (instancetype)configCanMoveRowAtIndexPath:(BOOL(^)(UITableView *tableView, NSIndexPath * indexPath))block;
- (instancetype)configShouldIndentWhileEditingRowAtIndexPath:(BOOL(^)(UITableView *tableView, NSIndexPath * indexPath))block;
- (instancetype)configTargetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *(^)(UITableView *tableView, NSIndexPath *sourceIndexPath , NSIndexPath *toProposedIndexPath))block;
- (instancetype)configMoveRowAtIndexPath:(void(^)(UITableView *tableView, NSIndexPath * sourceIndexPath,  NSIndexPath * destinationIndexPath))block;


- (instancetype)configSectionAndCellDataKey:(NSArray<NSString *> *(^)(void))block;
- (instancetype)configCellClassForRow:(Class (^)(id cellData, NSIndexPath * indexPath))block;
- (instancetype)configCellWithData:(void (^)(UITableViewCell *cell, id cellData, NSIndexPath *indexPath))block;

- (instancetype)configSectionHeaderFooterViewClassAtSection:(Class (^)(id sectionData,
                                                                       HyTableSeactionViewKinds seactionViewKinds,
                                                                       NSUInteger section))block;
- (instancetype)configSectionHeaderFooterViewWithSectionData:(void (^)(UIView *headerFooterView,
                                                                       id sectionData,
                                                                       HyTableSeactionViewKinds seactionViewKinds,
                                                                       NSUInteger section))block;

- (instancetype)configEmtyView:(void(^)(UITableView *tableView,UIView *emtyContainerView))block;

@end


@interface UITableView (HyExtension)

@property (nonatomic,strong) id hy_tableViewData;
@property (nonatomic,strong,readonly) HyTableViewDelegateConfigure *hy_delegateConfigure;

@property (nonatomic,copy) void (^hy_willReloadDataAsynHandler)(UITableView *tableView);
@property (nonatomic,copy) void (^hy_willReloadDataHandler)(UITableView *tableView);
@property (nonatomic,copy) void (^hy_didReloadDataHandler)(UITableView *tableView);


+ (instancetype)hy_tableViewWithFrame:(CGRect)frame
                                style:(UITableViewStyle)style
                          cellClasses:(NSArray<Class> *)cellClasses
              headerFooterViewClasses:(NSArray<Class> *)headerFooterViewClasses
                           dataSource:(id<UITableViewDataSource>)dataSource
                             delegate:(id<UITableViewDelegate>)delegate;


+ (instancetype)hy_tableViewWithFrame:(CGRect)frame
                                style:(UITableViewStyle)style
                        tableViewData:(id)tableViewData
                          cellClasses:(NSArray<Class> *)cellClasses
              headerFooterViewClasses:(NSArray<Class> *)headerFooterViewClasses
                    delegateConfigure:(void (^)(HyTableViewDelegateConfigure *configure))delegateConfigure;

- (void)hy_tableViewLoad;
- (id)hy_sectionDataAtSection:(NSInteger)section;
- (id)hy_cellDataAtIndexPath:(NSIndexPath *)indexPath;
- (void)hy_reloadDataWithSectionDataKey:(NSString *)sectionDataKey
                            cellDataKey:(NSString *)cellDataKey;

- (void)hy_registerCellWithCellClass:(Class)cellClass;
- (void)hy_registerCellWithCellClasses:(NSArray<Class> *)cellClasses;

- (void)hy_registerHeaderFooterWithViewClass:(Class)viewClass;
- (void)hy_registerHeaderFooterWithViewClasses:(NSArray<Class> *)viewClasses;

- (void)hy_clearSelectedRowsAnimated:(BOOL)animated;
- (BOOL)hy_cellIsVisibleAtIndexPath:(NSIndexPath *)indexPath;
- (void)hy_insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)hy_deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)hy_reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

@end
