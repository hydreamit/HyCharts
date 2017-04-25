//
//  ViewController.m
//  HYSwipeViewController_Demo
//
//  Created by huangyi on 17/4/25.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"

@implementation ViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
}

#pragma mark - Intial Methods
- (void)initConfig {
    self.title = @"HYSwipeViewController";
    self.swipePresentEdge = HYPresentTop | HYPresentLeft | HYPresentBottom | HYPresentRigt;
    self.swipeJumpToVc = [[TestViewController alloc] init];
}

#pragma mark - Event Response
- (void)cancelAction:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)upBtnAction:(id)sender {
    [self presentWithPresentEdge:HYPresentTop];
}

- (IBAction)downBtnAction:(id)sender {
    [self presentWithPresentEdge:HYPresentBottom];
}

- (IBAction)leftBtnAction:(id)sender {
    [self presentWithPresentEdge:HYPresentLeft];
}

- (IBAction)rightBtnAction:(id)sender {
    [self presentWithPresentEdge:HYPresentRigt];
}

- (void)presentWithPresentEdge:(HYPresentEdge)presentEdge {
    [self hy_presentViewController:[[TestViewController alloc] init]
                       presentEdge:presentEdge
                          animated:YES
                        completion:nil];
}
#pragma mark - Setters And Getters


@end
