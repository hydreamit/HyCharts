//
//  HyRunTimeMethods.c
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/5/10.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyRunTimeMethods.h"


void hy_swizzleTwoClassMethods(Class fromCls, SEL fromSel, Class toCls, SEL toSel) {
    
    if (!fromCls || !toCls || !fromSel || !toSel) { return;}
    
    Method fromMethod = class_getClassMethod(fromCls, fromSel);
    Method toMethod = class_getClassMethod(toCls, toSel);
    
    if (!toMethod) {return;}
    
    Class fromMetacls = objc_getMetaClass(NSStringFromClass(fromCls).UTF8String);
    Class toMetacls = objc_getMetaClass(NSStringFromClass(toCls).UTF8String);
    
    if (class_addMethod(fromMetacls,
                        fromSel,
                        method_getImplementation(toMethod),
                        method_getTypeEncoding(toMethod))) {
        
        class_replaceMethod(toMetacls,
                            toSel,
                            method_getImplementation(fromMethod),
                            method_getTypeEncoding(fromMethod));
        
    } else {
        
        class_replaceMethod(toMetacls,
                            toSel,
                            class_replaceMethod(fromMetacls,
                                                fromSel,
                                                method_getImplementation(toMethod),
                                                method_getTypeEncoding(toMethod)),
                            method_getTypeEncoding(fromMethod));
        
//        method_exchangeImplementations(fromMethod, toMethod);
    }
}

void hy_swizzleTwoInstanceMethods(Class fromCls, SEL fromSel, Class toCls, SEL toSel) {
    
    if (!fromCls || !toCls || !fromSel || !toSel) { return;}
    
    Class fromClass = objc_getClass(NSStringFromClass(fromCls).UTF8String);
    Class toClass = objc_getClass(NSStringFromClass(toCls).UTF8String);
    
    Method fromMethod = class_getInstanceMethod(fromClass, fromSel);
    Method toMethod = class_getInstanceMethod(toClass, toSel);
    
    if (!toMethod) {return;}
    
    if (class_addMethod(fromClass,
                        fromSel,
                        method_getImplementation(toMethod),
                        method_getTypeEncoding(toMethod))) {
        
        class_replaceMethod(toClass,
                            toSel,
                            method_getImplementation(fromMethod),
                            method_getTypeEncoding(fromMethod));
        
    } else {
        
        class_replaceMethod(toClass,
                            toSel,
                            class_replaceMethod(fromClass,
                                                fromSel,
                                                method_getImplementation(toMethod),
                                                method_getTypeEncoding(toMethod)),
                            method_getTypeEncoding(fromMethod));
        
//        method_exchangeImplementations(fromMethod, toMethod);
    }
}

void hy_swizzleClassMethod(Class cls, SEL originSelector, SEL swizzleSelector) {
     hy_swizzleTwoClassMethods(cls, originSelector, cls, swizzleSelector);
}

void hy_swizzleInstanceMethod(Class cls, SEL originSelector, SEL swizzleSelector) {
     hy_swizzleTwoInstanceMethods(cls, originSelector, cls, swizzleSelector);
}

void hy_swizzleClassMethods(id cls, NSArray<NSString *> *methods) {
    
    if ([cls isKindOfClass:NSArray.class] || [cls isKindOfClass:NSMutableArray.class]) {
        [((NSArray *)cls) enumerateObjectsUsingBlock:^(NSString *  _Nonnull classString, NSUInteger idx, BOOL * _Nonnull stop) {
            [methods enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                hy_swizzleClassMethod(NSClassFromString(classString),
                                      NSSelectorFromString(obj),
                                      NSSelectorFromString([NSString stringWithFormat:@"hy_%@",obj]));
            }];
        }];
    } else {
        [methods enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            hy_swizzleClassMethod(cls,
                                  NSSelectorFromString(obj),
                                  NSSelectorFromString([NSString stringWithFormat:@"hy_%@",obj]));
        }];
    }
}


void hy_swizzleInstanceMethods(id cls, NSArray<NSString *> *methods) {
    
    if ([cls isKindOfClass:NSArray.class] || [cls isKindOfClass:NSMutableArray.class]) {
        [((NSArray *)cls) enumerateObjectsUsingBlock:^(NSString *  _Nonnull classString, NSUInteger idx, BOOL * _Nonnull stop) {
            [methods enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                hy_swizzleInstanceMethod(NSClassFromString(classString),
                                         NSSelectorFromString(obj),
                                         NSSelectorFromString([NSString stringWithFormat:@"hy_%@",obj]));
            }];
        }];
    } else {
        [methods enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            hy_swizzleInstanceMethod(cls,
                                     NSSelectorFromString(obj),
                                     NSSelectorFromString([NSString stringWithFormat:@"hy_%@",obj]));
        }];
    }
}

