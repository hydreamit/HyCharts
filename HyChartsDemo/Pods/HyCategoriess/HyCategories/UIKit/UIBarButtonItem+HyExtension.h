//
//  UIBarButtonItem+HYCreate.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/5/10.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (HyExtension)

@property (nullable,nonatomic,copy) void (^hy_actionBlock)(UIBarButtonItem *item);

+ (instancetype)hy_itemWithImage:(UIImage *)image
                           style:(UIBarButtonItemStyle)style
                     actionBlock:(void(^_Nullable)(UIBarButtonItem *item))actionBlock;

+ (instancetype)hy_itemWithTitle:(NSString *)title
                           style:(UIBarButtonItemStyle)style
                     actionBlock:(void(^_Nullable)(UIBarButtonItem *item))actionBlock;

+ (instancetype)hy_itemWithSystemItem:(UIBarButtonSystemItem)systemItem
                          actionBlock:(void(^_Nullable)(UIBarButtonItem *item))actionBlock;
@end

NS_ASSUME_NONNULL_END
