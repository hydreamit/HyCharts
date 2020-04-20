//
//  NSMethodSignature+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "NSMethodSignature+HyExtension.h"
#import "HyRunTimeMethods.h"

@implementation NSMethodSignature (HyExtension)

/*
 - (IMP)methodForSelector:(SEL)aSelector;
 + (IMP)instanceMethodForSelector:(SEL)aSelector;
 */
- (NSString *)hy_typeString {
    
    SEL selector = sel_registerName("_typeString");
    IMP imp = [self methodForSelector:selector];
    if (imp != NULL) {
       return HyValueImpFuctoin(imp, NSString *, self, selector);
    }
    return nil;
}

- (const char *)hy_typeEncoding {
    return self.hy_typeString.UTF8String;
}

+ (instancetype)hy_classMethodSignatureWithClass:(Class)cls selector:(SEL)sel {
    
    if (!cls || !sel) {
        return nil;
    }
    Class metacls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    return [metacls instanceMethodSignatureForSelector:sel];
}

+ (instancetype)hy_instanceMethodSignatureWithClass:(Class)cls selector:(SEL)sel {
    
    if (!cls || !sel) {
        return nil;
    }
    Class class = objc_getClass(NSStringFromClass(cls).UTF8String);
    return [class instanceMethodSignatureForSelector:sel];
}

@end
