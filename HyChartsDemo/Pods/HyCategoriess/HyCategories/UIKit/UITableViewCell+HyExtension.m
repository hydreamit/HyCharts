//
//  UITableViewCell+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UITableViewCell+HyExtension.h"
#import "UITableView+HyExtension.h"
#import "HyRunTimeMethods.h"

@interface UITableViewCell ()
@property (nonatomic,strong) NSIndexPath *hy_indexPath;
@end


@implementation UITableViewCell (HyExtension)

+ (instancetype)hy_cellWithTableView:(UITableView *)tableview
                           indexPath:(NSIndexPath *)indexPath
                            cellData:(id)cellData {
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass(self)
                                                            forIndexPath:indexPath];
    cell.hy_cellData = cellData;
    cell.hy_indexPath = indexPath;
    [cell hy_cellLoad];
    return cell;
}

- (void)hy_cellLoad {}
- (void)hy_reloadCellData {}

- (id)hy_sectionData {
    if (self.hy_tableView) {
        return [self.hy_tableView hy_sectionDataAtSection:self.hy_indexPath.section];
    }
    return nil;
}

- (id)hy_tableViewData {
    if (self.hy_tableView) {
       return self.hy_tableView.hy_tableViewData;
    }
    return nil;
}

- (UITableView *)hy_tableView {
    
    if (!self.superview) {
        return nil;
    }
    UITableView *tableView =
    (UITableView *)([NSStringFromClass(self.superview.class) isEqualToString:@"UITableViewWrapperView"] ?
    self.superview.superview :
    self.superview);
    
    if ([tableView isKindOfClass:UITableView.class]) {
        return tableView;
    }
    
    return nil;
}

- (void)setHy_cellData:(id)hy_cellData {
    objc_setAssociatedObject(self,
                             @selector(hy_cellData),
                             hy_cellData,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)hy_cellData {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHy_indexPath:(NSIndexPath *)hy_indexPath {
    objc_setAssociatedObject(self,
                             @selector(hy_indexPath),
                             hy_indexPath,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)hy_indexPath {
    NSIndexPath *indexPath = objc_getAssociatedObject(self, _cmd);
    if (!indexPath) {
        indexPath = [self.hy_tableView indexPathForCell:self];
    }
    return indexPath;
}

@end
