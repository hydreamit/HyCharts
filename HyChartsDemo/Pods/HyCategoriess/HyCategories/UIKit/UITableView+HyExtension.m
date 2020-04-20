//
//  UITableView+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 17/6/9.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import "UITableView+HyExtension.h"
#import "HyRunTimeMethods.h"

@interface HyTableViewDelegateConfigure () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,copy) NSInteger(^numberOfSections)(UITableView *tableView);
@property (nonatomic,copy) NSInteger(^numberOfRowsInSection)(UITableView *tableView, NSInteger section);
// cell
@property (nonatomic,copy) UITableViewCell *(^cellForRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) CGFloat (^heightForRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^didSelectRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^didDeselectRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^willDisplayCell)(UITableView *tableView,UITableViewCell *cell, NSIndexPath * indexPath);
// sectionHeader
@property (nonatomic,copy) CGFloat (^heightForHeaderInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) UIView *(^viewForHeaderInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) void (^willDisplayHeaderView)(UITableView *tableView,UIView *view,NSInteger section);
// sectionFooter
@property (nonatomic,copy) CGFloat (^heightForFooterInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) UIView *(^viewForFooterInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) void (^willDisplayFooterView)(UITableView *tableView,UIView *view,NSInteger section);
//Edit
@property (nonatomic,copy) BOOL (^canEditRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) UITableViewCellEditingStyle
(^editingStyleForRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^commitEditingStyle)
(UITableView *tableView,UITableViewCellEditingStyle editingStyle ,NSIndexPath * indexPath);
@property (nonatomic,copy) NSArray<UITableViewRowAction *> *
(^editActionsForRowAtIndexPath)(UITableView *tableView ,NSIndexPath * indexPath);
@property (nonatomic,copy) BOOL (^canMoveRowAtIndexPath)(UITableView *tableView ,NSIndexPath * indexPath);
@property (nonatomic,copy) BOOL (^shouldIndentWhileEditingRowAtIndexPath)(UITableView *tableView ,NSIndexPath * indexPath);
@property (nonatomic,copy) NSIndexPath *(^targetIndexPathForMoveFromRowAtIndexPath)(UITableView *tableView, NSIndexPath *sourceIndexPath , NSIndexPath *toProposedIndexPath);
@property (nonatomic,copy) void (^moveRowAtIndexPath)(UITableView *tableView, NSIndexPath * sourceIndexPath,  NSIndexPath * destinationIndexPath);
@property (nonatomic,copy) NSArray<NSString *> *(^sectionAndCellDataKey)(void);
@property (nonatomic,copy) Class(^cellClassForRow)(id cellData, NSIndexPath * indexPath);
@property (nonatomic,copy) void(^cellWithData)(UITableViewCell *cell, id cellData, NSIndexPath *indexPath);
@property (nonatomic,copy) Class(^sectionHeaderFooterViewClassAtSection)(id sectionData,
                                                                  HyTableSeactionViewKinds seactionViewKinds,
                                                                  NSUInteger section);
@property (nonatomic,copy) void(^sectionHeaderFooterViewWithSectionData)(UIView *headerFooterView,
                                                                        id sectionData,
                                                                        HyTableSeactionViewKinds seactionViewKinds,
                                                                        NSUInteger section);
