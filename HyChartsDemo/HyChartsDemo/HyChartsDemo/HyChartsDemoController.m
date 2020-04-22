//
//  HyChartsDemoController.m
//  DemoCode
//
//  Created by Hy on 2018/4/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyChartsDemoController.h"
#import <HyCategoriess/HyCategories.h>
#import "HyChartsMethods.h"

@implementation HyChartsDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"HyCharts";
    NSArray<NSString *> *titleArray = self.titleArray;
    NSArray<NSString *> *controllerArray = self.controllerArray;
    
    __weak typeof(self) _self = self;
    UITableView *tableView =
    [UITableView hy_tableViewWithFrame:self.view.bounds style:UITableViewStylePlain tableViewData:titleArray cellClasses:@[UITableViewCell.class] headerFooterViewClasses:nil delegateConfigure:^(HyTableViewDelegateConfigure *configure) {
        [[configure configCellWithData:^(UITableViewCell *cell, id cellData, NSIndexPath *indexPath) {
            cell.textLabel.text = (NSString *)cellData;
        }] configDidSelectRowAtIndexPath:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            __strong typeof(_self) self = _self;
            UIViewController *vc = NSClassFromString(controllerArray[indexPath.row]).new;
            vc.hidesBottomBarWhenPushed = YES;
            vc.navigationItem.title = titleArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if (@available(iOS 11.0, *)){
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    [self.view addSubview:tableView];
}

- (NSArray<NSString *> *)titleArray {
    return @[@"柱状图", @"折/曲线图", @"K线图",  @"组合图"];
}

- (NSArray<NSString *> *)controllerArray {
    return @[@"HyChartsBarDemoController",
             @"HyChartsLineDemoController",
             @"HyChartsKlineDemoController",
             @"HyChartsReactChainsDemoController"];
}

@end
