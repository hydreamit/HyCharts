//
//  UIControl+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UIControl+HyExtension.h"
#import "HyRunTimeMethods.h"


@interface HyControlBlockTarget : NSObject
@property (nonatomic, copy) void (^block)(UIControl *);
@property (nonatomic, assign) UIControlEvents events;
@end
@implementation HyControlBlockTarget
+ (instancetype)blockTargetWithBlock:(void (^)(UIControl *))block
                              events:(UIControlEvents)events {
    HyControlBlockTarget *blockTarget = [[self alloc] init];
    blockTarget.block = [block copy];
    blockTarget.events = events;
    return blockTarget;
}
- (void)action:(UIControl *)control {
    !self.block ?: self.block(control);
}
@end


@implementation UIControl (HyExtension)

- (void)hy_addBlockForControlEvents:(UIControlEvents)controlEvents
                              block:(void (^)(id sender))block {
    
    if (!controlEvents) return;
    HyControlBlockTarget *target = [HyControlBlockTarget blockTargetWithBlock:block events:controlEvents];
    [self addTarget:target action:@selector(action:) forControlEvents:controlEvents];
    [[self hy_allControlBlockTargets] addObject:target];
}

- (void)hy_resetBlockForControlEvents:(UIControlEvents)controlEvents
                                block:(void (^)(id sender))block {
    [self hy_removeAllBlocksForControlEvents:controlEvents];
    [self hy_addBlockForControlEvents:controlEvents block:block];
}

- (void)hy_removeAllBlocksForControlEvents:(UIControlEvents)controlEvents {
    
    if (!controlEvents) return;
    
    NSMutableArray<HyControlBlockTarget *> *targets = [self hy_allControlBlockTargets];
    NSMutableArray<HyControlBlockTarget *> *removes = [NSMutableArray array];
    for (HyControlBlockTarget *target in targets) {
        if (target.events & controlEvents) {
            UIControlEvents newEvent = target.events & (~controlEvents);
            if (newEvent) {
                [self removeTarget:target action:@selector(action:) forControlEvents:target.events];
                target.events = newEvent;
                [self addTarget:target action:@selector(action:) forControlEvents:target.events];
            } else {
                [self removeTarget:target action:@selector(action:) forControlEvents:target.events];
                [removes addObject:target];
            }
        }
    }
    [targets removeObjectsInArray:removes];
}

- (void)hy_removeAllTargets {
    [[self allTargets] enumerateObjectsUsingBlock: ^(id object, BOOL *stop) {
        [self removeTarget:object action:NULL forControlEvents:UIControlEventAllEvents];
    }];
    [[self hy_allControlBlockTargets] removeAllObjects];
}

- (void)hy_resetTarget:(id)target
                action:(SEL)action
      forControlEvents:(UIControlEvents)controlEvents {
    
    if (!target || !action || !controlEvents) return;
    NSSet *targets = [self allTargets];
    for (id currentTarget in targets) {
        NSArray *actions = [self actionsForTarget:currentTarget forControlEvent:controlEvents];
        for (NSString *currentAction in actions) {
            [self removeTarget:currentTarget action:NSSelectorFromString(currentAction)
              forControlEvents:controlEvents];
        }
    }
    [self addTarget:target action:action forControlEvents:controlEvents];
}

- (NSMutableArray<HyControlBlockTarget *> *)hy_allControlBlockTargets {
    NSMutableArray<HyControlBlockTarget *> *targets = objc_getAssociatedObject(self, _cmd);
    if (!targets) {
        targets = @[].mutableCopy;
        objc_setAssociatedObject(self, _cmd, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}


@end