@property (nonatomic,copy) void(^emtyViewBlock)(UITableView *,UIView *);
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,copy) NSString *cellDataKey;
@property (nonatomic,copy) NSString *sectionDataKey;
@property (nonatomic,strong) NSArray<Class> *cellClasses;
@property (nonatomic,strong) NSArray<Class> *headerFooterViewClasses;
@end
@implementation HyTableViewDelegateConfigure
- (instancetype)configNumberOfSections:(NSInteger (^)(UITableView *tableView))block {
    self.numberOfSections = [block copy];
    return self;
}
- (instancetype)configNumberOfRowsInSection:(NSInteger (^)(UITableView *tableView, NSInteger section))block {
    self.numberOfRowsInSection = [block copy];
    return self;
}
- (instancetype)configCellForRowAtIndexPath:(UITableViewCell *(^)(UITableView *tableView, NSIndexPath *indexPath))block {
    self.cellForRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configHeightForRowAtIndexPath:(CGFloat (^)(UITableView *tableView, NSIndexPath *indexPath))block {
    self.heightForRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configDidSelectRowAtIndexPath:(void (^)(UITableView *tableView, NSIndexPath *indexPath))block {
    self.didSelectRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configDidDeselectRowAtIndexPath:(void (^)(UITableView *tableView, NSIndexPath *indexPath))block {
    self.didDeselectRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configWillDisplayCell:(void (^)(UITableView *tableView,UITableViewCell *cell, NSIndexPath * indexPath))block {
    self.willDisplayCell = [block copy];
    return self;
}
- (instancetype)configHeightForHeaderInSection:(CGFloat (^)(UITableView *tableView,NSInteger section))block {
    self.heightForHeaderInSection = [block copy];
    return self;
}
- (instancetype)configViewForHeaderInSection:(UIView *(^)(UITableView *tableView,NSInteger section))block {
    self.viewForHeaderInSection = [block copy];
    return self;
}
- (instancetype)configWillDisplayHeaderView:(void (^)(UITableView *tableView,UIView *view,NSInteger section))block {
    self.willDisplayHeaderView = [block copy];
    return self;
}
- (instancetype)configHeightForFooterInSection:(CGFloat (^)(UITableView *tableView,NSInteger section))block {
    self.heightForFooterInSection = [block copy];
    return self;
}
- (instancetype)configViewForFooterInSection:(UIView *(^)(UITableView *tableView,NSInteger section))block {
    self.viewForFooterInSection = [block copy];
    return self;
}
- (instancetype)configWillDisplayFooterView:(void (^)(UITableView *tableView,UIView *view,NSInteger section))block {
    self.willDisplayFooterView = [block copy];
    return self;
}
- (instancetype)configCanEditRowAtIndexPath:(BOOL (^)(UITableView *tableView, NSIndexPath * indexPath))block {
    self.canEditRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configEditingStyleForRowAtIndexPath:(UITableViewCellEditingStyle (^)(UITableView *tableView, NSIndexPath * indexPath))block {
    self.editingStyleForRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configCommitEditingStyle:(UITableViewCellEditingStyle (^)(UITableView *tableView,UITableViewCellEditingStyle editingStyle ,NSIndexPath * indexPath))block {
    self.commitEditingStyle = [block copy];
    return self;
}
- (instancetype)configEditActionsForRowAtIndexPath:(NSArray<UITableViewRowAction *> * (^)(UITableView *tableView ,NSIndexPath * indexPath))block {
    self.editActionsForRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configCanMoveRowAtIndexPath:(BOOL(^)(UITableView *tableView, NSIndexPath * indexPath))block {
    self.canMoveRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configShouldIndentWhileEditingRowAtIndexPath:(BOOL(^)(UITableView *tableView, NSIndexPath * indexPath))block {
    self.shouldIndentWhileEditingRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configTargetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *(^)(UITableView *tableView, NSIndexPath *sourceIndexPath , NSIndexPath *toProposedIndexPath))block {
    self.targetIndexPathForMoveFromRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configMoveRowAtIndexPath:(void(^)(UITableView *tableView, NSIndexPath * sourceIndexPath,  NSIndexPath * destinationIndexPath))block {
    self.moveRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configSectionAndCellDataKey:(NSArray<NSString *> *(^)(void))block {
    self.sectionAndCellDataKey = [block copy];
    return self;
}
- (instancetype)configCellClassForRow:(Class (^)(id cellData, NSIndexPath * indexPath))block {
    self.cellClassForRow = [block copy];
    return self;
}
- (instancetype)configCellWithData:(void (^)(UITableViewCell *cell, id cellData, NSIndexPath *indexPath))block {
    self.cellWithData = [block copy];
    return self;
}
- (instancetype)configSectionHeaderFooterViewClassAtSection:(Class (^)(id sectionData,
                                                                       HyTableSeactionViewKinds seactionViewKinds,
                                                                       NSUInteger section))block {
    self.sectionHeaderFooterViewClassAtSection = [block copy];
    return self;
}
- (instancetype)configSectionHeaderFooterViewWithSectionData:(void (^)(UIView *headerFooterView,
                                                                       id sectionData,
                                                                       HyTableSeactionViewKinds seactionViewKinds,
                                                                       NSUInteger section))block {
    self.sectionHeaderFooterViewWithSectionData = [block copy];
    return self;
}

- (instancetype)configEmtyView:(void(^)(UITableView *tableView, UIView *emtyContainerView))block {
    self.emtyViewBlock = [block copy];
    return self;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return
    self.numberOfSections ?
    self.numberOfSections(tableView) : [self getSectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return
    self.numberOfRowsInSection ?
    self.numberOfRowsInSection(tableView, section) : [self getCellCountInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cellForRowAtIndexPath) {
        return self.cellForRowAtIndexPath(tableView, indexPath);
    } else {
        
        Class cellClass;
        id cellData = [self getCellDataAtIndexPath:indexPath];
        if (self.cellClassForRow) {
            cellClass = self.cellClassForRow(cellData ,indexPath);
        } else {
            NSArray *array = self.cellClasses;
            if (array.count == 1) {
                cellClass = array.firstObject;
            };
        }
        return
        cellClass ? [cellClass hy_cellWithTableView:tableView
                                          indexPath:indexPath
                                           cellData:cellData] : nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
 
    self.willDisplayCell ?
    self.willDisplayCell(tableView, cell, indexPath) : nil;

    self.cellWithData ?
    self.cellWithData(cell, [self getCellDataAtIndexPath:indexPath], indexPath) : nil;
    
    [cell hy_reloadCellData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.viewForHeaderInSection) {
        return self.viewForHeaderInSection(tableView, section);
    } else {
        id headerClass;
        id sectionData = [self getSectionDtaAtSection:section];
        if (self.sectionHeaderFooterViewClassAtSection) {
            headerClass = self.sectionHeaderFooterViewClassAtSection(sectionData,0, section);;
        } else {
            NSArray *array = self.headerFooterViewClasses;
            if (array.count == 1) {
                headerClass = array.firstObject;
            };
        }
        
        if (class_isMetaClass(object_getClass(headerClass))) {
            return
            [headerClass hy_headerFooterViewWithTableView:tableView
                                                  section:section
                                        seactionViewKinds:HyTableSeactionViewKindsHeader
                                              sectionData:sectionData];
            
        } else if ([headerClass isKindOfClass:UIView.class]) {
            return headerClass;
        } return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (self.viewForFooterInSection) {
        return self.viewForFooterInSection(tableView, section);
    } else {
        id footerClass;
        id sectionData = [self getSectionDtaAtSection:section];
        if (self.sectionHeaderFooterViewClassAtSection) {
            footerClass = self.sectionHeaderFooterViewClassAtSection(sectionData,0, section);;
        } else {
            NSArray *array = self.headerFooterViewClasses;
            if (array.count == 1) {
                footerClass = array.firstObject;
            };
        }
        
        if (class_isMetaClass(object_getClass(footerClass))) {
            return
            [footerClass hy_headerFooterViewWithTableView:tableView
                                                  section:section
                                        seactionViewKinds:HyTableSeactionViewKindsFooter
                                              sectionData:sectionData];
            
        } else if ([footerClass isKindOfClass:UIView.class]) {
            return footerClass;
        } return nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view
       forSection:(NSInteger)section {
    
    self.willDisplayHeaderView ?
    self.willDisplayHeaderView(tableView, view,section) : nil;
    
    self.sectionHeaderFooterViewWithSectionData ?
    self.sectionHeaderFooterViewWithSectionData(view,
                                                [self getSectionDtaAtSection:section],
                                                HyTableSeactionViewKindsHeader,
                                                section) : nil;
    if ([view isKindOfClass:UITableViewHeaderFooterView.class]) {
        [((UITableViewHeaderFooterView *)view) hy_reloadHeaderFooterViewData];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view
       forSection:(NSInteger)section {
    
    self.willDisplayFooterView ?
    self.willDisplayFooterView(tableView, view, section) : nil;
    
    self.sectionHeaderFooterViewWithSectionData ?
    self.sectionHeaderFooterViewWithSectionData(view,
                                                [self getSectionDtaAtSection:section],
                                                HyTableSeactionViewKindsFooter,
                                                section) : nil;
    if ([view isKindOfClass:UITableViewHeaderFooterView.class]) {
        [((UITableViewHeaderFooterView *)view) hy_reloadHeaderFooterViewData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.heightForRowAtIndexPath ?
    self.heightForRowAtIndexPath(tableView, indexPath) : tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return
    self.heightForHeaderInSection ?
    self.heightForHeaderInSection(tableView, section) : (tableView.sectionHeaderHeight > 0 ? tableView.sectionHeaderHeight : CGFLOAT_MIN);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return
    self.heightForFooterInSection ?
    self.heightForFooterInSection(tableView, section) : (tableView.sectionFooterHeight > 0 ? tableView.sectionFooterHeight : CGFLOAT_MIN);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.didSelectRowAtIndexPath ?
    self.didSelectRowAtIndexPath(tableView, indexPath) : nil;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.didDeselectRowAtIndexPath ?
    self.didDeselectRowAtIndexPath(tableView, indexPath) : nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.canEditRowAtIndexPath ?
    self.canEditRowAtIndexPath(tableView, indexPath) : NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.editingStyleForRowAtIndexPath ?
    self.editingStyleForRowAtIndexPath(tableView, indexPath) : 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath{
    self.commitEditingStyle ?
    self.commitEditingStyle(tableView, editingStyle, indexPath) : 0;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView
                  editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.editActionsForRowAtIndexPath ?
    self.editActionsForRowAtIndexPath(tableView, indexPath) : 0;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.canMoveRowAtIndexPath ?
    self.canMoveRowAtIndexPath(tableView, indexPath) : NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.shouldIndentWhileEditingRowAtIndexPath ?
    self.shouldIndentWhileEditingRowAtIndexPath(tableView, indexPath) : YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    return
    self.targetIndexPathForMoveFromRowAtIndexPath ?
    self.targetIndexPathForMoveFromRowAtIndexPath
    (tableView, sourceIndexPath, proposedDestinationIndexPath) : proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    !self.moveRowAtIndexPath ?:
    self.moveRowAtIndexPath(tableView, sourceIndexPath, destinationIndexPath);
}

- (NSInteger)getSectionCount {
    
    id sectionData = [self getSectionData];
    if ([self isArrayWithData:sectionData]) {
        return ((NSArray *)sectionData).count;
    }
    
    if ([self isArrayWithData:self.hy_tableViewData] &&
        ![self getSectionKey].length && [self getCellKey].length) {
        return ((NSArray *)self.hy_tableViewData).count;
    }
    
    return self.hy_tableViewData ? 1 : 0;
}

- (NSInteger)getCellCountInSection:(NSInteger)section {
    
    id cellData = [self getCellKeyDataWithSection:section];
    if ([self isArrayWithData:cellData]) {
        return ((NSArray *)cellData).count;
    }
    
    if ([self isArrayWithData:self.hy_tableViewData] &&
        ![self getSectionKey].length && ![self getCellKey].length) {
        return ((NSArray *)self.hy_tableViewData).count;
    }
    
    return self.hy_tableViewData ? 1 : 0;
}

- (id)getCellDataAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!indexPath) { return nil;}
    
    id cellData = [self getCellKeyDataWithSection:indexPath.section];
    if ([self isArrayWithData:cellData]) {
        if (((NSArray *)cellData).count > indexPath.row) {
            return ((NSArray *)cellData)[indexPath.row];
        }
    }
    
    if ([self isArrayWithData:self.hy_tableViewData] &&
        ![self getSectionKey].length && ![self getCellKey].length) {
        if (((NSArray *)self.hy_tableViewData).count > indexPath.row) {
            return ((NSArray *)self.hy_tableViewData)[indexPath.row];
        }
    }
    
    return self.hy_tableViewData;
}

- (id)getSectionDtaAtSection:(NSInteger)section {
    
    id sectionData = [self getSectionData];
    if ([self isArrayWithData:sectionData]) {
        if (((NSArray *)sectionData).count > section) {
            return ((NSArray *)sectionData)[section];
        }
    }
    
    if ([self isArrayWithData:self.hy_tableViewData] &&
        ![self getSectionKey].length && [self getCellKey].length) {
        if (((NSArray *)self.hy_tableViewData).count > section) {
            return ((NSArray *)self.hy_tableViewData)[section];
        }
    }
    
    return self.hy_tableViewData;
}

- (id)getSectionData {
    
    NSString *sectionKey = [self getSectionKey];
    if (sectionKey.length && sectionKey.length) {
        NSArray *keys = [sectionKey componentsSeparatedByString:@"."];
        id data = self.hy_tableViewData;
        for (NSString *key in keys) {
            if ([self isObjectWithData:data]) {
                data = [data valueForKeyPath:key];
            }
        }
        return data;
    }
    return nil;
}

- (id)getCellKeyDataWithSection:(NSInteger)section {
    
    NSString *cellKey = [self getCellKey];
    if (self.hy_tableViewData && cellKey.length) {
        
        id sectionData = [self getSectionData] ?: self.hy_tableViewData;
        id cellData = sectionData;
        if ([self isArrayWithData:sectionData]) {
            if (section < ((NSArray *)sectionData).count) {
                cellData = ((NSArray *)sectionData)[section];
            } else {
                return @[].mutableCopy;
            }
        }
        
        if ([self isObjectWithData:cellData]) {
            
            NSArray *keys = [cellKey componentsSeparatedByString:@"."];
            if (keys.count) {
                id data = cellData;
                for (NSString *key in keys) {
                    if (key.length && [self isObjectWithData:data]) {
                        data = [data valueForKeyPath:key];
                    }
                }
                return data;
            } else {
                return cellData;
            }
        }
    }
    return nil;
}

- (NSString *)getSectionKey {
    if (self.sectionAndCellDataKey) {
        return self.sectionAndCellDataKey().firstObject;
    }
    return self.sectionDataKey;
}

- (NSString *)getCellKey {
    if (self.sectionAndCellDataKey) {
        return self.sectionAndCellDataKey().lastObject;
    }
    return self.cellDataKey;
}

- (BOOL)isArrayWithData:(id)data {
    if ([data isKindOfClass:NSArray.class] ||
        [data isKindOfClass:NSMutableArray.class]) {
        return YES;
    }
    return NO;
}

- (BOOL)isObjectWithData:(id)data {
    if (!data) { return NO;}
    
    return ![self isArrayWithData:data];
}

- (id)hy_tableViewData {
    return self.tableView.hy_tableViewData;
}
@end


@interface UITableView ()
@property (nonatomic,strong) HyTableViewDelegateConfigure *hy_delegateConfigure;
@end
@implementation UITableView (HyExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hy_swizzleInstanceMethods([self class],@[@"reloadData"]);
    });
}

+ (instancetype)hy_tableViewWithFrame:(CGRect)frame
                                style:(UITableViewStyle)style
                          cellClasses:(NSArray<Class> *)cellClasses
              headerFooterViewClasses:(NSArray<Class> *)headerFooterViewClasses
                           dataSource:(id<UITableViewDataSource>)dataSource
                             delegate:(id<UITableViewDelegate>)delegate {
    
    UITableView *tableView = [[self alloc] initWithFrame:frame style:style];
    if (@available(iOS 11.0, *)){
        tableView.estimatedRowHeight = CGFLOAT_MIN;
        tableView.estimatedSectionHeaderHeight = CGFLOAT_MIN;
        tableView.estimatedSectionFooterHeight = CGFLOAT_MIN;
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [tableView hy_registerCellWithCellClasses:cellClasses];
    [tableView hy_registerHeaderFooterWithViewClasses:headerFooterViewClasses];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    tableView.dataSource = dataSource;
    tableView.delegate = delegate;
    [tableView hy_tableViewLoad];
    return tableView;
}

+ (instancetype)hy_tableViewWithFrame:(CGRect)frame
                                style:(UITableViewStyle)style
                        tableViewData:(id)tableViewData
                          cellClasses:(NSArray<Class> *)cellClasses
              headerFooterViewClasses:(NSArray<Class> *)headerFooterViewClasses
                    delegateConfigure:(void (^)(HyTableViewDelegateConfigure *configure))delegateConfigure {
    
    UITableView *tableView = [[self alloc] initWithFrame:frame style:style];
    if (@available(iOS 11.0, *)){
        tableView.estimatedRowHeight = CGFLOAT_MIN;
        tableView.estimatedSectionHeaderHeight = CGFLOAT_MIN;
        tableView.estimatedSectionFooterHeight = CGFLOAT_MIN;
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    tableView.hy_tableViewData = tableViewData;
    [tableView hy_registerCellWithCellClasses:cellClasses];
    [tableView hy_registerHeaderFooterWithViewClasses:headerFooterViewClasses];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    tableView.hy_delegateConfigure = [[HyTableViewDelegateConfigure alloc] init];
    !delegateConfigure ?: delegateConfigure(tableView.hy_delegateConfigure);
    tableView.hy_delegateConfigure.tableView = tableView;
    tableView.hy_delegateConfigure.cellClasses = cellClasses;
    tableView.hy_delegateConfigure.headerFooterViewClasses = headerFooterViewClasses;
    tableView.dataSource = tableView.hy_delegateConfigure;
    tableView.delegate = tableView.hy_delegateConfigure;
    [tableView hy_tableViewLoad];
    return tableView;
}

- (void)hy_tableViewLoad {};
- (void)hy_reloadDataWithSectionDataKey:(NSString *)sectionDataKey
                            cellDataKey:(NSString *)cellDataKey {
    
    self.hy_delegateConfigure.sectionDataKey = sectionDataKey;
    self.hy_delegateConfigure.cellDataKey = cellDataKey;
    [self reloadData];
}

- (id)hy_sectionDataAtSection:(NSInteger)section {
    if (self.hy_delegateConfigure) {
        [self.hy_delegateConfigure getSectionDtaAtSection:section];
    }
    return nil;
}

- (id)hy_cellDataAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hy_delegateConfigure) {
        [self.hy_delegateConfigure getCellDataAtIndexPath:indexPath];
    }
    return nil;
}

- (BOOL)hy_cellIsVisibleAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<NSIndexPath *> *visibleCellIndexPaths = self.indexPathsForVisibleRows;
    for (NSIndexPath *visibleIndexPath in visibleCellIndexPaths) {
        if ([indexPath isEqual:visibleIndexPath]) {
            return YES;
        }
    }
    return NO;
}

- (void)hy_insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    if (section > self.numberOfSections - 1) {
        return;
    }
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self insertSections:sections withRowAnimation:animation];
}

- (void)hy_deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    if (section > self.numberOfSections - 1) {
        return;
    }
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self deleteSections:sections withRowAnimation:animation];
}

- (void)hy_reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    if (section > self.numberOfSections - 1) {
        return;
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    [self reloadSections:indexSet withRowAnimation:animation];
}

- (void)hy_clearSelectedRowsAnimated:(BOOL)animated {
    NSArray *indexs = [self indexPathsForSelectedRows];
    [indexs enumerateObjectsUsingBlock:^(NSIndexPath* path, NSUInteger idx, BOOL *stop) {
        [self deselectRowAtIndexPath:path animated:animated];
    }];
}

- (void)hy_reloadData {
    
    if (self.hy_willReloadDataAsynHandler) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.hy_willReloadDataAsynHandler(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hy_handleReloadData];
            });
        });
    } else {
        [self hy_handleReloadData];
    }
}

- (void)hy_handleReloadData {
    !self.hy_willReloadDataHandler ?: self.hy_willReloadDataHandler(self);
    [self hy_reloadData];
    
    if (self.hy_delegateConfigure.emtyViewBlock) {
           
           NSInteger sectionCount =
           self.hy_delegateConfigure.numberOfSections ?
           self.hy_delegateConfigure.numberOfSections(self) :
           [self.hy_delegateConfigure getSectionCount];
           
           if (sectionCount <= 1) {
               
               NSInteger cellCount =
               self.hy_delegateConfigure.numberOfRowsInSection ?
               self.hy_delegateConfigure.numberOfRowsInSection(self, 0) :
               [self.hy_delegateConfigure getCellCountInSection:0];
               
               if (cellCount == 0) {
                   self.hy_emtyContainerView.hidden = NO;
                   [self.hy_emtyContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                   self.hy_delegateConfigure.emtyViewBlock(self,self.hy_emtyContainerView);
               } else {
                   self.hy_emtyContainerView.hidden = YES;
               }
           } else {
               self.hy_emtyContainerView.hidden = YES;
           }
       }
    
    !self.hy_didReloadDataHandler ?: self.hy_didReloadDataHandler(self);
}

- (void)hy_registerCellWithCellClasses:(NSArray<Class> *)cellClasses {
    
    if (!cellClasses.count) { return; }
    [cellClasses enumerateObjectsUsingBlock:^(Class obj,
                                              NSUInteger idx,
                                              BOOL *stop) {
        [self hy_registerCellWithCellClass:obj];
    }];
}

- (void)hy_registerCellWithCellClass:(Class)cellClass {
    
    if (!cellClass) { return; }
    
    NSString *cellClassString = NSStringFromClass(cellClass);
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:cellClassString ofType:@"nib"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:nibPath]) {
        [self registerNib:[UINib nibWithNibName:cellClassString
                                         bundle:nil] forCellReuseIdentifier:cellClassString];
    } else {
        [self registerClass:cellClass forCellReuseIdentifier:cellClassString];
    }
}

- (void)hy_registerHeaderFooterWithViewClasses:(NSArray<Class> *)viewClasses {
    
    if (!viewClasses.count) { return; }
    [viewClasses enumerateObjectsUsingBlock:^(Class obj,
                                              NSUInteger idx,
                                              BOOL *stop) {
        [self hy_registerHeaderFooterWithViewClass:obj];
    }];
}

- (void)hy_registerHeaderFooterWithViewClass:(Class)viewClass {
    
    if (!viewClass) { return; }
    
    NSString *viewClassString = NSStringFromClass(viewClass);
    NSString *nibPath =  [[NSBundle mainBundle] pathForResource:viewClassString ofType:@"nib"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:nibPath]) {
        [self registerNib:[UINib nibWithNibName:viewClassString
                                         bundle:nil] forHeaderFooterViewReuseIdentifier:viewClassString];
    }else{
        [self registerClass:viewClass forHeaderFooterViewReuseIdentifier:viewClassString];
    }
}

- (void)setHy_delegateConfigure:(HyTableViewDelegateConfigure *)hy_delegateConfigure {
    objc_setAssociatedObject(self,
                             @selector(hy_delegateConfigure),
                             hy_delegateConfigure,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HyTableViewDelegateConfigure *)hy_delegateConfigure {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHy_tableViewData:(id)hy_tableViewData {
    objc_setAssociatedObject(self,
                             @selector(hy_tableViewData),
                             hy_tableViewData,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)hy_tableViewData {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHy_willReloadDataAsynHandler:(void (^)(UITableView *tableView))hy_willReloadDataAsynHandler {
    objc_setAssociatedObject(self,
                             @selector(hy_willReloadDataAsynHandler),
                             hy_willReloadDataAsynHandler,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITableView *tableView))hy_willReloadDataAsynHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHy_willReloadDataHandler:(void (^)(UITableView *tableView))hy_willReloadDataHandler {
    objc_setAssociatedObject(self,
                             @selector(hy_willReloadDataHandler),
                             hy_willReloadDataHandler,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITableView *tableView))hy_willReloadDataHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHy_didReloadDataHandler:(void (^)(UITableView *tableView))hy_didReloadDataHandler {
    objc_setAssociatedObject(self,
                             @selector(hy_didReloadDataHandler),
                             hy_didReloadDataHandler,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITableView *tableView))hy_didReloadDataHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIView *)hy_emtyContainerView {
    
    UIView *emtyView = objc_getAssociatedObject(self, _cmd);
    if (!emtyView) {
        emtyView = UIView.new;
        emtyView.backgroundColor = self.backgroundColor;
        emtyView.frame = CGRectMake(self.contentInset.left, self.contentInset.top, self.bounds.size.width - self.contentInset.left - self.contentInset.right, self.bounds.size.height - self.contentInset.top - self.contentInset.bottom - self.adjustedContentInset.top - self.adjustedContentInset.bottom);
        emtyView.hidden = YES;
        [self addSubview:emtyView];
        [self bringSubviewToFront:emtyView];
        objc_setAssociatedObject(self, _cmd, emtyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return emtyView;
}

@end
