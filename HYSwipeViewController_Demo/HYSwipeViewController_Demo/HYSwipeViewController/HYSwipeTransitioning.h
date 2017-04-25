//
//  HYSwipeTransitioning.h
//  DriverApp
//
//  Created by huangyi on 17/3/17.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HYSwipeTransitioning : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *gestureRecognizer;
@property (nonatomic, readwrite) UIRectEdge targetEdge;
@end
