//
//  NSInvocation+HyExtension.m
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "NSInvocation+HyExtension.h"

@implementation NSInvocation (HyExtension)

+ (instancetype)hy_invocationWithTarget:(id)target
                               selector:(SEL)selector
                            returnValue:(void *)returnValue
                              arguments:(void *)argument, ... {
    
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    if (!signature) {[target doesNotRecognizeSelector:selector]; return nil;}
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    if (!invocation) { [target doesNotRecognizeSelector:selector]; return nil; }
    
    [invocation setTarget:target];
    [invocation setSelector:selector];
    
    if (argument) {
        va_list valist;
        va_start(valist, argument);
        
        [invocation setArgument:argument atIndex:2];
        void *currentArgument;
        NSInteger index = 3;
        while ((currentArgument = va_arg(valist, void *))) {
            [invocation setArgument:currentArgument atIndex:index];
            index++;
        }
        va_end(valist);
    }
    
    [invocation invoke];
    
    if (returnValue) {
        [invocation getReturnValue:returnValue];
    }
    
    return invocation;
}

@end
