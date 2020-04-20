//
//  UIDevice+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (HyExtension)

+ (double)hy_systemVersion;

+ (BOOL)hy_isPad;
+ (BOOL)hy_isSimulator;

+ (NSString *)hy_ipAddressWIFI;
+ (NSString *)hy_ipAddressCell;

+ (NSUInteger)hy_cpuCount;
+ (float)hy_cpuUsage;
+ (NSArray<NSNumber *> *)hy_cpuUsagePerProcessor;

@end

NS_ASSUME_NONNULL_END

#ifndef Hy_kSystemVersion
#define Hy_kSystemVersion [UIDevice hy_systemVersion]
#endif

#ifndef Hy_iOS6Later
#define Hy_iOS6Later (Hy_kSystemVersion >= 6)
#endif

#ifndef Hy_iOS7Later
#define Hy_iOS7Later (Hy_kSystemVersion >= 7)
#endif

#ifndef Hy_iOS8Later
#define Hy_iOS8Later (Hy_kSystemVersion >= 8)
#endif

#ifndef Hy_iOS9Later
#define Hy_iOS9Later (Hy_kSystemVersion >= 9)
#endif

#ifndef Hy_iOS10Later
#define Hy_iOS10Later (Hy_kSystemVersion >= 10)
#endif

#ifndef Hy_iOS11Later
#define Hy_iOS11Later (Hy_kSystemVersion >= 11)
#endif

#ifndef Hy_iOS12Later
#define Hy_iOS12Later (Hy_kSystemVersion >= 12)
#endif