void hy_swizzleClassMethodToBlock(Class cls, SEL sel, id(^implementationBlock)(SEL sel, IMP(^impBlock)(void))) {
    
    if (!cls || !sel) { return; }
    
    Class metaClas = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    
    __block IMP originalIMP = NULL;
    IMP (^impBlock)(void) = ^{
        IMP imp = originalIMP;
        if (NULL == imp){
            imp = method_getImplementation(class_getClassMethod(class_getSuperclass(metaClas),sel));
        }
        return imp;
    };
    
    originalIMP = class_replaceMethod(objc_getMetaClass(NSStringFromClass(cls).UTF8String),
                                      sel,
                                      imp_implementationWithBlock(implementationBlock(sel, impBlock)),
                                      method_getTypeEncoding(class_getClassMethod(cls, sel)));
}

void hy_swizzleInstanceMethodToBlock(Class cls, SEL sel, id(^implementationBlock)(SEL sel, IMP(^impBlock)(void))) {
    
    if (!cls || !sel) { return; }
    
    Class clas = objc_getClass(NSStringFromClass(cls).UTF8String);
    
    __block IMP originalIMP = NULL;
    IMP (^impBlock)(void) = ^{
        IMP imp = originalIMP;
        if (NULL == imp){
            imp = method_getImplementation(class_getInstanceMethod(class_getSuperclass(clas),sel));
        }
        return imp;
    };
    
    originalIMP = class_replaceMethod(clas,
                                      sel,
                                      imp_implementationWithBlock(implementationBlock(sel, impBlock)),
                                      method_getTypeEncoding(class_getInstanceMethod(cls, sel)));
}

void hy_swizzleClassVoidMethodToBlock(Class cls, SEL sel, void(^implementationBlock)(Class cls)) {
    hy_swizzleClassMethodToBlock(cls, sel, ^id(SEL sel, IMP (^impBlock)(void)) {
        return ^(Class _cls){
            
            !implementationBlock ?: implementationBlock(cls);
//            void (*impFuction)(Class, SEL) = (void *)impBlock();
//            if (impFuction != NULL) {
//                impFuction(cls, sel);
//            }
            IMP imp = impBlock();
            if (imp != NULL) {
                ((void (*)(Class, SEL))imp)(_cls, sel);
            }
        };
    });
}

void hy_swizzleInstanceVoidMethodToBlock(Class cls, SEL sel, void(^implementationBlock)(id)) {
    hy_swizzleInstanceMethodToBlock(cls, sel, ^id(SEL sel, IMP (^impBlock)(void)) {
        return ^(id _self){
            
            !implementationBlock ?: implementationBlock(_self);
            IMP imp = impBlock();
            if (imp != NULL) {
                ((void (*)(id, SEL))imp)(_self, sel);
            }
            
//          void (*impFuction)(id, SEL) = (void *)impBlock();
//          if (impFuction != NULL) {
//             impFuction(_self, sel);
//          }
        };
    });
}

void hy_swizzleAndResetClassMethodToBlock(Class cls, SEL sel, id(^implementationBlock)(SEL sel, IMP(^impBlock)(void), void(^resetImpBlock)(void))) {
    
    if (!cls || !sel) { return; }
    
    Class metaClas = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    
    __block IMP originalIMP = NULL;
    IMP (^impBlock)(void) = ^{
        IMP imp = originalIMP;
        if (NULL == imp){
            imp = method_getImplementation(class_getClassMethod(class_getSuperclass(metaClas),sel));
        }
        return imp;
    };
    
    void (^resetImpBlock)(void) = ^{
        IMP imp = impBlock();
        if (imp) {
//           id impBlock = imp_getBlock(hy_getClassMethodIMP(cls, sel));
//           imp_removeBlock(hy_getClassMethodIMP(cls, sel));
            class_replaceMethod(metaClas,
                                sel,
                                imp,
                                method_getTypeEncoding(class_getClassMethod(cls, sel)));
        }
    };
    
    originalIMP = class_replaceMethod(objc_getMetaClass(NSStringFromClass(cls).UTF8String),
                                      sel,
                                      imp_implementationWithBlock(implementationBlock(sel, impBlock,resetImpBlock)),
                                      method_getTypeEncoding(class_getClassMethod(cls, sel)));
}

