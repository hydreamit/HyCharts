//
//  UITableViewHeaderFooterView+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HyTableSeactionViewKinds) {
    HyTableSeactionViewKindsHeader,
    HyTableSeactionViewKindsFooter
};

@interface UITableViewHeaderFooterView (HyExtension)

@property (nonatomic,strong) id hy_sectionData;
@property (nonatomic,assign,readonly) NSInteger hy_section;
@property (nonatomic,weak,readonly) UITableView *hy_tableView;
@property (nonatomic,strong,readonly) id hy_tableViewData;
@property (nonatomic,assign,readonly) HyTableSeactionViewKinds hy_seactionViewKinds;

+ (instancetype)hy_headerFooterViewWithTableView:(UITableView *)tableView
                                         section:(NSInteger)section
                               seactionViewKinds:(HyTableSeactionViewKinds)seactionViewKinds
                                     sectionData:(id)sectionData;

- (void)hy_headerFooterViewLoad;
- (void)hy_reloadHeaderFooterViewData;

@end

NS_ASSUME_NONNULL_END
