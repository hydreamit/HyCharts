//
//  NSInvocation+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSInvocation (HyExtension)

+ (instancetype)hy_invocationWithTarget:(id)target
                               selector:(SEL)selector
                            returnValue:(void *)returnValue
                              arguments:(void *)argument, ...;

@end

NS_ASSUME_NONNULL_END
