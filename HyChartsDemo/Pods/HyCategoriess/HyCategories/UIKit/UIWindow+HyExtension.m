//
//  UIWindow+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/20.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UIWindow+HyExtension.h"

@implementation UIWindow (HyExtension)

+ (UIWindow *)hy_keyWindow {
    return  UIApplication.sharedApplication.keyWindow;
}

@end
