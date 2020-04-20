//
//  HyRunTimeMethods.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/5/10.
//  Copyright © 2017 Hy. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <objc/message.h>


// ClassMethod
void hy_swizzleTwoClassMethods(Class fromCls, SEL fromSel, Class toCls, SEL toSel);
void hy_swizzleClassMethod(Class cls, SEL originSelector, SEL swizzleSelector);
void hy_swizzleClassMethods(id cls, NSArray<NSString *> *methods);
void hy_swizzleClassMethodToBlock(Class cls, SEL sel, id(^implementationBlock)(SEL sel, IMP(^impBlock)(void)));
void hy_swizzleClassVoidMethodToBlock(Class cls, SEL sel, void(^implementationBlock)(Class cls));
void hy_swizzleAndResetClassMethodToBlock(Class cls, SEL sel, id(^implementationBlock)(SEL sel, IMP(^impBlock)(void), void(^resetImpBlock)(void)));
void hy_swizzleAndResetClassVoidMethodToBlock(Class cls, SEL sel, void(^implementationBlock)(Class cls, void(^resetImpBlock)(void)));


// InstanceMethod
void hy_swizzleTwoInstanceMethods(Class fromCls, SEL fromSel, Class toCls, SEL toSel);
void hy_swizzleInstanceMethod(Class cls, SEL originSelector, SEL swizzleSelector);
void hy_swizzleInstanceMethods(id cls, NSArray<NSString *> *methods);
void hy_swizzleInstanceMethodToBlock(Class cls, SEL sel, id(^implementationBlock)(SEL sel, IMP(^impBlock)(void)));
void hy_swizzleInstanceVoidMethodToBlock(Class cls, SEL sel, void(^implementationBlock)(id _self));
void hy_swizzleAndResetInstanceMethodToBlock(Class cls, SEL sel, id(^implementationBlock)(SEL sel, IMP(^impBlock)(void), void(^resetImpBlock)(void)));
void hy_swizzleAndResetInstanceVoidMethodToBlock(Class cls, SEL sel, void(^implementationBlock)(id _self, void(^resetImpBlock)(void)));


BOOL hy_addClass(Class supperClass, NSString *className);
BOOL hy_addClassMethod(Class cls, SEL sel, NSString *types, id implementationBlock);
BOOL hy_addInstanceMethod(Class cls, SEL sel, NSString *types, id implementationBlock);


IMP hy_getClassMethodIMP(Class cls, SEL sel);
IMP hy_getInstanceMethodIMP(Class cls, SEL sel);


NSString *hy_getClassMethodTypes(Class cls, SEL sel);
NSString *hy_getInstanceMethodTypes(Class cls, SEL sel);


NSArray<NSString *> *hy_getIvarList(Class cls);
NSArray<NSString *> *hy_getPropertyList(Class cls);
NSArray<NSString *> *hy_getMethodList(Class cls);
NSArray<NSString *> *hy_getProtocolList(Class cls);


BOOL hy_checkClass(NSString *className);
BOOL hy_checkIvar(Class cls , NSString *ivar);
BOOL hy_checkProperty(Class cls , NSString *property);
BOOL hy_checkInstanceMethod(Class cls , SEL sel);
BOOL hy_checkClassMethod(Class cls , SEL sel);
BOOL hy_checkOverrideSuperClassMethod(Class cls , SEL sel);
BOOL hy_checkOverrideSuperInstanceMethod(Class cls , SEL sel);



#define HyImpFuctoin(_imp, ...) \
{\
IMP __imp = _imp; \
if (__imp != NULL) { \
((void (*)(id , SEL,...))__imp)(__VA_ARGS__); \
}\
}

#define HyValueImpFuctoin(_imp, _type,...) \
({ \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wsometimes-uninitialized\"") \
_type _value; \
IMP __imp = _imp; \
if (__imp != NULL) { \
_value = ((_type (*)(id , SEL,...))__imp)(__VA_ARGS__); \
} \
_value; \
_Pragma("clang diagnostic pop") \
})

