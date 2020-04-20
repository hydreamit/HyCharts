//
//  NSMethodSignature+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMethodSignature (HyExtension)

@property (nonatomic,readonly,nullable) const char *hy_typeEncoding;
@property (nonatomic,copy,readonly,nullable) NSString *hy_typeString;

+ (instancetype)hy_classMethodSignatureWithClass:(Class)cls selector:(SEL)sel;

+ (instancetype)hy_instanceMethodSignatureWithClass:(Class)cls selector:(SEL)sel;

@end

NS_ASSUME_NONNULL_END
