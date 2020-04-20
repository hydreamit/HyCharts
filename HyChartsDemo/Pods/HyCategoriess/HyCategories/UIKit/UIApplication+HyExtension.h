//
//  UIApplication+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/9/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (HyExtension)

+ (UIResponder<UIApplicationDelegate> *)hy_appDelegate;

+ (NSURL *)hy_documentsURL;
+ (NSString *)hy_documentsPath;

+ (NSURL *)hy_cachesURL;
+ (NSString *)hy_cachesPath;

+ (NSURL *)hy_libraryURL;
+ (NSString *)hy_libraryPath;

+ (NSString *)hy_appBuildVersion;
+ (NSString *)hy_appBundleName;
+ (NSString *)hy_appBundleID;
+ (NSString *)hy_appVersion;

+ (BOOL)hy_fileExistInMainBundle:(NSString *)name;

@end

NS_ASSUME_NONNULL_END