void hy_swizzleAndResetInstanceMethodToBlock(Class cls, SEL sel, id(^implementationBlock)(SEL sel, IMP(^impBlock)(void), void(^resetImpBlock)(void))) {
    
    if (!cls || !sel) { return; }
    
    Class clas = objc_getClass(NSStringFromClass(cls).UTF8String);
    
    
    __block IMP originalIMP = NULL;
    IMP (^impBlock)(void) = ^{
        IMP imp = originalIMP;
        if (NULL == imp){
            imp = method_getImplementation(class_getInstanceMethod(class_getSuperclass(clas),sel));
        }
        return imp;
    };
    
    void (^resetImpBlock)(void) = ^{
        IMP imp = impBlock();
        if (imp) {
//           id impBlock = imp_getBlock(hy_getInstanceMethodIMP(clas, sel));
//           imp_removeBlock(hy_getInstanceMethodIMP(clas, sel));
            class_replaceMethod(clas,
                                sel,
                                imp,
                                method_getTypeEncoding(class_getInstanceMethod(clas, sel)));
        }
    };
    
    originalIMP = class_replaceMethod(clas,
                                      sel,
                                      imp_implementationWithBlock(implementationBlock(sel, impBlock,resetImpBlock)),
                                      method_getTypeEncoding(class_getInstanceMethod(cls, sel)));
}


void hy_swizzleAndResetClassVoidMethodToBlock(Class cls, SEL sel, void(^implementationBlock)(Class cls, void(^resetImpBlock)(void))) {
    
    hy_swizzleAndResetClassMethodToBlock(cls, sel, ^id(SEL sel, IMP (^impBlock)(void), void (^resetImpBlock)(void)) {
        return ^(Class _cls){
            
            !implementationBlock ?: implementationBlock(_cls, resetImpBlock);

            IMP imp = impBlock();
            if (imp != NULL) {
                ((void (*)(Class, SEL))imp)(_cls, sel);
            }
        };
    });
}

void hy_swizzleAndResetInstanceVoidMethodToBlock(Class cls, SEL sel, void(^implementationBlock)(id _self, void(^resetImpBlock)(void))) {
    
    hy_swizzleAndResetInstanceMethodToBlock(cls, sel, ^id(SEL sel, IMP (^impBlock)(void), void (^resetImpBlock)(void)) {
        return ^(id _self){
            
            !implementationBlock ?: implementationBlock(_self, resetImpBlock);
            
            IMP imp = impBlock();
            if (imp != NULL) {
                ((void (*)(id, SEL))imp)(_self, sel);
            }
        };
    });
}

BOOL hy_addClassMethod(Class cls, SEL sel, NSString *types, id implementationBlock) {
    
    if (!cls || !sel || !implementationBlock) {
        return NO;
    }
    
    Class metaClas = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    IMP imp = imp_implementationWithBlock(implementationBlock);
    if (!types) {
        types = @"v@:";
    }
    return class_addMethod(metaClas, sel, imp, types.UTF8String);
}

BOOL hy_addInstanceMethod(Class cls, SEL sel, NSString *types, id implementationBlock) {
    
    if (!cls || !sel || !implementationBlock) {
        return NO;
    }
    
    Class clas = objc_getClass(NSStringFromClass(cls).UTF8String);
    IMP imp = imp_implementationWithBlock(implementationBlock);
    if (!types) {
        types = @"v@:";
    }
    return class_addMethod(clas, sel, imp, types.UTF8String);
}

BOOL hy_addClass(Class supperClass, NSString *className) {
    if (!supperClass || !className) {
        return NO;
    }
    
    Class supClas = objc_getClass(NSStringFromClass(supperClass).UTF8String);
    const char *clasName = [className cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(clasName);
    if (!newClass && supClas){
        objc_registerClassPair(objc_allocateClassPair(supClas, clasName, 0));
        return YES;
    }
    return NO;
}

NSArray<NSString *> *hy_getIvarList(Class cls) {
    
    NSMutableArray *ivarList = @[].mutableCopy;
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(cls, &count);
    for (int i = 0; i<count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        [ivarList addObject:key];
    }
    free(ivars);
    return ivarList;
}

NSArray<NSString *> *hy_getPropertyList(Class cls) {
    
    NSMutableArray *propertyList = @[].mutableCopy;
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList(cls, &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = propertys[i];
        const char *name = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:name];
        [propertyList addObject:key];
    }
    free(propertys);
    return propertyList;
}

NSArray<NSString *> *hy_getMethodList(Class cls) {
    
    NSMutableArray *methodList = @[].mutableCopy;
    unsigned int count = 0;
    Method *methods = class_copyMethodList(cls, &count);
    for (int i = 0; i<count; i++) {
        Method method = methods[i];
        NSString *name = NSStringFromSelector(method_getName(method));
        [methodList addObject:name];
    }
    free(methods);
    return methodList;
}

NSArray<NSString *> *hy_getProtocolList(Class cls) {
    
    NSMutableArray *protocolList = @[].mutableCopy;
    unsigned int count = 0;
    Protocol * __unsafe_unretained _Nonnull *protocols = class_copyProtocolList(cls, &count);
    for (int i = 0; i<count; i++) {
        
        Protocol *protocol = protocolList[i];
        const char *name = protocol_getName(protocol);
        NSString *key = [NSString stringWithUTF8String:name];
        [protocolList addObject:key];
    }
    free(protocols);
    return protocolList;
}

