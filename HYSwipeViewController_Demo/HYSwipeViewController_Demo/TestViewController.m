//
//  TestViewController.m
//  HYSwipeViewController_Demo
//
//  Created by huangyi on 17/4/25.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()
@end

@implementation TestViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TestViewController";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                        action:@selector(leftItemAction)];
}

#pragma mark - Event Response
- (IBAction)nextPageBtnAction:(id)sender {
    [self hy_presentViewController:[[TestViewController alloc] init]
                       presentEdge:HYPresentRigt
                          animated:YES
                        completion:nil];
}

- (void)leftItemAction {
    [self hy_dismissViewControllerAnimated:YES
                                completion:nil];
}

@end
