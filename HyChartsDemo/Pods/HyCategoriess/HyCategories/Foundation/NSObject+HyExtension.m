//
//  NSObject+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "NSObject+HyExtension.h"
#import "HyRunTimeMethods.h"


#define HY_INIT_INV(_return_) \
NSMethodSignature *signature = [self methodSignatureForSelector:selector]; \
if (!signature) {[self doesNotRecognizeSelector:selector]; return _return_;} \
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature]; \
if (!invocation) { [self doesNotRecognizeSelector:selector]; return _return_; } \
[invocation setTarget:self]; \
[invocation setSelector:selector]; \
if (argument) { \
    va_list valist; \
    va_start(valist, argument); \
    [invocation setArgument:argument atIndex:2]; \
    void *currentArgument; \
    NSInteger index = 3; \
    while ((currentArgument = va_arg(valist, void *))) { \
        [invocation setArgument:currentArgument atIndex:index]; \
        index++; \
    } \
    va_end(valist); \
} \
[invocation invoke];



@interface HyNSObjectKvoBlockTarget : NSObject
@property (nonatomic, copy) void (^block)(__weak id obj, id oldVal, id newVal);
@end

@implementation HyNSObjectKvoBlockTarget

+ (instancetype)blockTargetWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block {
    HyNSObjectKvoBlockTarget *blockTarget = [[self alloc] init];
    blockTarget.block = [block copy];
    return blockTarget;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (!self.block) return;
    
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior) return;
    
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting) return;
    
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldVal == [NSNull null]) oldVal = nil;
    
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    if (newVal == [NSNull null]) newVal = nil;
    
    self.block(object, oldVal, newVal);
}
@end


@implementation NSObject (HyExtension)

- (nullable id)hy_deepCopy {
    
    id obj = nil;
    @try {
        if (@available(iOS 12.0, *)){
            obj =
            [NSKeyedUnarchiver unarchivedObjectOfClass:self.class fromData:[NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:YES error:NULL] error:NULL];
        } else {
            obj = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
        }
    }
    @catch (NSException *exception) {
        
    }
    return obj;
}

- (id)hy_performSelector:(SEL)selector
               arguments:(void *)argument, ... {
    
    HY_INIT_INV(nil);
    const char *typeEncoding = method_getTypeEncoding(class_getInstanceMethod(object_getClass(self), selector));
    if (strncmp(typeEncoding, "@", 1) == 0) {
        __unsafe_unretained id returnValue;
        [invocation getReturnValue:&returnValue];
        return returnValue;
    }
    return nil;
}

- (void)hy_performSelector:(SEL)selector
               returnValue:(void *)returnValue
                 arguments:(void *)argument, ... {
    
    HY_INIT_INV( );
    if (returnValue) {
        [invocation getReturnValue:returnValue];
    }
}

- (void)hy_addObserverBlockForKeyPath:(NSString *)keyPath
                                block:(void (^)(id _Nonnull obj, _Nullable id oldValue, _Nullable id newValue))block {
    
    if (!keyPath || !block) return;
    
    HyNSObjectKvoBlockTarget *target = [HyNSObjectKvoBlockTarget blockTargetWithBlock:block];
    NSMutableDictionary<NSString *, NSMutableArray<HyNSObjectKvoBlockTarget *> *> *dic = [self hy_allNSObjectKvoBlocks];
    NSMutableArray<HyNSObjectKvoBlockTarget *> *arr = dic[keyPath];
    if (!arr) {
        arr = [NSMutableArray new];
        dic[keyPath] = arr;
    }
    [arr addObject:target];
    [self addObserver:target
           forKeyPath:keyPath
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:NULL];
}

- (void)hy_removeObserverBlocksForKeyPath:(NSString *)keyPath {
    
    if (!keyPath) return;
    NSMutableDictionary<NSString *, NSMutableArray<HyNSObjectKvoBlockTarget *> *> *dic = [self hy_allNSObjectKvoBlocks];
    NSMutableArray<HyNSObjectKvoBlockTarget *> *arr = dic[keyPath];
    [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
    [dic removeObjectForKey:keyPath];
}

- (void)hy_removeObserverBlocks {
    
    NSMutableDictionary<NSString *, NSMutableArray<HyNSObjectKvoBlockTarget *> *> *dic = [self hy_allNSObjectKvoBlocks];
    [dic enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    [dic removeAllObjects];
}

- (NSMutableDictionary<NSString *, NSMutableArray<HyNSObjectKvoBlockTarget *> *> *)hy_allNSObjectKvoBlocks {
    NSMutableDictionary<NSString *, NSMutableArray<HyNSObjectKvoBlockTarget *> *> *targets = objc_getAssociatedObject(self, _cmd);
    if (!targets) {
        targets = [NSMutableDictionary new];
        objc_setAssociatedObject(self, _cmd, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

- (void)hy_setAssociateRetainValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)hy_setAssociateCopyValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)hy_setAssociateAssignValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (id)hy_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

- (void)hy_removeAssociatedValues {
    objc_removeAssociatedObjects(self);
}

@end