BOOL hy_checkClass(NSString *className) {
    if (!className.length) {
        return NO;
    }
    
    const char *classNameChar = [className cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(classNameChar);
    if (!newClass) {
        return NO;
    }
    return YES;
}

BOOL hy_checkIvar(Class cls , NSString *ivar) {
    
    if (!cls || !ivar) { return NO;}
    return class_getInstanceVariable(cls, [ivar cStringUsingEncoding:NSUTF8StringEncoding]) != NULL;
}

BOOL hy_checkProperty(Class cls , NSString *property) {
    
    if (!cls || !property) { return NO;}
    return class_getProperty(cls, [property cStringUsingEncoding:NSUTF8StringEncoding]) != NULL;
}

BOOL hy_checkInstanceMethod(Class cls , SEL sel) {
    
    if (!cls || !sel) { return NO;}
    return class_getInstanceMethod(cls, sel) != nil;
}

BOOL hy_checkClassMethod(Class cls , SEL sel) {
    
    if (!cls || !sel) { return NO;}
    return class_getClassMethod(cls, sel) != nil;
}

BOOL hy_checkOverrideSuperClassMethod(Class cls , SEL sel) {
    
    if (!cls || !sel) { return NO;}
    
    Class metacls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    Method method = class_getClassMethod(metacls, sel);
    if (!method) return NO;
    
    Method methodOfSuperclass = class_getClassMethod(class_getSuperclass(metacls), sel);
    if (!methodOfSuperclass) return YES;
    
    return method != methodOfSuperclass;
}

BOOL hy_checkOverrideSuperInstanceMethod(Class cls , SEL sel) {
    
    if (!cls || !sel) { return NO;}
    
    Class clas = objc_getClass(NSStringFromClass(cls).UTF8String);
    Method method = class_getInstanceMethod(clas, sel);
    if (!method) return NO;
    
    Method methodOfSuperclass = class_getInstanceMethod(class_getSuperclass(clas), sel);
    if (!methodOfSuperclass) return YES;
    
    return method != methodOfSuperclass;
}

IMP hy_getClassMethodIMP(Class cls, SEL sel) {
    
    if (!cls || !sel) {return NULL;}
    Method classMethod = class_getClassMethod(objc_getClass(NSStringFromClass(cls).UTF8String), sel);
    return method_getImplementation(classMethod);
    
//    if (!class_isMetaClass(cls)) {
//       cls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
//    }
//    return class_getMethodImplementation(cls, sel);
}

IMP hy_getInstanceMethodIMP(Class cls, SEL sel) {
    
    if (!cls || !sel) {return NULL;}
    Method instanceMethod = class_getInstanceMethod(objc_getClass(NSStringFromClass(cls).UTF8String), sel);
    return method_getImplementation(instanceMethod);
    
//    if (class_isMetaClass(cls)) {
//        cls = objc_getClass(NSStringFromClass(cls).UTF8String);
//    }
//   return class_getMethodImplementation(cls, sel);
}


NSString *hy_getClassMethodTypes(Class cls, SEL sel) {
    
    if (!cls || !sel) { return nil;}
    
//    NSMethodSignature *signature = [objc_getMetaClass(NSStringFromClass(cls).UTF8String) instanceMethodSignatureForSelector:sel];
//    SEL selector = sel_registerName("_typeString");
//    const char *typeEncoding = ((NSString *(*)(id, SEL))[signature methodForSelector:selector])(signature,selector).UTF8String;
    
    Method classMethod = class_getClassMethod(objc_getClass(NSStringFromClass(cls).UTF8String), sel);
    if (classMethod) {
        return [NSString stringWithUTF8String:method_getTypeEncoding(classMethod)];
    }
    return nil;
}

NSString *hy_getInstanceMethodTypes(Class cls, SEL sel) {
    
    if (!cls || !sel) { return nil;}
    
//    NSMethodSignature *signature = [objc_getClass(NSStringFromClass(cls).UTF8String) instanceMethodSignatureForSelector:sel];
//    SEL selector = sel_registerName("_typeString");
//    const char *typeEncoding = ((NSString *(*)(id, SEL))[signature methodForSelector:selector])(signature,selector).UTF8String;
    
    Method instanceMethod = class_getInstanceMethod(objc_getClass(NSStringFromClass(cls).UTF8String), sel);
    if (instanceMethod) {
        return [NSString stringWithUTF8String:method_getTypeEncoding(instanceMethod)];
    }
    return nil;
    
//    NSPropertyListSerialization;
}

