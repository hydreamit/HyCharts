//
//  UITableViewCell+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (HyExtension)

@property (nonatomic,strong) id hy_cellData;
@property (nonatomic,strong,readonly) id hy_sectionData;
@property (nonatomic,strong,readonly) id hy_tableViewData;
@property (nonatomic,weak,readonly) UITableView *hy_tableView;
@property (nonatomic,strong,readonly) NSIndexPath *hy_indexPath;


+ (instancetype)hy_cellWithTableView:(UITableView *)tableview
                           indexPath:(NSIndexPath *)indexPath
                            cellData:(id)cellData;

- (void)hy_cellLoad;
- (void)hy_reloadCellData;

@end

NS_ASSUME_NONNULL_END
