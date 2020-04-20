//
//  UIScreen+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UIScreen+HyExtension.h"

@implementation UIScreen (HyExtension)

+ (CGFloat)hy_screenScale {
    
    static CGFloat screenScale = 0.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([NSThread isMainThread]) {
            screenScale = [[UIScreen mainScreen] scale];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                screenScale = [[UIScreen mainScreen] scale];
            });
        }
    });
    return screenScale;
}

- (CGRect)hy_currentBounds {
    return [self hy_boundsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (CGRect)hy_boundsForOrientation:(UIInterfaceOrientation)orientation {
    
    CGRect bounds = [self bounds];
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        CGFloat buffer = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = buffer;
    }
    return bounds;
}

@end