#define HyVoidImpFuctoin(...) HyImpFuctoin(impBlock(), __VA_ARGS__)
#define HyObjectImpFuctoin(...) HyValueImpFuctoin(impBlock(), id, __VA_ARGS__)
#define HyIntImpFuctoin(...) HyValueImpFuctoin(impBlock(), Int, __VA_ARGS__)
#define HyFloatImpFuctoin(...) HyValueImpFuctoin(impBlock(), float, __VA_ARGS__)
#define HyDoubleImpFuctoin(...) HyValueImpFuctoin(impBlock(), double, __VA_ARGS__)
#define HyBoolImpFuctoin(...) HyValueImpFuctoin(impBlock(), BOOL, __VA_ARGS__)
#define HyNSIntegerImpFuctoin(...) HyValueImpFuctoin(impBlock(), NSInteger, __VA_ARGS__)
#define HyNSUIntegerImpFuctoin(...) HyValueImpFuctoin(impBlock(), NSUInteger, __VA_ARGS__)
#define HyCGFloatImpFuctoin(...) HyValueImpFuctoin(impBlock(), CGFloat, __VA_ARGS__)
#define HyCGPointImpFuctoin(...) HyValueImpFuctoin(impBlock(), CGPoint, __VA_ARGS__)
#define HyCGSizeImpFuctoin(...) HyValueImpFuctoin(impBlock(), CGSize, __VA_ARGS__)
#define HyCGRectImpFuctoin(...) HyValueImpFuctoin(impBlock(), CGRect, __VA_ARGS__)
#define HyUIEdgeInsetsImpFuctoin(...) HyValueImpFuctoin(impBlock(), UIEdgeInsets, __VA_ARGS__)


#define HyMsgSend(_type, ...) ((_type (*)(id, SEL,...))objc_msgSend)(__VA_ARGS__)
#define HyVoidMsgSend(...) HyMsgSend(void, __VA_ARGS__)
#define HyObjectMsgSend(...) HyMsgSend(id, __VA_ARGS__)
#define HyIntMsgSend(...) HyMsgSend(Int, __VA_ARGS__)
#define HyFloatMsgSend(...) HyMsgSend(float, __VA_ARGS__)
#define HyDoubleMsgSend(...) HyMsgSend(double, __VA_ARGS__)
#define HyBoolMsgSend(...) HyMsgSend(BOOL, __VA_ARGS__)
#define HyNSIntegerMsgSend(...) HyMsgSend(NSInteger, __VA_ARGS__)
#define HyNSUIntegerMsgSend(...) HyMsgSend(NSUInteger, __VA_ARGS__)
#define HyCGFloatMsgSend(...) HyMsgSend(CGFloat, __VA_ARGS__)
#define HyCGPointMsgSend(...) HyMsgSend(CGPoint, __VA_ARGS__)
#define HyCGSizeMsgSend(...) HyMsgSend(CGSize, __VA_ARGS__)
#define HyCGRectMsgSend(...) HyMsgSend(CGRect, __VA_ARGS__)
#define HyUIEdgeInsetsMsgSend(...) HyMsgSend(UIEdgeInsets, __VA_ARGS__)


#define HyMsgSendSuper(_type, _reccciver,...) \
({ \
struct objc_super _super = { \
.receiver = _reccciver, \
.super_class = class_getSuperclass(object_getClass(_reccciver)) \
}; \
((_type (*)(struct objc_super *, SEL,...))objc_msgSendSuper)(&_super, __VA_ARGS__); \
})

#define HyVoidMsgSendSuper(_reciver, ...) HyMsgSendSuper(void, _reciver, __VA_ARGS__)
#define HyObjectMsgSendSuper(_reciver,...) HyMsgSendSuper(id, _reciver, __VA_ARGS__)
#define HyIntMsgSendSuper(_reciver,...) HyMsgSendSuper(Int, _reciver, __VA_ARGS__)
#define HyFloatMsgSendSuper(_reciver,...) HyMsgSendSuper(float, _reciver, __VA_ARGS__)
#define HyDoubleMsgSendSuper(_reciver,...) HyMsgSendSuper(double, _reciver, __VA_ARGS__)
#define HyBoolMsgSendSuper(_reciver,...) HyMsgSendSuper(BOOL, _reciver, __VA_ARGS__)
#define HyNSIntegerMsgSendSuper(_reciver,...) HyMsgSendSuper(NSInteger, _reciver, __VA_ARGS__)
#define HyNSUIntegerMsgSendSuper(_reciver,...) HyMsgSendSuper(NSUInteger, _reciver, __VA_ARGS__)
#define HyCGFloatMsgSendSuper(_reciver,...) HyMsgSendSuper(CGFloat, _reciver, __VA_ARGS__)
#define HyCGPointMsgSendSuper(_reciver,...) HyMsgSendSuper(CGPoint, _reciver, __VA_ARGS__)
#define HyCGSizeMsgSendSuper(_reciver,...) HyMsgSendSuper(CGSize, _reciver, __VA_ARGS__)
#define HyCGRectMsgSendSuper(_reciver,...) HyMsgSendSuper(CGRect, _reciver, __VA_ARGS__)
#define HyUIEdgeInsetsMsgSendSuper(_reciver,...) HyMsgSendSuper(UIEdgeInsets, _reciver, __VA_ARGS__)
