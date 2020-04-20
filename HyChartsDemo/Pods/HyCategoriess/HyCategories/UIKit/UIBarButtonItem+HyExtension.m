//
//  UIBarButtonItem+HYCreate.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/5/10.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import "UIBarButtonItem+HyExtension.h"
#import "HyRunTimeMethods.h"

@interface HyBarButtonItemBlockTarget : NSObject
@property (nonatomic, copy) void (^block)(UIBarButtonItem *);
@end
@implementation HyBarButtonItemBlockTarget
+ (instancetype)blockTargetWithBlock:(void (^)(UIBarButtonItem *))block {
    HyBarButtonItemBlockTarget *blockTarget = [[self alloc] init];
    blockTarget.block = [block copy];
    return blockTarget;
}
- (void)action:(UIBarButtonItem *)item {
    !self.block ?: self.block(item);
}
@end


@implementation UIBarButtonItem (HyExtension)

+ (instancetype)hy_itemWithImage:(UIImage *)image
                           style:(UIBarButtonItemStyle)style
                     actionBlock:(void(^)(UIBarButtonItem *item))actionBlock {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image
                                                             style:style
                                                            target:nil
                                                            action:nil];
    item.hy_actionBlock = [actionBlock copy];
    return item;
}

+ (instancetype)hy_itemWithTitle:(NSString *)title
                           style:(UIBarButtonItemStyle)style
                     actionBlock:(void(^)(UIBarButtonItem *item))actionBlock {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title
                                                             style:style
                                                            target:nil
                                                            action:nil];
    item.hy_actionBlock = [actionBlock copy];
    return item;
}

+ (instancetype)hy_itemWithSystemItem:(UIBarButtonSystemItem)systemItem
                          actionBlock:(void(^_Nullable)(UIBarButtonItem *item))actionBlock {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem
                                                                          target:nil
                                                                          action:nil];
    item.hy_actionBlock = [actionBlock copy];
    return item;
}

- (void)setHy_actionBlock:(void (^)(UIBarButtonItem * _Nonnull))hy_actionBlock {
    HyBarButtonItemBlockTarget *target = [HyBarButtonItemBlockTarget blockTargetWithBlock:hy_actionBlock];
    objc_setAssociatedObject(self, @selector(hy_actionBlock), target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTarget:target];
    [self setAction:@selector(action:)];
}

- (void (^)(UIBarButtonItem * _Nonnull))hy_actionBlock {
    return ((HyBarButtonItemBlockTarget *)objc_getAssociatedObject(self, _cmd)).block;
}

@end
