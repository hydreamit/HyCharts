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

@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configNumberOfSections)(NSInteger (^)(UITableView *tableView));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configNumberOfRowsInSection)(NSInteger (^)(UITableView *tableView, NSInteger section));
// cell
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configCellForRowAtIndexPath)(UITableViewCell *(^)(UITableView *tableView, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configHeightForRowAtIndexPath)(CGFloat (^)(UITableView *tableView, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configDidSelectRowAtIndexPath)(void (^)(UITableView *tableView, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configDidDeselectRowAtIndexPath)(void (^)(UITableView *tableView, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configWillDisplayCell)(void(^)(UITableView *tableView,UITableViewCell *cell, NSIndexPath * indexPath));
// sectionHeader
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configHeightForHeaderInSection)(CGFloat (^)(UITableView *tableView,NSInteger section));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configViewForHeaderInSection)(UIView *(^)(UITableView *tableView,NSInteger section));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configWillDisplayHeaderView)(void (^)(UITableView *tableView,UIView *view,NSInteger section));
// sectionFooter
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configHeightForFooterInSection)(CGFloat (^)(UITableView *tableView,NSInteger section));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configViewForFooterInSection)(UIView *(^)(UITableView *tableView,NSInteger section));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configWillDisplayFooterView)(void (^)(UITableView *tableView,UIView *view,NSInteger section));
//Edit
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configCanEditRowAtIndexPath)(BOOL (^)(UITableView *tableView, NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configEditingStyleForRowAtIndexPath)(UITableViewCellEditingStyle (^)(UITableView *tableView, NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configCommitEditingStyle)(UITableViewCellEditingStyle (^)(UITableView *tableView,UITableViewCellEditingStyle editingStyle ,NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configEditActionsForRowAtIndexPath)(NSArray<UITableViewRowAction *> * (^)(UITableView *tableView ,NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configCanMoveRowAtIndexPath)(BOOL(^)(UITableView *tableView, NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configShouldIndentWhileEditingRowAtIndexPath)(BOOL(^)(UITableView *tableView, NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configTargetIndexPathForMoveFromRowAtIndexPath)(NSIndexPath *(^)(UITableView *tableView, NSIndexPath *sourceIndexPath , NSIndexPath *toProposedIndexPath));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configMoveRowAtIndexPath)(void(^)(UITableView *tableView, NSIndexPath * sourceIndexPath,  NSIndexPath * destinationIndexPath));


@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configSectionAndCellDataKey)(NSArray<NSString *> *(^)(void));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configCellClassForRow)(Class (^)(id cellData, NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configCellWithData)(void (^)(UITableViewCell *cell, id cellData, NSIndexPath *indexPath));

@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configSectionHeaderFooterViewClassAtSection)(Class (^)(id sectionData,HyTableSeactionViewKinds seactionViewKinds,NSUInteger section));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configSectionHeaderFooterViewWithSectionData)(void (^)(UIView *headerFooterView,id sectionData,HyTableSeactionViewKinds seactionViewKinds,NSUInteger section));
@property (nonatomic,copy,readonly) HyTableViewDelegateConfigure *(^configEmtyView)(void(^)(UITableView *tableView,UIView *emtyContainerView));

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
