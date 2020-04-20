//
//  NSObject+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  Hy_RespondsToSel(_object, sel) [_object respondsToSelector:sel]

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HyExtension)

- (nullable id)hy_deepCopy;

- (id)hy_performSelector:(SEL)selector
               arguments:(nullable void *)argument, ...;

- (void)hy_performSelector:(SEL)selector
               returnValue:(void *)returnValue
                 arguments:(nullable void *)argument, ...;

- (void)hy_addObserverBlockForKeyPath:(NSString *)keyPath
                                block:(void (^)(id _Nonnull obj, _Nullable id oldValue, _Nullable id newValue))block;
- (void)hy_removeObserverBlocksForKeyPath:(NSString *)keyPath;
- (void)hy_removeObserverBlocks;

- (void)hy_setAssociateRetainValue:(id)value withKey:(void *)key;
- (void)hy_setAssociateCopyValue:(id)value withKey:(void *)key;
- (void)hy_setAssociateAssignValue:(id)value withKey:(void *)key;
- (id)hy_getAssociatedValueForKey:(void *)key;
- (void)hy_removeAssociatedValues;

@end

NS_ASSUME_NONNULL_END
