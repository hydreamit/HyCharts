//
//  UIGestureRecognizer+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UIGestureRecognizer+HyExtension.h"
#import "HyRunTimeMethods.h"


@interface HyGestureRecognizerBlockTarget : NSObject
@property (nonatomic, copy) void (^block)(UIGestureRecognizer *);
@end
@implementation HyGestureRecognizerBlockTarget
+ (instancetype)blockTargetWithBlock:(void (^)(UIGestureRecognizer *))block {
    HyGestureRecognizerBlockTarget *blockTarget = [[self alloc] init];
    blockTarget.block = [block copy];
    return blockTarget;
}
- (void)action:(UIGestureRecognizer *)sender {
    !self.block ?: self.block(sender);
}
@end


@implementation UIGestureRecognizer (HyExtension)

- (UIView *)hy_targetView {
    CGPoint location = [self locationInView:self.view];
    UIView *targetView = [self.view hitTest:location withEvent:nil];
    return targetView;
}

+ (instancetype)hy_gestureRecognizerWithActionBlock:(void (^)(UIGestureRecognizer *gesture))block {
    UIGestureRecognizer *gesture = [[UIGestureRecognizer alloc] init];
    [gesture hy_addActionBlock:block];
    return gesture;
}

- (void)hy_addActionBlock:(void(^)(UIGestureRecognizer *gesture))block {
    HyGestureRecognizerBlockTarget *target = [HyGestureRecognizerBlockTarget blockTargetWithBlock:block];
    [self addTarget:target action:@selector(action:)];
    [[self hy_allGestureRecognizerBlockTargets] addObject:target];
}

- (void)hy_removeAllActionBlocks {
    NSMutableArray<HyGestureRecognizerBlockTarget *> *targets = [self hy_allGestureRecognizerBlockTargets];
    [targets enumerateObjectsUsingBlock:^(id target, NSUInteger idx, BOOL *stop) {
        [self removeTarget:target action:@selector(action:)];
    }];
    [targets removeAllObjects];
}

- (NSMutableArray<HyGestureRecognizerBlockTarget *> *)hy_allGestureRecognizerBlockTargets {
    NSMutableArray<HyGestureRecognizerBlockTarget *> *targets = objc_getAssociatedObject(self, _cmd);
    if (!targets) {
        targets = @[].mutableCopy;
        objc_setAssociatedObject(self, _cmd, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
